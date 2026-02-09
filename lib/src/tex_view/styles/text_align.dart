/// An enumeration of text alignment options for [TeXView].
///
/// This corresponds to the CSS `text-align` property.
enum TeXViewTextAlign {
  /// Centers the text.
  center,

  /// Aligns the text to the left.
  left,

  /// Aligns the text to the right.
  right,

  /// Stretches the lines so that each line has equal width (like in newspapers and magazines).
  justify
}

/// A helper class for [TeXViewTextAlign].
class TeXViewTextAlignHelper {
  /// Returns the CSS string value for a given [TeXViewTextAlign].
  static String getValue(TeXViewTextAlign? teXViewTextAlign) {
    switch (teXViewTextAlign) {
      case TeXViewTextAlign.center:
        return "center";

      case TeXViewTextAlign.left:
        return "left";

      case TeXViewTextAlign.right:
        return "right";

      case TeXViewTextAlign.justify:
        return "justify";

      default:
        return "left";
    }
  }
}
