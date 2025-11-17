/// An enumeration of how to handle content that overflows its container's box.
///
/// This corresponds to the CSS `overflow` property.
enum TeXViewOverflow {
  /// The overflow is not clipped. It renders outside the element's box. This is default.
  visible,

  /// The overflow is clipped, and the rest of the content will be invisible.
  hidden,

  /// The overflow is clipped, but a scroll-bar is added to see the rest of the content.
  scroll,

  /// If overflow is clipped, a scroll-bar should be added to see the rest of the content.
  auto,
}

/// A helper class for [TeXViewOverflow].
class TeXViewOverflowHelper {
  /// Returns the CSS string value for a given [TeXViewOverflow].
  static String getValue(TeXViewOverflow? teXViewOverflow) {
    switch (teXViewOverflow) {
      case TeXViewOverflow.visible:
        return "visible";
      case TeXViewOverflow.hidden:
        return "hidden";
      case TeXViewOverflow.scroll:
        return "scroll";
      case TeXViewOverflow.auto:
        return "auto";
      default:
        return "visible";
    }
  }
}
