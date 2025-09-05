enum TeXInputType {
  teX("teX"),
  mathML("mathML"),
  asciiMath("asciiMath");

  final String value;

  const TeXInputType(this.value);
}

enum TeXSegmentType {
  text,
  inline,
  display,
}

// The order of these doesn't matter, but the order of their use in the RegExp does.
enum TeXDelimiters {
  inlineBrackets(r"(\\\((.*?)\\\))"),
  inlineDollar(r"(\$(.*?)\$)"),
  diplayBrackets(r"(\\\[(.*?)\\\])"),
  displayDollar(r"(\$\$(.*?)\$\$)");

  final String value;

  const TeXDelimiters(this.value);
}
