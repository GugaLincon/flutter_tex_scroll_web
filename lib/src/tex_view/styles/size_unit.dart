/// An enumeration of CSS size units used for styling [TeXView] components.
enum TeXViewSizeUnit {
  /// Pixels.
  pixels,

  /// Percentage, relative to the parent element's size.
  percent,

  /// Relative to the font-size of the element (e.g., 2em means 2 times the current font size).
  em,

  /// Points (1pt = 1/72 of 1 inch).
  pt,
}

/// A helper class for [TeXViewSizeUnit].
class UnitHelper {
  /// Returns the CSS string representation for a given [TeXViewSizeUnit].
  static String getValue(TeXViewSizeUnit? unit) {
    switch (unit) {
      case TeXViewSizeUnit.pixels:
        return "px";
      case TeXViewSizeUnit.percent:
        return "%";
      case TeXViewSizeUnit.em:
        return "em";
      case TeXViewSizeUnit.pt:
        return "pt";
      default:
        return "px"; // Default to pixels if no unit is specified.
    }
  }
}
