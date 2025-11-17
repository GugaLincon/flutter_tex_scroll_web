import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:web/web.dart';
import 'package:flutter_tex/src/tex_server/tex_rendering_server_web.dart';
import 'package:flutter_tex/src/tex_view/tex_view.dart';
import 'package:flutter_tex/src/tex_view/utils/core_utils.dart';

/// The state for the [TeXView] widget on the web.
///
/// This class manages an `iframe` element to render TeX content. It communicates
/// with the JavaScript rendering engine within the `iframe` using `dart:js_interop`.
class TeXViewState extends State<TeXView>
    with AutomaticKeepAliveClientMixin<TeXView> {
  /// A unique ID for the `iframe` element to ensure it can be identified in the DOM.
  final String _iframeId = UniqueKey().toString();

  /// The `iframe` element that will host the TeX rendering engine.
  ///
  /// It is configured to load the necessary HTML file, fill its container,
  /// and have no border.
  late final HTMLIFrameElement iframeElement;

  /// A stream controller to manage the height of the `iframe`.
  ///
  /// The `iframe`'s content height is determined asynchronously, and this stream
  /// is used to update the Flutter widget's size.
  final StreamController<double> heightStreamController = StreamController();

  /// The `window` object of the `iframe`, used for JavaScript interop.
  late final Window _iframeContentWindow;

  /// Caches the last rendered data to avoid unnecessary re-renders.
  String _oldRawData = '';

  /// A flag to indicate if the `iframe` is loaded and ready for communication.
  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    // Create and configure the iframe element.
    iframeElement = HTMLIFrameElement()
      ..id = _iframeId
      ..src = "assets/packages/flutter_tex/core/flutter_tex.html"
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.border = '0';

    // Register this state instance with the web controller to receive callbacks.
    TeXRenderingControllerWeb.registerInstance(_iframeId, this);

    // Listen for the 'load' event on the iframe to know when it's ready.
    iframeElement.onLoad.listen((_) {
      _iframeContentWindow = iframeElement.contentWindow!;
      _isReady = true;
      _renderTeXView(); // Trigger the first render.
    });

    // Register the iframe element with Flutter's platform view registry.
    platformViewRegistry.registerViewFactory(
        _iframeId, (int viewId) => iframeElement);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessary for AutomaticKeepAliveClientMixin.
    _renderTeXView();

    // The widget's size is determined by the height received from the stream.
    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
          return SizedBox(
            height: snap.hasData && !snap.hasError ? snap.data! : initialHeight,
            child: HtmlElementView(
              key: widget.key ?? ValueKey(_iframeId),
              viewType: _iframeId,
            ),
          );
        });
  }

  /// Callback triggered from JavaScript when a tap event occurs.
  void onTap(JSString tapId) => widget.child.onTapCallback(tapId.toDart);

  /// Callback triggered from JavaScript when the TeX content has rendered.
  void onTeXViewRendered(JSNumber h) {
    // The height is received from JS and an offset is added.
    double height = h.toDartDouble + widget.heightOffset;

    if (mounted) {
      heightStreamController.add(height);
      widget.onRenderFinished?.call(height);
    }
  }

  /// Triggers the rendering of the TeX content in the `iframe`.
  ///
  /// This method generates the raw data from the widget's properties,
  /// and if it has changed, it calls the JavaScript function `initTeXViewWeb`
  /// to update the content.
  void _renderTeXView() {
    if (!_isReady) {
      return; // Don't render if the iframe isn't ready.
    }
    String currentRawData = getRawData(widget);
    if (currentRawData != _oldRawData) {
      initTeXViewWeb(_iframeContentWindow, _iframeId, currentRawData);
      _oldRawData = currentRawData;
    }
  }

  @override
  void dispose() {
    if (mounted) {
      heightStreamController.close();
    }
    // Unregister the instance to prevent memory leaks.
    TeXRenderingControllerWeb.unregisterInstance(_iframeId);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
