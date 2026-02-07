import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/globals.dart';
import 'package:flutter_tex/src/tex_server/tex_rendering_server_mobile.dart';
import 'package:flutter_tex/src/tex_view/utils/core_utils.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart'
    show WebViewWidget;

/// The Mobile (Android/iOS) implementation state for [TeXView].
///
/// This class orchestrates the interaction between the Flutter UI and a local [WebView].
/// It is responsible for:
/// 1.  Managing the [WebViewWidget] and its controller.
/// 2.  Bridging rendering requests (converting Dart objects to JSON and sending to JS).
/// 3.  Hearing back from JS (height updates, tap events).
/// 4.  Optimizing rendering performance via caching and async dispatching.
class TeXViewState extends State<TeXView>
    with AutomaticKeepAliveClientMixin<TeXView> {
  /// Broadcasts the calculated content height from the JS engine to the Flutter UI.
  final StreamController<double> heightStreamController = StreamController();

  /// The rendering controller instance. Can be shared (if `multiTeXView` is false)
  /// or unique per instance.
  late final TeXRenderingController teXRenderingController;

  /// Indicates whether the internal WebView controller has been initialized.
  bool _isReady = false;

  /// Cache of the last transmitted data string to prevent redundant JS calls.
  String _oldRawData = "";

  @override
  void initState() {
    super.initState();

    // Initialize the rendering controller based on the concurrency mode.
    if (TeXRenderingServer.multiTeXView) {
      teXRenderingController = TeXRenderingController();
      teXRenderingController.initController();
      // Wait for the specific view to be ready
      teXRenderingController.onPageFinishedCallback =
          (_) => _onControllerReady();
    } else {
      // Use the shared singleton controller for better performance on simple views
      teXRenderingController = TeXRenderingServer.teXRenderingController;
      _onControllerReady();
    }

    // Bind the JS tap event to the Flutter callback
    teXRenderingController.onTapCallback =
        (tapCallbackMessage) => widget.child.onTapCallback(tapCallbackMessage);

    // Bind the JS render-complete event to update our widget height
    teXRenderingController.onTeXViewRenderedCallback = (h) {
      double height = double.parse(h.toString()) + widget.heightOffset;
      if (mounted) {
        heightStreamController.add(height);
        widget.onRenderFinished?.call(height);
      }
    };
  }

  @override
  void didUpdateWidget(TeXView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the widget configuration (child/style) changes, re-render.
    _renderTeXView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
          // If we have a valid height, show the WebView.
          // Otherwise, show the loading placeholder.
          if (snap.hasData && !snap.hasError) {
            return SizedBox(
              height: snap.data ?? initialHeight,
              child: WebViewWidget(
                controller: teXRenderingController.webViewControllerPlus,
              ),
            );
          }
          return widget.loadingWidgetBuilder?.call(context) ??
              const SizedBox.shrink();
        });
  }

  /// Marks the controller as ready and triggers the initial render.
  void _onControllerReady() {
    if (mounted) {
      setState(() {
        _isReady = true;
      });
      _renderTeXView();
    }
  }

  /// Executes the rendering logic asynchronously.
  ///
  /// **Optimization Note**: usage of [Future.microtask] is critical here.
  /// It prevents the rendering logic (which may trigger state updates)
  /// from executing during the build phase of the widget tree, which would cause an error.
  Future<void> _renderTeXView() async {
    if (!_isReady) return;

    await Future.microtask(() async {
      // Guard: Make sure the widget is still in the tree before processing.
      if (!mounted) return;

      // Calculate data in background isolate (via helper)
      String currentRawData = await getRawDataAsync(widget);

      // Guard again after the async gap
      if (!mounted) return;

      // Deduplication: Only send to JS if the content actually changed.
      if (currentRawData != _oldRawData) {
        _oldRawData = currentRawData;
        // Invoke the JS function 'initTeXView' via the platform channel
        await teXRenderingController.webViewControllerPlus.runJavaScript(
            '$initTeXViewChannelLabel(window, $currentRawData, false, "");');
      }
    });
  }

  @override
  void dispose() {
    // Release resources. Note: We don't dispose the controller if it's the shared singleton.
    heightStreamController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
