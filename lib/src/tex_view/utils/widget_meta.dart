/// An enumeration that defines the role of a [TeXViewWidget] in the widget tree.
///
/// This helps the rendering engine understand how to structure the HTML elements.
enum Node {
  /// The root of the widget tree. There should only be one root.
  root,

  /// A widget that contains a single child widget.
  internalChild,

  /// A widget that contains a list of child widgets.
  internalChildren,

  /// A widget that does not have any children (a terminal node).
  leaf,
}

/// Metadata associated with a [TeXViewWidget].
///
/// This class holds information that is used to generate the corresponding
/// HTML element, including its ID, class list, tag name, and its role in the tree.
class TeXViewWidgetMeta {
  /// The unique ID for the HTML element.
  final String? id;

  /// A space-separated list of CSS classes for the HTML element.
  final String? classList;

  /// The HTML tag name for the element (e.g., 'div', 'p', 'span').
  final String? tag;

  /// The role of this widget in the widget tree, as defined by [Node].
  final Node? node;

  /// Creates a metadata object for a [TeXViewWidget].
  const TeXViewWidgetMeta({this.id, this.classList, this.tag, this.node});

  /// Converts this metadata into a JSON format for the rendering engine.
  Map<String, String?> toJson() => {
        'id': id,
        'classList': classList,
        'tag': tag,
        'node': _getNodeValue(node),
      };

  /// Returns the string representation of a [Node] value.
  static String _getNodeValue(Node? node) {
    switch (node) {
      case Node.root:
        return "root";
      case Node.internalChild:
        return "internal_child";
      case Node.internalChildren:
        return "internal_children";
      case Node.leaf:
        return "leaf";
      default:
        return "leaf"; // Default to leaf if the node is null.
    }
  }
}
