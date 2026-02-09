import 'dart:ui';

import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_view/utils/style_utils.dart';

/// Defines the border for a [TeXView] widget.
///
/// This class allows you to specify borders for each side individually
/// or a single border for all sides. It is used within [TeXViewStyle].
class TeXViewBorder {
  /// The border decoration for the top side.
  final TeXViewBorderDecoration? top;

  /// The border decoration for the bottom side.
  final TeXViewBorderDecoration? bottom;

  /// The border decoration for the right side.
  final TeXViewBorderDecoration? right;

  /// The border decoration for the left side.
  final TeXViewBorderDecoration? left;

  /// A uniform border decoration for all sides.
  ///
  /// If this is provided, the individual side properties ([top], [bottom], [right], [left]) are ignored.
  final TeXViewBorderDecoration? all;

  /// Creates a border with a uniform decoration for all four sides.
  const TeXViewBorder.all(this.all)
      : top = null,
        bottom = null,
        right = null,
        left = null;

  /// Creates a border with potentially different decorations for each side.
  const TeXViewBorder.only({this.top, this.bottom, this.right, this.left})
      : all = null;

  /// Converts this border definition into a CSS string.
  String getBorder() {
    if (all != null) {
      return "border:${all!.getBorderDecoration()};";
    }
    return "border-top:${top?.getBorderDecoration() ?? 'none'};"
        "border-bottom:${bottom?.getBorderDecoration() ?? 'none'};"
        "border-right:${right?.getBorderDecoration() ?? 'none'};"
        "border-left:${left?.getBorderDecoration() ?? 'none'};";
  }
}

/// Defines the visual decoration of a border, including its width, style, and color.
class TeXViewBorderDecoration {
  /// The width of the border in pixels.
  final int? borderWidth;

  /// The style of the border (e.g., solid, dotted).
  final TeXViewBorderStyle? borderStyle;

  /// The color of the border.
  final Color? borderColor;

  /// Creates a border decoration.
  const TeXViewBorderDecoration(
      {this.borderWidth, this.borderStyle, this.borderColor});

  /// Converts this border decoration into a CSS `border` property value.
  String getBorderDecoration() {
    return "${borderWidth ?? 1}px ${_getTeXViewBorderStyleValue(borderStyle)} ${getColor(borderColor)}";
  }

  /// Returns the CSS string value for a given [TeXViewBorderStyle].
  String _getTeXViewBorderStyleValue(TeXViewBorderStyle? teXViewBorderStyle) {
    switch (teXViewBorderStyle) {
      case TeXViewBorderStyle.none:
        return "none";
      case TeXViewBorderStyle.hidden:
        return "hidden";
      case TeXViewBorderStyle.dotted:
        return "dotted";
      case TeXViewBorderStyle.dashed:
        return "dashed";
      case TeXViewBorderStyle.solid:
        return "solid";
      case TeXViewBorderStyle.double:
        return "double";
      case TeXViewBorderStyle.groove:
        return "groove";
      case TeXViewBorderStyle.ridge:
        return "ridge";
      case TeXViewBorderStyle.inset:
        return "inset";
      case TeXViewBorderStyle.outset:
        return "outset";
      case TeXViewBorderStyle.initial:
        return "initial";
      default:
        return "solid";
    }
  }
}

/// Defines the radius for the corners of a [TeXView] widget's border.
class TeXViewBorderRadius {
  /// The unit for the radius values (e.g., pixels, percentage).
  final TeXViewSizeUnit? sizeUnit;

  /// The radius for the top-left corner.
  final int? topLeft;

  /// The radius for the top-right corner.
  final int? topRight;

  /// The radius for the bottom-right corner.
  final int? bottomRight;

  /// The radius for the bottom-left corner.
  final int? bottomLeft;

  /// A uniform radius for all four corners.
  ///
  /// If this is provided, the individual corner properties are ignored.
  final int? all;

  /// Creates a border radius with a uniform value for all four corners.
  const TeXViewBorderRadius.all(this.all, {this.sizeUnit})
      : topLeft = null,
        topRight = null,
        bottomRight = null,
        bottomLeft = null;

  /// Creates a border radius with potentially different values for each corner.
  const TeXViewBorderRadius.only(
      {this.sizeUnit,
      this.topLeft,
      this.topRight,
      this.bottomRight,
      this.bottomLeft})
      : all = null;

  /// Converts this border radius definition into a CSS `border-radius` string.
  String getRadius() {
    final unit = UnitHelper.getValue(sizeUnit);
    if (all != null) {
      return "border-radius:$all$unit;";
    }
    return "border-radius:${_getRadiusValue(topLeft, unit)} ${_getRadiusValue(topRight, unit)} ${_getRadiusValue(bottomRight, unit)} ${_getRadiusValue(bottomLeft, unit)};";
  }

  /// Formats a single radius value with its unit.
  String _getRadiusValue(int? value, String unit) {
    return (value ?? 0).toString() + unit;
  }
}

/// An enumeration of possible border styles, corresponding to CSS `border-style` values.
enum TeXViewBorderStyle {
  /// No border.
  none,

  /// Same as 'none', except in border conflict resolution for table elements.
  hidden,

  /// A series of dots.
  dotted,

  /// A series of short dashes.
  dashed,

  /// A single, straight, solid line.
  solid,

  /// Two straight lines that add up to the pixel size defined by `border-width`.
  double,

  /// A 3D grooved border. The effect depends on the `border-color` value.
  groove,

  /// A 3D ridged border. The effect depends on the `border-color` value.
  ridge,

  /// A 3D inset border. The effect depends on the `border-color` value.
  inset,

  /// A 3D outset border. The effect depends on the `border-color` value.
  outset,

  /// Sets this property to its default value.
  initial
}
