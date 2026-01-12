enum TeXViewOverflow { visible, hidden, scroll, auto }

class TeXViewOverflowHelper {
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
