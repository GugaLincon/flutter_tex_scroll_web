import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_server/tex_rendering_server_mobile.dart';
import 'package:flutter_tex/src/tex_view/utils/core_utils.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart'
    show WebViewWidget;

/// The state for the [TeXView] widget on mobile platforms.
///
/// This class manages the underlying `WebView` and communicates with the
/// JavaScript rendering engine. It handles the widget's lifecycle,
/// rendering updates, and user interactions.
class TeXViewState extends State<TeXView>
    with AutomaticKeepAliveClientMixin<TeXView> {
  /// A stream controller to manage the height of the `WebView`.
  ///
  /// The `WebView`'s height is determined asynchronously after the content is rendered,
  /// and this stream is used to update the widget's size accordingly.
  final StreamController<double> heightStreamController = StreamController();

  /// The controller for the `WebView` that handles TeX rendering.
  late final TeXRenderingController teXRenderingController;

  /// A flag to indicate if the `WebView` controller is ready to receive commands.
  bool _isReady = false;

  /// Caches the last rendered data to avoid unnecessary re-renders.
  String _oldRawData = "";

  @override
  void initState() {
    super.initState();

    // Initialize the rendering controller.
    // If `multiTeXView` is enabled, a new controller is created for this instance.
    // Otherwise, the shared global controller is used.
    if (TeXRenderingServer.multiTeXView) {
      teXRenderingController = TeXRenderingController();
      teXRenderingController.initController();
      teXRenderingController.onPageFinishedCallback =
          (pageFinishedCallbackMessage) {
        _onControllerReady();
      };
    } else {
      teXRenderingController = TeXRenderingServer.teXRenderingController;
      _onControllerReady();
    }

    // Set up the callback for tap events.
    teXRenderingController.onTapCallback =
        (tapCallbackMessage) => widget.child.onTapCallback(tapCallbackMessage);

    // Set up the callback for when rendering is complete.
    teXRenderingController.onTeXViewRenderedCallback = (h) async {
      // The height is received as a string, so it needs to be parsed.
      // An offset is added for layout adjustments.
      double height = double.parse(h.toString()) + widget.heightOffset;
      if (mounted) {
        heightStreamController.add(height);
        widget.onRenderFinished?.call(height);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessary for AutomaticKeepAliveClientMixin.
    _renderTeXView();

    // The widget's size is determined by the height received from the stream.
    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
          if (snap.hasData && !snap.hasError) {
            double height = snap.data ?? initialHeight;
            return SizedBox(
              height: height,
              child: WebViewWidget(
                controller: teXRenderingController.webViewControllerPlus,
              ),
            );
          } else {
            // While rendering, show a loading widget or an empty box.
            return widget.loadingWidgetBuilder?.call(context) ??
                const SizedBox.shrink();
          }
        });
  }

  @override
  void dispose() {
    if (mounted) {
      heightStreamController.close();
    }
    super.dispose();
  }

  /// Called when the `WebView` controller is fully initialized and the page is loaded.
  void _onControllerReady() {
    if (mounted) {
      setState(() {
        _isReady = true;
      });
      _renderTeXView();
    }
  }

  /// Triggers the rendering of the TeX content in the `WebView`.
  ///
  /// This method generates the raw data from the widget's properties,
  /// and if it has changed since the last render, it sends the new data
  /// to the `WebView` via a JavaScript call.
  void _renderTeXView() async {
    if (!_isReady) {
      return; // Don't render if the controller isn't ready.
    }

    String currentRawData = getRawData(widget);

    // Only re-render if the content has actually changed.
    if (currentRawData != _oldRawData) {
      await teXRenderingController.webViewControllerPlus
          .runJavaScript('initTeXViewMobile($currentRawData);');
      _oldRawData = currentRawData;
    }
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
