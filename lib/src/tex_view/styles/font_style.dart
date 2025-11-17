import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_view/utils/style_utils.dart';

/// Defines the font styling for text within a [TeXView].
///
/// This class allows you to specify font properties such as family, size, and weight.
class TeXViewFontStyle {
  /// The name of the font family.
  ///
  /// This should correspond to a font family registered using [TeXViewFont].
  final String? fontFamily;

  /// The size of the font.
  final int? fontSize;

  /// The weight of the font (e.g., bold, normal).
  final TeXViewFontWeight? fontWeight;

  /// The unit for the font size (e.g., pixels, em).
  final TeXViewSizeUnit? sizeUnit;

  /// Creates a font style definition.
  const TeXViewFontStyle(
      {this.fontSize, this.fontFamily, this.sizeUnit, this.fontWeight});

  /// Converts this font style into a CSS string.
  String initFontStyle() {
    return "${fontSize != null ? "font-size: ${getSizeWithUnit(fontSize, sizeUnit)};" : ""}"
        "${fontFamily != null ? "font-family: ${fontFamily!};" : ""}"
        "${fontWeight != null ? "font-weight: ${_getFontWeightValue(fontWeight)};" : ""}";
  }

  /// Returns the CSS string value for a given [TeXViewFontWeight].
  static String _getFontWeightValue(TeXViewFontWeight? teXViewFontWeight) {
    switch (teXViewFontWeight) {
      case TeXViewFontWeight.normal:
        return "normal";
      case TeXViewFontWeight.bold:
        return "bold";
      case TeXViewFontWeight.bolder:
        return "bolder";
      case TeXViewFontWeight.lighter:
        return "lighter";
      case TeXViewFontWeight.w100:
        return "100";
      case TeXViewFontWeight.w200:
        return "200";
      case TeXViewFontWeight.w300:
        return "300";
      case TeXViewFontWeight.w400:
        return "400";
      case TeXViewFontWeight.w500:
        return "500";
      case TeXViewFontWeight.w600:
        return "600";
      case TeXViewFontWeight.w700:
        return "700";
      case TeXViewFontWeight.w800:
        return "800";
      case TeXViewFontWeight.w900:
        return "900";
      case TeXViewFontWeight.initial:
        return "initial";
      case TeXViewFontWeight.inherit:
        return "inherit";
      default:
        return "normal";
    }
  }
}

/// An enumeration of possible font weights, corresponding to CSS `font-weight` values.
enum TeXViewFontWeight {
  /// Normal font weight. This is the default.
  normal,

  /// Bold font weight.
  bold,

  /// Bolder font weight (relative to the parent element).
  bolder,

  /// Lighter font weight (relative to the parent element).
  lighter,

  /// Thin font weight (100).
  w100,

  /// Extra-light font weight (200).
  w200,

  /// Light font weight (300).
  w300,

  /// Regular font weight (400). Same as `normal`.
  w400,

  /// Medium font weight (500).
  w500,

  /// Semi-bold font weight (600).
  w600,

  /// Bold font weight (700). Same as `bold`.
  w700,

  /// Extra-bold font weight (800).
  w800,

  /// Black font weight (900).
  w900,

  /// Sets this property to its default value.
  initial,

  /// Inherits this property from its parent element.
  inherit
}
