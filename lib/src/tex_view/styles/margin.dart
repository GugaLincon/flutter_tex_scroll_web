import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_view/utils/style_utils.dart';

/// Defines the margin for a [TeXView] widget, controlling the space around it.
///
/// This class allows for specifying margins on all sides uniformly, on each side
/// individually, or using the special "0 auto" for horizontal centering.
class TeXViewMargin {
  /// The unit for the margin values (e.g., pixels, percentage).
  final TeXViewSizeUnit? sizeUnit;

  /// The margin on the top side.
  final int? top;

  /// The margin on the bottom side.
  final int? bottom;

  /// The margin on the right side.
  final int? right;

  /// The margin on the left side.
  final int? left;

  /// A uniform margin for all four sides.
  ///
  /// If this is provided, the individual side properties ([top], [bottom], [right], [left]) are ignored.
  final int? all;

  /// A special value for `margin: 0 auto;` in CSS.
  ///
  /// This is often used to horizontally center a block-level element with a specified width.
  final String? zeroAuto;

  /// Creates a margin with a uniform value for all four sides.
  const TeXViewMargin.all(this.all, {this.sizeUnit})
      : zeroAuto = null,
        top = null,
        bottom = null,
        right = null,
        left = null;

  /// Creates a margin with potentially different values for each side.
  const TeXViewMargin.only(
      {this.sizeUnit, this.top, this.bottom, this.right, this.left})
      : all = null,
        zeroAuto = null;

  /// Creates a margin with the value `0 auto`.
  ///
  /// This is a convenience constructor for a common CSS pattern used for centering.
  const TeXViewMargin.zeroAuto()
      : zeroAuto = "0 auto",
        sizeUnit = null,
        all = null,
        top = null,
        bottom = null,
        right = null,
        left = null;

  /// Converts this margin definition into a CSS `margin` string.
  String getMargin() {
    if (all != null) {
      return "margin:${getSizeWithUnit(all, sizeUnit)};";
    } else if (zeroAuto != null) {
      return "margin:$zeroAuto;";
    } else {
      return "margin:${getSizeWithUnit(top, sizeUnit)} ${getSizeWithUnit(right, sizeUnit)} ${getSizeWithUnit(bottom, sizeUnit)} ${getSizeWithUnit(left, sizeUnit)};";
    }
  }
}
