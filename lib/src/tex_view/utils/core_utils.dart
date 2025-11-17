import 'dart:convert';

import 'package:flutter_tex/src/tex_view/utils/widget_meta.dart';
import 'package:flutter_tex/src/tex_view/utils/style_utils.dart';
import 'package:flutter_tex/src/tex_view/tex_view.dart';

/// A small initial height for the TeXView widget before its actual content is rendered
/// and its height is calculated. This helps in avoiding layout jumps.
const double initialHeight = 1;

/// Serializes the complete [TeXView] widget tree and its styling into a JSON string.
///
/// This JSON string is then passed to the web-based rendering engine (either in a
/// `WebView` or an `iframe`) to construct the HTML content.
///
/// The JSON object includes:
/// - `meta`: Basic metadata for the root `div` element.
/// - `data`: The hierarchical structure of the [TeXViewWidget] children.
/// - `style`: The CSS styles to be applied to the root container.
String getRawData(TeXView teXView) {
  return jsonEncode({
    'meta': const TeXViewWidgetMeta(
            tag: 'div', classList: 'tex-view', node: Node.root)
        .toJson(),
    'data': teXView.child.toJson(),
    'style': teXView.style?.initStyle() ?? teXViewDefaultStyle
  });
}
