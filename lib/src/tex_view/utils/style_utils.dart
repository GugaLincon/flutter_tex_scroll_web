import 'dart:ui';

import 'package:flutter_tex/flutter_tex.dart';

/// A default CSS style applied to the root TeXView container.
///
/// `position: relative;` is important for ensuring that absolutely positioned
/// children within the view are positioned relative to the container itself.
String teXViewDefaultStyle = "position: relative;";

/// Converts a Flutter [Color] object into a CSS `rgba()` string.
///
/// If the color is null, it defaults to transparent black.
String getColor(Color? color) {
  return "rgba(${((color?.r ?? 0) * 255).toInt()}, ${((color?.g ?? 0) * 255).toInt()}, ${((color?.b ?? 0) * 255).toInt()}, ${color?.a ?? 0})";
}

/// Generates a CSS `box-shadow` value to simulate elevation.
///
/// The [elevation] value is used to create a simple shadow effect.
/// The [sizeUnit] determines the unit for the shadow offsets.
String getElevation(int? elevation, TeXViewSizeUnit? sizeUnit) {
  return "0 ${elevation ?? 0 * 1}${UnitHelper.getValue(sizeUnit)} ${elevation ?? 0 * 2}${UnitHelper.getValue(sizeUnit)} 0 rgba(0,0,0,0.2)";
}

/// Combines a numerical [value] with its [sizeUnit] to create a CSS size string.
///
/// For example, `getSizeWithUnit(10, TeXViewSizeUnit.pixels)` returns `"10px"`.
/// Defaults to 0 if the value is null.
String getSizeWithUnit(int? value, TeXViewSizeUnit? sizeUnit) {
  return (value ?? 0).toString() + UnitHelper.getValue(sizeUnit);
}
