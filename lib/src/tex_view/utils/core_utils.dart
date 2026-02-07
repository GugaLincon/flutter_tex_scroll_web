import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_tex/src/tex_view/tex_view.dart';
import 'package:flutter_tex/src/tex_view/utils/widget_meta.dart';

/// A small initial height for the TeXView widget before its actual content is rendered.
///
/// This minimal non-zero height allows the framework to lay out the widget initially
/// without a height constraint error, while preventing visible layout jumps until the
/// actual content height is calculated by the JS bridge.
const double initialHeight = 1;

/// Asynchronously serializes the complete [TeXView] widget tree into a JSON string.
///
/// This specific optimization employs `compute` to offload the potentially expensive
/// [jsonEncode] operation to a background isolate. This ensures that the main UI thread
/// remains responsive (free of jank), even when rendering large or complex TeX documents.
///
/// Returns a JSON string containing:
/// - `meta`: The root element metadata (tag, class, id).
/// - `data`: The serialized children widgets.
/// - `style`: The compiled CSS string.
Future<String> getRawDataAsync(TeXView teXView) async {
  // 1. Structure Preparation:
  // We prepare the Map structure on the main thread. This is lightweight.
  // We use `teXViewDefaultStyle` as a fallback to avoid creating new string objects repeatedly.
  final Map<String, dynamic> dataMap = {
    'meta': const TeXViewWidgetMeta(
      tag: 'div',
      classList: 'tex-view',
      node: Node.root,
    ).toJson(),
    'data': teXView.child.toJson(),
    'style': teXView.style?.initStyle() ?? teXViewDefaultStyle,
  };

  // 2. Background Serialization:
  // The encoding process is delegated to a separate isolate. This is crucial for
  // performance when scrolling through lists of TeXViews.
  return compute(jsonEncode, dataMap);
}

/// The default CSS styling for the TeXView container.
///
/// Enforces `overflow: hidden` to prevent scrollbars within the view itself,
/// and sets width to 100% to fill the parent container.
const String teXViewDefaultStyle = "overflow: hidden; width: 100%;";
