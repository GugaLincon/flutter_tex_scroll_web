import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

/// An optimized rendering server for TeXView using a LIFO queue and request deduplication.
class TeXRenderingServer {
  static final LocalhostServer _server = LocalhostServer();
  static final TeXRenderingController teXRenderingController =
      TeXRenderingController();

  static int? get port => _server.port;
  static bool multiTeXView = false;

  /// 1. Memory Management: Using LinkedHashMap to implement an LRU (Least Recently Used) cache.
  /// This prevents the app from crashing due to memory leaks if thousands of equations are rendered.
  static const int _maxCacheSize = 500;
  static final LinkedHashMap<String, String> _svgCache =
      LinkedHashMap<String, String>();

  /// 2. Deduplication: Tracks requests currently being processed in the WebView.
  /// If 10 widgets ask for the same formula, the WebView renders it once.
  static final Map<String, Completer<String>> _inFlightRequests = {};

  /// 3. LIFO Queue: We prioritize the latest request (top of the stack) because
  /// in a scrolling list, the most recently requested items are what's visible.
  static final List<_MathRequest> _queue = [];

  static int _activeRequests = 0;

  /// 4. Concurrency: Reduced to 3. Since WebView JS execution is single-threaded,
  /// hammering the bridge with 5+ concurrent calls causes "bridge congestion" and lag.
  static const int _maxConcurrentRequests = 3;

  static Future<void> start({int port = 0}) async {
    await _server.start(port: port);
    await teXRenderingController.initController();
  }

  /// Synchronous cache check for the Widget to use in initState.
  static String? getCachedSVG(String math, MathInputType type) {
    return _svgCache['${type.type}_$math'];
  }

  static Future<String> math2SVG({
    required String math,
    required MathInputType mathInputType,
  }) {
    final cacheKey = '${mathInputType.type}_$math';

    // Check Cache
    if (_svgCache.containsKey(cacheKey)) {
      return Future.value(_svgCache[cacheKey]!);
    }

    // Check if already rendering (Deduplication)
    if (_inFlightRequests.containsKey(cacheKey)) {
      return _inFlightRequests[cacheKey]!.future;
    }

    final completer = Completer<String>();
    _inFlightRequests[cacheKey] = completer;

    // LIFO: Insert at index 0
    _queue.insert(0, _MathRequest(math, mathInputType, completer, cacheKey));

    _processQueue();
    return completer.future;
  }

  static void _processQueue() async { 
    if (_activeRequests >= _maxConcurrentRequests || _queue.isEmpty) return;

    _activeRequests++;
    final request = _queue.removeAt(0);

    try {
      final data = await teXRenderingController.webViewControllerPlus
          .runJavaScriptReturningResult(
              "$mathJaxFlutterTeXLiteDOMMath2SVGChannelLabel(${jsonEncode(request.math)}, '${request.inputType.type}');");

      String svg = Platform.isAndroid
          ? jsonDecode(data.toString()).toString()
          : data.toString();

      if (svg.isNotEmpty && svg != "null") {
        _updateCache(request.cacheKey, svg);
        request.completer.complete(svg);
      } else {
        request.completer.completeError('Render failed');
      }
    } catch (e) {
      request.completer.completeError(e);
    } finally {
      _inFlightRequests.remove(request.cacheKey);
      _activeRequests--;
      _processQueue(); // Loop to next item
    }
  }

  static void _updateCache(String key, String value) {
    if (_svgCache.length >= _maxCacheSize) {
      _svgCache.remove(_svgCache.keys.first); // Evict oldest
    }
    _svgCache[key] = value;
  }

  static Future<void> stop() async {
    await _server.close();
  }
}

class _MathRequest {
  final String math;
  final MathInputType inputType;
  final Completer<String> completer;
  final String cacheKey;

  _MathRequest(this.math, this.inputType, this.completer, this.cacheKey);
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
        onTapCallbackChannelLabel,
        onMessageReceived: (onTapCallbackMessage) =>
            onTapCallback?.call(onTapCallbackMessage.message),
      )
      ..addJavaScriptChannel(
        onTeXViewRenderedCallbackChannelLabel,
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
