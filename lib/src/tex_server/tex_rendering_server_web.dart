import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_view/tex_view_web.dart';
import 'package:web/web.dart';

/// A rendering server for TeXView on the web.
///
/// This implementation communicates with the JavaScript rendering engine (MathJax)
/// using `dart:js_interop` to render TeX content directly in the browser.
class TeXRenderingServer {
  /// A flag to indicate if multiple TeXViews are being used.
  static bool multiTeXView = false;

  /// Starts the TeX rendering server for the web.
  ///
  /// This method initializes the [TeXRenderingControllerWeb], which sets up
  /// the necessary JavaScript interoperability for callbacks.
  static Future<void> start({int port = 0}) async {
    TeXRenderingControllerWeb.initialize();
  }

  /// Converts a TeX, MathML, or AsciiMath string into an SVG image on the web.
  ///
  /// The [math] string is processed according to the specified [mathInputType].
  /// This method directly calls the external JavaScript function `mathJaxLiteDOMTeX2SVG`.
  static Future<String> teX2SVG(
      {required String math, required MathInputType mathInputType}) {
    try {
      return Future<String>.value(
          teX2SVGflutterTeXLiteDOM(math, mathInputType.type));
    } catch (e) {
      if (kDebugMode) {
        print('Error in math2SVG: $e');
      }
      return Future.error('Error rendering TeX: $e');
    }
  }

  /// Stops the TeX rendering server for the web.
  ///
  /// This disposes of the [TeXRenderingControllerWeb], cleaning up the
  /// JavaScript callbacks.
  static Future<void> stop() async {
    TeXRenderingControllerWeb.dispose();
  }
}

/// A JavaScript interop binding for the `OnTeXViewRenderedCallback` function.
///
/// This allows Dart to set a JavaScript function that will be called when
/// the TeX view has finished rendering.
@JS('OnTeXViewRenderedCallback')
external set onTeXViewRenderedCallback(JSFunction callback);

/// A JavaScript interop binding for the `OnTapCallback` function.
///
/// This allows Dart to set a JavaScript function that will be called when
/// a tap event occurs within the rendered TeX content.
@JS('OnTapCallback')
external set onTapCallback(JSFunction callback);

/// A JavaScript interop binding for the `initTeXViewWeb` function.
///
/// This function is called from the Dart side to initialize a specific
/// TeX view instance within its iframe.
@JS('initTeXViewWeb')
external void initTeXViewWeb(
    Window iframeContentWindow, String iframId, String flutterTeXData);

/// A JavaScript interop binding for the `mathJaxLiteDOM.teX2SVG` function.
///
/// This function performs the actual conversion of a math string to an SVG.
@JS('MathJax.flutterTeXLiteDOM.teX2SVG')
external String teX2SVGflutterTeXLiteDOM(String math, String inputType);

/// Manages the global callbacks and communication between JavaScript and Dart for web.
///
/// This controller maintains a registry of active [TeXViewState] instances and
/// dispatches JavaScript events to the appropriate Dart instance.
class TeXRenderingControllerWeb {
  static bool _isInitialized = false;

  /// A map to hold references to the state of each TeXView instance, keyed by viewId.
  static final Map<String, TeXViewState> _instances = {};

  /// Registers an instance of [TeXViewState] to be managed by the controller.
  static void registerInstance(String viewId, TeXViewState instance) {
    _instances[viewId] = instance;
  }

  /// Unregisters a [TeXViewState] instance when it's disposed to prevent memory leaks.
  static void unregisterInstance(String viewId) {
    _instances.remove(viewId);
  }

  /// Initializes the controller by setting up the global JavaScript callbacks.
  ///
  /// This is idempotent and will only run once.
  static void initialize() {
    if (_isInitialized) return;

    onTeXViewRenderedCallback = _onTeXViewRendered.toJS;
    onTapCallback = _onTap.toJS;
    _isInitialized = true;
  }

  /// Disposes of the controller, cleaning up JavaScript callbacks and resetting state.
  static void dispose() {
    if (!_isInitialized) return;
    onTeXViewRenderedCallback = (() {}).toJS;
    onTapCallback = (() {}).toJS;
    _isInitialized = false;
  }

  /// The Dart callback that is triggered from the JavaScript `OnTeXViewRenderedCallback`.
  ///
  /// It finds the corresponding [TeXViewState] instance and calls its `onTeXViewRendered` method.
  static void _onTeXViewRendered(JSNumber h, JSString iframeId) {
    final instance = _instances[iframeId.toDart];
    if (instance != null && instance.mounted) {
      instance.onTeXViewRendered(h);
    }
  }

  /// The Dart callback that is triggered from the JavaScript `OnTapCallback`.
  ///
  /// It finds the corresponding [TeXViewState] instance and calls its `onTap` method.
  static void _onTap(JSString tapId, JSString iframeId) {
    final instance = _instances[iframeId.toDart];
    if (instance != null && instance.mounted) {
      instance.onTap(tapId);
    }
  }
}
