import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/globals.dart';
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
  /// Stream controller to broadcast the height of the rendered content.
  final StreamController<double> heightStreamController = StreamController();

  /// Controller for managing the TeX rendering server and WebView interactions.
  late final TeXRenderingController teXRenderingController;

  /// Flag indicating if the WebView controller is ready to execute JavaScript.
  bool _isReady = false;

  /// Stores the previously rendered raw data to avoid unnecessary re-renders.
  String _oldRawData = "";

  @override
  void initState() {
    super.initState();
    // ... (Your existing controller init logic is correct, keep it) ...
    if (TeXRenderingServer.multiTeXView) {
      teXRenderingController = TeXRenderingController();
      teXRenderingController.initController();
      teXRenderingController.onPageFinishedCallback =
          (_) => _onControllerReady();
    } else {
      teXRenderingController = TeXRenderingServer.teXRenderingController;
      _onControllerReady();
    }

    // Forward tap events from the rendering controller to the widget's callback.
    teXRenderingController.onTapCallback =
        (tapCallbackMessage) => widget.child.onTapCallback(tapCallbackMessage);

    // callback triggers when the TeX view rendering is complete.
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
    // Trigger a render check when the parent passes new configuration.
    _renderTeXView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
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

  /// Callback generated when the controller is ready.
  ///
  /// Marks the state as ready and attempts the initial render.
  void _onControllerReady() {
    if (mounted) {
      setState(() {
        _isReady = true;
      });
      _renderTeXView(); // Render for the first time
    }
  }

  /// Asynchronously renders the TeX Content.
  ///
  /// This method fetches the raw data from the widget and executes the JavaScript
  /// `initTeXView` function to render the content in the WebView.
  Future<void> _renderTeXView() async {
    if (!_isReady) return;

    String currentRawData = await getRawDataAsync(widget);

    if (currentRawData != _oldRawData) {
      // initTeXView(context, data, isWeb, iframeId)
      await teXRenderingController.webViewControllerPlus.runJavaScript(
          '$initTeXViewChannelLabel(window, $currentRawData, false, "");');

      _oldRawData = currentRawData;
    }
  }

  @override
  void dispose() {
    // Close the stream controller to prevent memory leaks.
    heightStreamController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
