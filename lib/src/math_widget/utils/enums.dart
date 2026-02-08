/// The type of input math to be rendered.
enum MathInputType {
  /// TeX input.
  teX("teX"),

  /// MathML input.
  mathML("mathML"),

  /// AsciiMath input.
  asciiMath("asciiMath");

  final String type;

  const MathInputType(this.type);
}

/// The type of the TeX segment which can be either [text], [inline] or [display].
enum TeXSegmentType {
  /// Text segment.
  text,

  /// Inline math segment.
  inline,

  /// Display math segment.
  display,
}

/// The delimiter used to identify the TeX segment.
enum TeXDelimiter {
  /// Inline brackets `\(...\)`
  inlineBrackets(r"(\\\((.*?)\\\))"),

  /// Inline dollar `$...$`
  inlineDollar(r"(\$(.*?)\$)"),

  /// Display brackets `\[...\]`
  displayBrackets(r"(\\\[(.*?)\\\])"),

  /// Display dollar `$$...$$`
  displayDollar(r"(\$\$(.*?)\$\$)");

  final String delimiter;

  const TeXDelimiter(this.delimiter);
}

/// The list of supported TeX packages.
enum TeXPackage {
  /// The `action` package.
  action('action'),

  /// The `amscd` package.
  amscd('amscd'),

  /// The `bbm` package.
  bbm('bbm'),

  /// The `bboldx` package.
  bboldx('bboldx'),

  /// The `bbox` package.
  bbox('bbox'),

  /// The `begingroup` package.
  begingroup('begingroup'),

  /// The `boldsymbol` package.
  boldsymbol('boldsymbol'),

  /// The `braket` package.
  braket('braket'),

  /// The `bussproofs` package.
  bussproofs('bussproofs'),

  /// The `cancel` package.
  cancel('cancel'),

  /// The `cases` package.
  cases('cases'),

  /// The `centernot` package.
  centernot('centernot'),

  /// The `color` package.
  color('color'),

  /// The `colortbl` package.
  colortbl('colortbl'),

  /// The `colorv2` package.
  colorv2('colorv2'),

  /// The `dsfont` package.
  dsfont('dsfont'),

  /// The `empheq` package.
  empheq('empheq'),

  /// The `enclose` package.
  enclose('enclose'),

  /// The `extpfeil` package.
  extpfeil('extpfeil'),

  /// The `gensymb` package.
  gensymb('gensymb'),

  /// The `html` package.
  html('html'),

  /// The `mathtools` package.
  mathtools('mathtools'),
  mhchem('mhchem'),
  noerrors('noerrors'),
  physics('physics'),
  setoptions('setoptions'),
  tagformat('tagformat'),
  texhtml('texhtml'),
  textcomp('textcomp'),
  unicode('unicode'),
  units('units'),
  upgreek('upgreek'),
  verb('verb');

  final String pkg;

  const TeXPackage(this.pkg);
}
