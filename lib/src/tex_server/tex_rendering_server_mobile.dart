import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

/// A rendering server for TeXView on mobile platforms (Android, iOS, and macOS).
///
/// This server utilizes a [LocalhostServer] and a [WebViewControllerPlus] to render TeX content.
/// It is essential to call the [start] method before any rendering attempts.
class TeXRenderingServer {
  /// The underlying localhost server that serves the TeX rendering engine.
  static final LocalhostServer _server = LocalhostServer();

  /// The controller that manages the WebView and communication with the rendering engine.
  static final TeXRenderingController teXRenderingController =
      TeXRenderingController();

  /// A flag to indicate if multiple TeXViews are being used.
  static bool multiTeXView = false;

  /// The port on which the localhost server is running.
  static int? get port => _server.port;

  /// Starts the TeX rendering server.
  ///
  /// This method initializes the [LocalhostServer] on the specified [port] (or a random one if 0)
  /// and sets up the [TeXRenderingController].
  static Future<void> start({int port = 0}) async {
    await _server.start(port: port);
    await teXRenderingController.initController();
  }

  /// Converts a TeX, MathML, or AsciiMath string into an SVG image.
  ///
  /// The [math] string is processed according to the specified [mathInputType].
  /// Returns a future that completes with the SVG string.
  /// Throws an error if the input is empty or if rendering fails.
  static Future<String> math2SVG(
      {required String math, required MathInputType mathInputType}) {
    try {
      return teXRenderingController.webViewControllerPlus
          .runJavaScriptReturningResult(
              "MathJax.flutterTeXLiteDOM.math2SVG(${jsonEncode(math)}, '${mathInputType.type}');")
          .then((data) {
        if (math.trim().isEmpty) {
          return Future.error('TeX input cannot be empty.');
        }

        if (data.toString().isEmpty || data == "null") {
          return Future.error(
              'Rendering failed. Ensure you have a valid TeX expression.');
        }

        if (Platform.isAndroid) {
          // On Android, the result is a JSON-encoded string, so it needs to be decoded.
          return jsonDecode(data.toString()).toString();
        } else {
          return data.toString();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in math2SVG: $e');
      }
      return Future.error('Error rendering TeX: $e');
    }
  }

  /// Stops the TeX rendering server.
  ///
  /// This closes the [LocalhostServer].
  static Future<void> stop() async {
    await _server.close();
  }
}

/// A controller for the WebView that handles TeX rendering.
///
/// This class manages the lifecycle of the [WebViewControllerPlus] and facilitates
/// communication between the Flutter app and the JavaScript rendering engine
/// running in the WebView. It handles navigation, JavaScript channels, and callbacks.
class TeXRenderingController {
  /// The WebView controller used to render TeX.
  final WebViewControllerPlus webViewControllerPlus = WebViewControllerPlus();

  /// The base URL for the rendering engine's HTML file, served by the localhost server.
  final String baseUrl =
      "http://localhost:${TeXRenderingServer.port!}/packages/flutter_tex/core/flutter_tex.html";

  /// Callback triggered when the WebView finishes loading a page.
  RenderingControllerCallback? onPageFinishedCallback;

  /// Callback triggered when a tap event occurs within the rendered TeX content.
  RenderingControllerCallback? onTapCallback;

  /// Callback triggered when the TeX view has finished rendering.
  RenderingControllerCallback? onTeXViewRenderedCallback;

  /// Initializes the [WebViewControllerPlus].
  ///
  /// This sets up JavaScript channels for communication, a navigation delegate
  /// to handle URL requests, and loads the initial rendering page.
  /// It returns a future that completes with the initialized controller.
  Future<WebViewControllerPlus> initController() {
    var controllerCompleter = Completer<WebViewControllerPlus>();

    webViewControllerPlus
      ..addJavaScriptChannel(
        'OnTapCallback',
        onMessageReceived: (onTapCallbackMessage) =>
            onTapCallback?.call(onTapCallbackMessage.message),
      )
      ..addJavaScriptChannel(
        'OnTeXViewRenderedCallback',
        onMessageReceived: (teXViewRenderedCallbackMessage) =>
            onTeXViewRenderedCallback
                ?.call(teXViewRenderedCallbackMessage.message),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _debugPrint("Page finished loading: $url");
            onPageFinishedCallback?.call(url);
            controllerCompleter.complete(webViewControllerPlus);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(
              baseUrl,
            )) {
              return NavigationDecision.navigate;
            } else {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..setOnConsoleMessage(
        (message) {
          _debugPrint('WebView Console: ${message.message}');
        },
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
        baseUrl,
      ));

    if (!Platform.isMacOS) {
      // Setting a transparent background is not supported on macOS.
      webViewControllerPlus.setBackgroundColor(Colors.transparent);
    }

    return controllerCompleter.future;
  }

  /// Launches the given [url] in an external browser.
  static void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Prints a [message] to the console only in debug mode.
  static void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}

/// A callback function type for handling messages from the rendering controller.
///
/// The [message] parameter contains the data sent from the JavaScript side.
typedef RenderingControllerCallback = void Function(dynamic message);
