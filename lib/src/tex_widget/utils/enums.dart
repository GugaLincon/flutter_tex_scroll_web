enum MathInputType {
  teX("teX"),
  mathML("mathML"),
  asciiMath("asciiMath");

  final String type;

  const MathInputType(this.type);
}

enum TeXSegmentType {
  text,
  inline,
  display,
}

enum TeXDelimiter {
  inlineBrackets(r"(\\\((.*?)\\\))"),
  inlineDollar(r"(\$(.*?)\$)"),
  diplayBrackets(r"(\\\[(.*?)\\\])"),
  displayDollar(r"(\$\$(.*?)\$\$)");

  final String delimiter;

  const TeXDelimiter(this.delimiter);
}

enum TeXPackage {
  action('action'),
  amscd('amscd'),
  bbm('bbm'),
  bboldx('bboldx'),
  bbox('bbox'),
  begingroup('begingroup'),
  boldsymbol('boldsymbol'),
  braket('braket'),
  bussproofs('bussproofs'),
  cancel('cancel'),
  cases('cases'),
  centernot('centernot'),
  color('color'),
  colortbl('colortbl'),
  colorv2('colorv2'),
  dsfont('dsfont'),
  empheq('empheq'),
  enclose('enclose'),
  extpfeil('extpfeil'),
  gensymb('gensymb'),
  html('html'),
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
