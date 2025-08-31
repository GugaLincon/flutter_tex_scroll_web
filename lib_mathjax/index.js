const { startup } = require('@mathjax/src/components/js/startup/init.js');
const { Loader } = require('@mathjax/src/js/components/loader.js');
const { loadFont } = require('@mathjax/src/components/js/output/svg/svg.js');
const { source } = require('@mathjax/src/components/js/source.js');

// AllPackages = Object.keys(source).filter((name) => name.substring(0, 6) === '[tex]/').sort()


require('@mathjax/src/components/js/core/core.js');
require('@mathjax/src/components/js/input/tex/tex.js');
// for (const ext of AllPackages.map((ext) => ext.replace('[tex]/', ''))) {
//   require(`@mathjax/src/components/js/input/tex/extensions/${ext}/${ext}.js`);
// }
require('@mathjax/src/components/js/input/mml/mml.js');
require('@mathjax/src/components/js/input/asciimath/asciimath.js');



Loader.preLoaded(
  'loader',
  'startup',
  'core',
  'input/tex',
  // ...AllPackages,
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
    this.adapteor = liteAdaptor();
    RegisterHTMLHandler(this.adapteor);
    this.inputOptions = {
    };

    this.texInput = new TeX({
      // packages: AllPackages,
      ...this.inputOptions
    });
    this.mathmlInput = new MathML(this.inputOptions);
    this.asciiInput = new AsciiMath(this.inputOptions);

    this.outputJax = new SVG();

  }

  teX2SVG(math, inputType, options) {
    return this.adapteor.innerHTML(mathjax.document('', {
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