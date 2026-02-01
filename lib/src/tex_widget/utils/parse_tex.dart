import 'package:flutter_tex/flutter_tex.dart';

/// A class representing a segment of TeX input.
class TeXSegment {
  /// The text content of the segment.
  final String text;

  /// The type of the segment (text, inline, or display).
  final TeXSegmentType type;

  /// Creates a new [TeXSegment] with the given [text] and [type].
  TeXSegment(this.text, this.type);
}

// Corrected Order: More specific patterns (double delimiters) come first.
final RegExp _latexRegex = RegExp(
  "${TeXDelimiter.displayDollar.delimiter}|${TeXDelimiter.diplayBrackets.delimiter}|${TeXDelimiter.inlineDollar.delimiter}|${TeXDelimiter.inlineBrackets.delimiter}",
);

/// Parses a raw TeX string into a list of [TeXSegment]s.
///
/// This function identifies LaTeX delimiters for display and inline math,
/// splitting the string into corresponding segments of text and math.
List<TeXSegment> parseTeX(String latexString) {
  final List<TeXSegment> parsedTeXSegments = [];

  int lastEnd = 0;

  for (final RegExpMatch match in _latexRegex.allMatches(latexString)) {
    if (match.start > lastEnd) {
      final String textSegment = latexString.substring(lastEnd, match.start);
      if (textSegment.isNotEmpty) {
        parsedTeXSegments.add(TeXSegment(textSegment, TeXSegmentType.text));
      }
    }

    // Group indices are updated to match the new RegExp order.
    // displayDollar is now group 2, displayBrackets group 4, etc.
    final String displayDollarContent = match.group(2) ?? "";
    final String displayBracketContent = match.group(4) ?? "";
    final String inlineDollarContent = match.group(6) ?? "";
    final String inlineBracketContent = match.group(8) ?? "";

    // The order of these checks is also updated for clarity.
    if (displayDollarContent.isNotEmpty) {
      parsedTeXSegments
          .add(TeXSegment(displayDollarContent, TeXSegmentType.display));
    } else if (displayBracketContent.isNotEmpty) {
      parsedTeXSegments
          .add(TeXSegment(displayBracketContent, TeXSegmentType.display));
    } else if (inlineDollarContent.isNotEmpty) {
      parsedTeXSegments
          .add(TeXSegment(inlineDollarContent, TeXSegmentType.inline));
    } else if (inlineBracketContent.isNotEmpty) {
      parsedTeXSegments
          .add(TeXSegment(inlineBracketContent, TeXSegmentType.inline));
    }

    lastEnd = match.end;
  }

  if (lastEnd < latexString.length) {
    final String trailingText = latexString.substring(lastEnd);
    if (trailingText.isNotEmpty) {
      parsedTeXSegments.add(TeXSegment(trailingText, TeXSegmentType.text));
    }
  }

  return parsedTeXSegments;
}
