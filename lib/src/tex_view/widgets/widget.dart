import 'package:flutter_tex/src/tex_view/utils/widget_meta.dart';

/// An abstract class representing a widget within the [TeXView] hierarchy.
///
/// All content elements that can be displayed in a [TeXView] must extend this class.
/// It defines the core methods for serialization to JSON and handling interactions.
abstract class TeXViewWidget {
  /// A const constructor to allow subclasses to be const.
  const TeXViewWidget();

  /// Returns metadata about the widget, such as its HTML tag and CSS classes.
  ///
  /// This is used by the rendering engine to construct the corresponding HTML element.
  TeXViewWidgetMeta meta();

  /// A callback triggered when a tap event occurs on this widget.
  ///
  /// The [id] parameter identifies the specific element that was tapped.
  /// Subclasses should override this to handle interactions.
  void onTapCallback(String id) {}

  void onWheelCallback(String id) {}

  /// Serializes the widget and its properties into a JSON-mappable object.
  ///
  /// This is a crucial part of the process that sends the widget tree structure
  /// and content to the web-based rendering engine.
  Map<dynamic, dynamic> toJson();
}
