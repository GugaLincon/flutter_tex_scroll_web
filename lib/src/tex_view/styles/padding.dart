import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_view/utils/style_utils.dart';

/// Defines the padding for a [TeXView] widget, controlling the space inside its border.
///
/// This class allows for specifying padding on all sides uniformly or on each side
/// individually.
class TeXViewPadding {
  /// The unit for the padding values (e.g., pixels, percentage).
  final TeXViewSizeUnit? sizeUnit;

  /// The padding on the top side.
  final int? top;

  /// The padding on the bottom side.
  final int? bottom;

  /// The padding on the right side.
  final int? right;

  /// The padding on the left side.
  final int? left;

  /// A uniform padding for all four sides.
  ///
  /// If this is provided, the individual side properties ([top], [bottom], [right], [left]) are ignored.
  final int? all;

  /// Creates padding with a uniform value for all four sides.
  const TeXViewPadding.all(this.all, {this.sizeUnit})
      : top = null,
        bottom = null,
        right = null,
        left = null;

  /// Creates padding with potentially different values for each side.
  const TeXViewPadding.only(
      {this.sizeUnit, this.top, this.bottom, this.right, this.left})
      : all = null;

  /// Converts this padding definition into a CSS `padding` string.
  String getPadding() {
    if (all != null) {
      return "padding: ${getSizeWithUnit(all, sizeUnit)};";
    } else {
      return "padding: ${getSizeWithUnit(top, sizeUnit)} ${getSizeWithUnit(right, sizeUnit)} ${getSizeWithUnit(bottom, sizeUnit)} ${getSizeWithUnit(left, sizeUnit)};";
    }
  }
}
