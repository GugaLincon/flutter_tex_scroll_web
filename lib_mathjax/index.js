//
//  Initialize the MathJax startup code
//
require('mathjax-full/components/src/startup/lib/startup.js');

//
//  Get the loader module and indicate the modules that
//  will be loaded by hand below
//
const { Loader } = require('mathjax-full/js/components/loader.js');
Loader.preLoad(
  'loader',
  'startup',
  'core',
  'input/tex-full',
  'input/mml',
  'input/asciimath',
  'output/svg',
);
//
// Load the components that we want to combine into one component
//   (the ones listed in the preLoad() call above)
require('mathjax-full/components/src/core/core.js');
require('mathjax-full/components/src/input/tex-full/tex-full.js');
require('mathjax-full/components/src/input/mml/mml.js');
require('mathjax-full/components/src/input/asciimath/asciimath.js');
require('mathjax-full/components/src/output/svg/svg.js');

//
// Update the configuration to include any updated values
//

// const { insert } = require('mathjax-full/js/util/Options.js');
// insert(MathJax.config, {
//   tex: {
//     packages: { '[+]': ['ams', 'newcommand', 'configmacros'] }
//   }
// });

//
// Loading this component will cause all the normal startup
//   operations to be performed
//
require('mathjax-full/components/src/startup/startup.js');

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

const { mathjax } = require('mathjax-full/js/mathjax.js');
const { liteAdaptor } = require('mathjax-full/js/adaptors/liteAdaptor.js');
const { RegisterHTMLHandler } = require('mathjax-full/js/handlers/html.js');
const { TeX } = require('mathjax-full/js/input/tex.js');
const { MathML } = require('mathjax-full/js/input/mathml.js');
const { AsciiMath } = require('mathjax-full/js/input/asciimath.js');
const { SVG } = require('mathjax-full/js/output/svg.js');
const { AllPackages } = require('mathjax-full/js/input/tex/AllPackages.js');


class MathJaxLiteDOM {

  constructor() {
    this.adapteor = liteAdaptor();
    RegisterHTMLHandler(this.adapteor);
    this.inputOptions = {
    };

    this.texInput = new TeX({
      packages: AllPackages,
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

const mathJaxLiteDOM = new MathJaxLiteDOM();

module.exports = { mathJaxLiteDOM: mathJaxLiteDOM };

