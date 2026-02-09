import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:web/web.dart';
import 'package:flutter_tex/src/tex_server/tex_rendering_server_web.dart';
import 'package:flutter_tex/src/tex_view/tex_view.dart';
import 'package:flutter_tex/src/tex_view/utils/core_utils.dart';

/// The Web-specific implementation state for [TeXView].
///
/// This class utilizes an `iframe` element to host the TeX rendering engine.
/// It uses `dart:js_interop` to communicate seamlessly with the JavaScript context
/// running inside the iframe.
///
/// Advantages over standard WebView:
/// 1.  Leightweight `iframe` element.
/// 2.  Direct JS interop (faster than channel messages).
class TeXViewState extends State<TeXView>
    with AutomaticKeepAliveClientMixin<TeXView> {
  /// A global unique identifier for the iframe to differentiate between multiple views in the DOM.
  final String _iframeId = UniqueKey().toString();

  /// The standard HTML iframe element used as the container.
  late final HTMLIFrameElement iframeElement;

  /// Stream to pass the calculated height from JS to the Flutter UI layer.
  final StreamController<double> heightStreamController = StreamController();

  /// Reference to the iframe's internal window object for calling functions.
  late final Window _iframeContentWindow;

  /// Cache for de-duplicating render calls.
  String _oldRawData = '';

  /// Web loading state flag.
  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    // Configure the iframe element
    iframeElement = HTMLIFrameElement()
      ..id = _iframeId
      ..src = "assets/packages/flutter_tex/core/flutter_tex.html"
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.border = '0';

    // Register this instance so the global JS controller can route events back to us.
    TeXRenderingControllerWeb.registerInstance(_iframeId, this);

    // Wait for the 'load' event. This guarantees the iframe content (scripts) are fully parsed.
    iframeElement.onLoad.listen((_) {
      _iframeContentWindow = iframeElement.contentWindow!;
      _isReady = true;
      _renderTeXView(); // Perform the first render immediately after load.
    });

    // Register the HTML element as a Platform View in Flutter Web.
    platformViewRegistry.registerViewFactory(
        _iframeId, (int viewId) => iframeElement);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin.
    // Ensure we check for updates on every build (e.g. if dependencies changed).
    // The internal de-duplication logic prevents unnecessary JS calls.
    _renderTeXView();

    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
          // We use HtmlElementView to embed the iframe in the Flutter tree.
          return SizedBox(
            height: snap.hasData && !snap.hasError ? snap.data! : initialHeight,
            child: HtmlElementView(
              key: widget.key ?? ValueKey(_iframeId),
              viewType: _iframeId,
            ),
          );
        });
  }

  /// Handles tap events routed from JavaScript.
  void onTap(JSString tapId) => widget.child.onTapCallback(tapId.toDart);

  void onWheel(JSNumber deltaY) {
    if (widget.scrollController?.position.isScrollingNotifier.value == false) {
      final delta = double.parse(deltaY.toString());
      final scaleFactor = 1.0;
      final adjustedDelta = delta * scaleFactor;
      if (delta.abs() < 10) {
        widget.scrollController?.position.jumpTo(
            widget.scrollController!.position.pixels + adjustedDelta);
      } else {
        final duration = Duration(
            milliseconds: (20 + delta.abs() * 0.5).clamp(20, 150).toInt());

        widget.scrollController?.position.animateTo(
          widget.scrollController!.position.pixels + adjustedDelta,
          duration: duration,
          curve: Curves.linear,
        );
      }
    }
  }

  /// Handles height updates routed from JavaScript.
  void onTeXViewRendered(JSNumber h) {
    // Add offset to prevent scrollbar flickering due to sub-pixel rendering differences.
    double height = h.toDartDouble + widget.heightOffset;

    if (mounted) {
      heightStreamController.add(height);
      widget.onRenderFinished?.call(height);
    }
  }

  /// Asynchronously updates the TeX content in the IFrame.
  ///
  /// **Optimization Note**:
  /// Uses [Future.microtask] to schedule the update *after* the current build frame,
  /// preventing "setState() called during build" errors and ensuring smoother UI performance.
  void _renderTeXView() async {
    if (!_isReady) {
      return;
    }

    await Future.microtask(() async {
      // Guard: Ensure widget didn't dispose while waiting for microtask.
      if (!mounted) return;

      // Heavy lifting (JSON encoding) happens here, potentially in background isolate.
      String currentRawData = await getRawDataAsync(widget);

      // Guard again after async gap.
      if (!mounted) return;

      if (currentRawData != _oldRawData) {
        _oldRawData = currentRawData;
        // Direct JS Interop call to update the content.
        initTeXView(_iframeContentWindow, currentRawData, true, _iframeId);
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      heightStreamController.close();
    }
    // Critical cleanup: Remove reference from global controller to prevent memory leaks.
    TeXRenderingControllerWeb.unregisterInstance(_iframeId);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
