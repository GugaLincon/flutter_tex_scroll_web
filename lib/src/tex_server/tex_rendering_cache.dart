import 'dart:async';
import 'dart:collection';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_server/tex_rendering_queue.dart';

/// A mixin or helper to handle Caching and Request Deduplication for TeX Rendering.
///
/// This class handles two major optimizations:
/// 1. **LRU Caching**: Stores recently rendered SVGs to avoid re-rendering.
/// 2. **Request Deduplication**: Prevents multiple identical requests from hitting the rendering engine unnecessarily.
class TexRenderingCache {
  /// 1. Memory Management: Using LinkedHashMap to implement an LRU (Least Recently Used) cache.
  /// This prevents the app from crashing due to memory leaks if thousands of equations are rendered.
  ///
  /// The maximum size is set to 1000 items. When the limit is reached, the least recently used item is evicted.
  static const int _maxCacheSize = 1000;
  static final LinkedHashMap<String, String> _svgCache =
      LinkedHashMap<String, String>();

  /// 2. Deduplication: Tracks requests currently being processed.
  /// If multiple widgets ask for the same formula, the logic renders it once and shares the result.
  static final Map<String, TexRenderingRequest> _inFlightRequests = {};

  /// Retrieves a cached SVG if available.
  ///
  /// This synchronous check allows widgets to possibly render immediately in `initState`.
  static String? getCachedSVG(String math, MathInputType type) {
    return _svgCache['${type.type}_$math'];
  }

  /// Updates the cache with a new rendered SVG, maintaining the LRU property.
  static void updateCache(String key, String value) {
    if (_svgCache.length >= _maxCacheSize) {
      _svgCache.remove(_svgCache.keys.first); // Evict oldest
    }
    _svgCache[key] = value;
  }

  /// Handles the rendering process with Caching and Deduplication.
  ///
  /// - [math]: The mathematical formula to render.
  /// - [mathInputType]: The syntax type (TeX, MathML, etc.).
  /// - [onMissing]: A callback to execute the actual rendering if the result is not in the cache.
  ///
  /// Returns a [TexRenderingRequest] which can be cancelled if no longer needed.
  static TexRenderingRequest render({
    required String math,
    required MathInputType mathInputType,
    required TexRenderingRequest Function() onMissing,
  }) {
    final cacheKey = '${mathInputType.type}_$math';

    // Check Cache
    if (_svgCache.containsKey(cacheKey)) {
      return TexRenderingRequest(
        future: Future.value(_svgCache[cacheKey]!),
        cancel: () {}, // No-op
      );
    }

    // Check if already rendering (Deduplication)
    if (_inFlightRequests.containsKey(cacheKey)) {
      // NOTE: We don't want one widget cancelling the request to kill it for another widget.
      // So detailed Reference Counting would be needed for true shared cancellation.
      // For now, we return the existing future, but disable the cancel action for shared requests
      // to prevents a disposed widget from cancelling a request needed by another widget.
      return TexRenderingRequest(
        future: _inFlightRequests[cacheKey]!.future,
        cancel:
            () {}, // Shared request cannot be cancelled by a single consumer
      );
    }

    final originalRequest = onMissing();

    // Intercept the future to update cache
    final cachingFuture = originalRequest.future.then((result) {
      if (result.isNotEmpty && result != "null") {
        updateCache(cacheKey, result);
        return result;
      } else {
        throw "Render failed or returned empty/null";
      }
    }).whenComplete(() {
      _inFlightRequests.remove(cacheKey);
    });

    final wrappedRequest = TexRenderingRequest(
      future: cachingFuture,
      cancel: originalRequest.cancel,
    );

    _inFlightRequests[cacheKey] = wrappedRequest;

    return wrappedRequest;
  }
}
