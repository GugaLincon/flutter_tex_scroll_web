import 'package:flutter/widgets.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/tex_view/tex_view_mobile.dart'
    if (dart.library.html) 'package:flutter_tex/src/tex_view/tex_view_web.dart';

/// A widget for rendering TeX (LaTeX, MathML, etc.) content with HTML and JavaScript support.
///
/// This widget uses a platform-specific implementation (`WebView` for mobile, `iframe` for web)
/// to render rich mathematical and scientific content. It supports full HTML and JavaScript,
/// allowing for complex and interactive visualizations.
class TeXView extends StatefulWidget {
  /// The main content to be rendered, encapsulated within a [TeXViewWidget].
  ///
  /// This is typically a [TeXViewColumn] or a single content widget like [TeXViewDocument].
  final TeXViewWidget child;

  /// Custom styling for the [TeXView] container.
  ///
  /// This allows you to control properties like margins, padding, and background color.
  final TeXViewStyle? style;

  /// An additional height offset to be added to the final rendered view.
  ///
  /// This can be useful for fine-tuning the layout and avoiding scroll bars.
  final double heightOffset;

  /// A builder for a widget to display while the TeX content is rendering.
  ///
  /// If not provided, a default loading indicator will be shown.
  final Widget Function(BuildContext context)? loadingWidgetBuilder;

  /// A callback function that is triggered when the TeX content has finished rendering.
  ///
  /// It provides the calculated height of the rendered content.
  final Function(double height)? onRenderFinished;

  /// Scroll controller to sync with the tex scroll.
  /// This has no effect in platforms other than web.
  final ScrollController? scrollController;

  /// Whether to keep the [TeXView] alive in a list (e.g., [ListView]).
  ///
  /// Defaults to `false`. Set to `true` if this [TeXView] is within a scrollable
  /// list to prevent it from being disposed and re-rendered when scrolled out of view.
  final bool wantKeepAlive;

  /// Creates a [TeXView] widget.
  const TeXView({
    super.key,
    required this.child,
    this.style,
    this.wantKeepAlive = true,
    this.heightOffset = 5.0,
    this.loadingWidgetBuilder,
    this.onRenderFinished,
    this.scrollController,
  });

  @override
  TeXViewState createState() => TeXViewState();
}
