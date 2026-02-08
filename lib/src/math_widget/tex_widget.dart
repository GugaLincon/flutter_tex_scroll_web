import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/math_widget/utils/parse_tex.dart';

/// A widget that parses and renders mixed content containing text and TeX formulas.
///
/// This widget automatically detects TeX segments (both inline and display math)
/// and renders them using [Math2SVG], while displaying regular text using [RichText].
class TeXWidget extends StatefulWidget {
  /// The input content string containing mixed text and TeX formulas.
  ///
  /// Example: "The solution is $x=2$ where $$y=x^2$$."
  final String content;

  /// A builder for customizing the display of inline formulas (e.g., $...$).
  ///
  /// If provided, this builder is used instead of the default [Math2SVG] rendering.
  final Widget Function(BuildContext context, String inlineFormula)?
      inlineFormulaWidgetBuilder;

  /// A builder for customizing the display of block formulas (e.g., $$...$$).
  ///
  /// If provided, this builder is used instead of the default [Math2SVG] rendering.
  final Widget Function(BuildContext context, String displayFormula)?
      displayFormulaWidgetBuilder;

  /// A builder for customizing the display of regular text segments.
  ///
  /// Use this to apply custom styles or gestures to the text parts of the content.
  final InlineSpan Function(BuildContext context, String text)?
      textWidgetBuilder;

  /// Creates a [TeXWidget].
  const TeXWidget({
    super.key,
    required this.content,
    this.inlineFormulaWidgetBuilder,
    this.displayFormulaWidgetBuilder,
    this.textWidgetBuilder,
  });

  @override
  State<TeXWidget> createState() => _TeXWidgetState();
}

class _TeXWidgetState extends State<TeXWidget> {
  late List<TeXSegment> _segments;

  @override
  void initState() {
    super.initState();
    _segments = parseTeX(widget.content);
  }

  @override
  void didUpdateWidget(TeXWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      setState(() {
        _segments = parseTeX(widget.content);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_segments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final List<Widget> columnChildren = [];
    final List<InlineSpan> currentRichTextSpans = [];
    final style = Theme.of(context).textTheme.bodyMedium;
    final double? fontSize = style?.fontSize;

    // Flushes accumulated text spans into a RichText widget and adds it to the column.
    void flushSpans() {
      if (currentRichTextSpans.isNotEmpty) {
        columnChildren.add(
          RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              style: style,
              children: List.of(currentRichTextSpans),
            ),
          ),
        );
        currentRichTextSpans.clear();
      }
    }

    for (final segment in _segments) {
      final String mathContent = segment.text;

      switch (segment.type) {
        case TeXSegmentType.text:
          currentRichTextSpans.add(
            widget.textWidgetBuilder?.call(context, mathContent) ??
                TextSpan(text: mathContent, style: style),
          );
          break;

        case TeXSegmentType.inline:
          currentRichTextSpans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child:
                widget.inlineFormulaWidgetBuilder?.call(context, mathContent) ??
                    Math2SVG(
                      key: ValueKey('inline_$mathContent'),
                      math: mathContent,
                      formulaWidgetBuilder: (context, svg) => SvgPicture.string(
                        svg,
                        height: fontSize != null ? fontSize * 1.125 : null,
                        fit: BoxFit.contain,
                      ),
                    ),
          ));
          break;

        case TeXSegmentType.display:
          flushSpans();
          columnChildren.add(
            widget.displayFormulaWidgetBuilder?.call(context, mathContent) ??
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Math2SVG(
                      key: ValueKey('display_$mathContent'),
                      math: mathContent,
                      formulaWidgetBuilder: (context, svg) => SvgPicture.string(
                        svg,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: fontSize != null ? fontSize * 3.375 : null,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
          );
          break;
      }
    }
    flushSpans();
    return columnChildren;
  }
}
