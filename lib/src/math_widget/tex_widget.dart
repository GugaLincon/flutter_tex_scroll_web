import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/math_widget/utils/parse_tex.dart';

/// A widget to render TeX segments, which can be inline or display math.
/// Currently, it only supports rendering TeX.

class TeXWidget extends StatefulWidget {
  final String content;
  final Widget Function(BuildContext context, String inlineFormula)?
      inlineFormulaWidgetBuilder;
  final Widget Function(BuildContext context, String displayFormula)?
      displayFormulaWidgetBuilder;
  final InlineSpan Function(BuildContext context, String text)?
      textWidgetBuilder;

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

    // Use a ListView.shrinkWrap if this is part of a larger scroll view,
    // or just a Column for static blocks.
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

    // Helper to push text/inline math into the Column
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
                      key: ValueKey(
                          'inline_$mathContent'), // VITAL: Maintain widget state
                      math: mathContent,
                      formulaWidgetBuilder: (context, svg) => SvgPicture.string(
                        svg,
                        height: fontSize != null
                            ? fontSize * 1.125
                            : null, // Slightly larger for readability
                        fit: BoxFit.contain,
                      ),
                    ),
          ));
          break;

        case TeXSegmentType.display:
          flushSpans(); // Move pending text to the Column
          columnChildren.add(
            widget.displayFormulaWidgetBuilder?.call(context, mathContent) ??
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Math2SVG(
                      key: ValueKey('display_$mathContent'), // VITAL
                      math: mathContent,
                      formulaWidgetBuilder: (context, svg) => SvgPicture.string(
                        svg,
                        // Display math is usually larger.
                        // Instead of LayoutBuilder, we use a constrained box or let SVG fit width.
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
