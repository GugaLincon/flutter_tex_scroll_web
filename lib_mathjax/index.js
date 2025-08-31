const { startup } = require('@mathjax/src/components/js/startup/init.js');
const { Loader } = require('@mathjax/src/js/components/loader.js');
const { loadFont } = require('@mathjax/src/components/js/output/svg/svg.js');
const { source } = require('@mathjax/src/components/js/source.js');


require('@mathjax/src/components/js/core/core.js');

// Input
require('@mathjax/src/components/js/input/tex/tex.js');
require('@mathjax/src/components/js/input/mml/mml.js');
require('@mathjax/src/components/js/input/asciimath/asciimath.js');

// TeX Extensions
require('@mathjax/src/components/js/input/tex/extensions/action/action.js')
require('@mathjax/src/components/js/input/tex/extensions/ams/ams.js')
require('@mathjax/src/components/js/input/tex/extensions/amscd/amscd.js')
require('@mathjax/src/components/js/input/tex/extensions/autoload/autoload.js')
require('@mathjax/src/components/js/input/tex/extensions/bbm/bbm.js')
require('@mathjax/src/components/js/input/tex/extensions/bboldx/bboldx.js')
require('@mathjax/src/components/js/input/tex/extensions/bbox/bbox.js')
require('@mathjax/src/components/js/input/tex/extensions/begingroup/begingroup.js')
require('@mathjax/src/components/js/input/tex/extensions/boldsymbol/boldsymbol.js')
require('@mathjax/src/components/js/input/tex/extensions/braket/braket.js')
require('@mathjax/src/components/js/input/tex/extensions/bussproofs/bussproofs.js')
require('@mathjax/src/components/js/input/tex/extensions/cancel/cancel.js')
require('@mathjax/src/components/js/input/tex/extensions/cases/cases.js')
require('@mathjax/src/components/js/input/tex/extensions/centernot/centernot.js')
require('@mathjax/src/components/js/input/tex/extensions/color/color.js')
require('@mathjax/src/components/js/input/tex/extensions/colortbl/colortbl.js')
require('@mathjax/src/components/js/input/tex/extensions/colorv2/colorv2.js')
require('@mathjax/src/components/js/input/tex/extensions/configmacros/configmacros.js')
require('@mathjax/src/components/js/input/tex/extensions/dsfont/dsfont.js')
require('@mathjax/src/components/js/input/tex/extensions/empheq/empheq.js')
require('@mathjax/src/components/js/input/tex/extensions/enclose/enclose.js')
require('@mathjax/src/components/js/input/tex/extensions/extpfeil/extpfeil.js')
require('@mathjax/src/components/js/input/tex/extensions/gensymb/gensymb.js')
require('@mathjax/src/components/js/input/tex/extensions/html/html.js')
require('@mathjax/src/components/js/input/tex/extensions/mathtools/mathtools.js')
require('@mathjax/src/components/js/input/tex/extensions/mhchem/mhchem.js')
require('@mathjax/src/components/js/input/tex/extensions/newcommand/newcommand.js')
require('@mathjax/src/components/js/input/tex/extensions/noerrors/noerrors.js')
require('@mathjax/src/components/js/input/tex/extensions/noundefined/noundefined.js')
require('@mathjax/src/components/js/input/tex/extensions/physics/physics.js')
require('@mathjax/src/components/js/input/tex/extensions/require/require.js')
require('@mathjax/src/components/js/input/tex/extensions/setoptions/setoptions.js')
require('@mathjax/src/components/js/input/tex/extensions/tagformat/tagformat.js')
require('@mathjax/src/components/js/input/tex/extensions/texhtml/texhtml.js')
require('@mathjax/src/components/js/input/tex/extensions/textcomp/textcomp.js')
require('@mathjax/src/components/js/input/tex/extensions/textmacros/textmacros.js')
require('@mathjax/src/components/js/input/tex/extensions/unicode/unicode.js')
require('@mathjax/src/components/js/input/tex/extensions/units/units.js')
require('@mathjax/src/components/js/input/tex/extensions/upgreek/upgreek.js')
require('@mathjax/src/components/js/input/tex/extensions/verb/verb.js')


TeXPackages = Object.keys(source).filter((name) => name.substring(0, 6) === '[tex]/').sort()


Loader.preLoaded(
  'loader',
  'startup',
  'core',
  'input/tex',
  ...TeXPackages,
  'input/mml',
  'input/asciimath',
  'output/svg',
);


loadFont(startup, true);

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

const { mathjax } = require('@mathjax/src/js/mathjax.js');
const { liteAdaptor } = require('@mathjax/src/js/adaptors/liteAdaptor.js');
const { RegisterHTMLHandler } = require('@mathjax/src/js/handlers/html.js');
const { TeX } = require('@mathjax/src/js/input/tex.js');
const { MathML } = require('@mathjax/src/js/input/mathml.js');
const { AsciiMath } = require('@mathjax/src/js/input/asciimath.js');
const { SVG } = require('@mathjax/src/js/output/svg.js');

class FlutterTeXLiteDOM {

  constructor() {
    this.adaptor = liteAdaptor();
    RegisterHTMLHandler(this.adaptor);
    this.inputOptions = {
    };

    this.texInput = new TeX({
      packages: ['base'].concat(AllPackages.map((name) => name.substring(6))),
      ...this.inputOptions
    });
    this.mathmlInput = new MathML(this.inputOptions);
    this.asciiInput = new AsciiMath(this.inputOptions);

    this.outputJax = new SVG();

  }

  teX2SVG(math, inputType, options) {
    return this.adaptor.innerHTML(mathjax.document('', {
      InputJax: this.getInputType(inputType), OutputJax: this.outputJax
    }).convert(math, options));
  }

  getInputType(input) {
    switch (input) {
      case 'teX':
        return this.texInput;
      case 'mathML':
        return this.mathmlInput;
      case 'asciiMath':
        return this.asciiInput;
      default:
        return this.texInput;
    }
  }
}


const flutterTeXLiteDOM = new FlutterTeXLiteDOM();

window.MathJax = window.MathJax || {};
window.MathJax.flutterTeXLiteDOM = flutterTeXLiteDOM;