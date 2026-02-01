// Import necessary MathJax components and modules
import { startup } from '@mathjax/src/components/js/startup/init.js';
import { Loader } from '@mathjax/src/js/components/loader.js';

// Import core MathJax components
import '@mathjax/src/components/js/core/core.js';
// Input modules for different formats
import '@mathjax/src/components/js/input/tex/tex.js';
import '@mathjax/src/components/js/input/mml/mml.js';
import '@mathjax/src/components/js/input/asciimath/asciimath.js';
// TeX Extensions for additional functionalities
import '@mathjax/src/components/js/input/tex/extensions/action/action.js';
import '@mathjax/src/components/js/input/tex/extensions/amscd/amscd.js';
import '@mathjax/src/components/js/input/tex/extensions/bbm/bbm.js';
import '@mathjax/src/components/js/input/tex/extensions/bboldx/bboldx.js';
import '@mathjax/src/components/js/input/tex/extensions/bbox/bbox.js';
import '@mathjax/src/components/js/input/tex/extensions/begingroup/begingroup.js';
import '@mathjax/src/components/js/input/tex/extensions/boldsymbol/boldsymbol.js';
import '@mathjax/src/components/js/input/tex/extensions/braket/braket.js';
import '@mathjax/src/components/js/input/tex/extensions/bussproofs/bussproofs.js';
import '@mathjax/src/components/js/input/tex/extensions/cancel/cancel.js';
import '@mathjax/src/components/js/input/tex/extensions/cases/cases.js';
import '@mathjax/src/components/js/input/tex/extensions/centernot/centernot.js';
import '@mathjax/src/components/js/input/tex/extensions/color/color.js';
import '@mathjax/src/components/js/input/tex/extensions/colortbl/colortbl.js';
import '@mathjax/src/components/js/input/tex/extensions/colorv2/colorv2.js';
import '@mathjax/src/components/js/input/tex/extensions/dsfont/dsfont.js';
import '@mathjax/src/components/js/input/tex/extensions/empheq/empheq.js';
import '@mathjax/src/components/js/input/tex/extensions/enclose/enclose.js';
import '@mathjax/src/components/js/input/tex/extensions/extpfeil/extpfeil.js';
import '@mathjax/src/components/js/input/tex/extensions/gensymb/gensymb.js';
import '@mathjax/src/components/js/input/tex/extensions/html/html.js';
import '@mathjax/src/components/js/input/tex/extensions/mathtools/mathtools.js';
import '@mathjax/src/components/js/input/tex/extensions/mhchem/mhchem.js';
import '@mathjax/src/components/js/input/tex/extensions/noerrors/noerrors.js';
import '@mathjax/src/components/js/input/tex/extensions/physics/physics.js';
import '@mathjax/src/components/js/input/tex/extensions/setoptions/setoptions.js';
import '@mathjax/src/components/js/input/tex/extensions/tagformat/tagformat.js';
import '@mathjax/src/components/js/input/tex/extensions/texhtml/texhtml.js';
import '@mathjax/src/components/js/input/tex/extensions/textcomp/textcomp.js';
import '@mathjax/src/components/js/input/tex/extensions/unicode/unicode.js';
import '@mathjax/src/components/js/input/tex/extensions/units/units.js';
import '@mathjax/src/components/js/input/tex/extensions/upgreek/upgreek.js';
import '@mathjax/src/components/js/input/tex/extensions/verb/verb.js';
// Output module for SVG rendering
import { loadFont } from '@mathjax/src/components/js/output/svg/svg.js';

// Preload necessary components for MathJax
Loader.preLoaded(
  'loader',
  'startup',
  'core',
  'input/tex',
  'input/mml',
  'input/asciimath',
  'output/svg',
);

// Save the version of the MathJax core
Loader.saveVersion('mathjax_core.js');

// Load the font for MathJax
loadFont(startup, true);

// Import MathJax MHchem font extension
import '@mathjax/mathjax-mhchem-font-extension/svg.js';

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// Import additional MathJax components
import { mathjax } from '@mathjax/src/js/mathjax.js';
import { liteAdaptor } from '@mathjax/src/js/adaptors/liteAdaptor.js';
import { RegisterHTMLHandler } from '@mathjax/src/js/handlers/html.js';
import { TeX } from '@mathjax/src/js/input/tex.js';
import { MathML } from '@mathjax/src/js/input/mathml.js';
import { AsciiMath } from '@mathjax/src/js/input/asciimath.js';
import { SVG } from '@mathjax/src/js/output/svg.js';
import { GLOBAL } from '@mathjax/src/js/components/global.js';

// Class definition for FlutterTeXLiteDOM
class FlutterTeXLiteDOM {

  constructor() {
    // Initialize options and adaptor
    this.options = {};
    this.adaptor = liteAdaptor();
    RegisterHTMLHandler(this.adaptor);
    this.outputJax = new SVG();
  }

  // Initialize TeX document
  initTeXDoc() {
    this.teXDoc = mathjax.document('', {
      InputJax: new TeX({
        packages: ['base',
          'ams',
          'newcommand',
          'textmacros',
          'noundefined',
          'require',
          'autoload',
          'configmacros'].concat(tex_packages || []),
        ...this.options,
      }), OutputJax: this.outputJax
    });
    return this.teXDoc;
  }

  // Initialize MathML document
  initMathMLDoc() {
    this.mathmlDoc = mathjax.document('', { InputJax: new MathML(this.options), OutputJax: this.outputJax });
    return this.mathmlDoc;
  }

  // Initialize AsciiMath document
  initAsciiMathDoc() {
    this.asciiDoc = mathjax.document('', { InputJax: new AsciiMath(this.options), OutputJax: this.outputJax });
    return this.asciiDoc;
  }

  // Convert TeX to SVG
  teX2SVG(math, inputType, options) {
    return this.adaptor.innerHTML(this.#getJaxDoc(inputType).convert(math, options));
  }

  // Get the appropriate Jax document based on input type
  #getJaxDoc(input) {
    switch (input) {
      case 'teX':
        return this.teXDoc || this.initTeXDoc();
      case 'mathML':
        return this.mathmlDoc || this.initMathMLDoc();
      case 'asciiMath':
        return this.asciiDoc || this.initAsciiMathDoc();
      default:
        return this.teXDoc || this.initTeXDoc();
    }
  }
}

// Create an instance of FlutterTeXLiteDOM
const flutterTeXLiteDOM = new FlutterTeXLiteDOM();

// 1. Ensure MathJax global exists
window.MathJax = window.MathJax || {};

// 2. Attach your custom class to MathJax
window.MathJax.flutterTeXLiteDOM = flutterTeXLiteDOM;

// 3. Attach the standard typesetPromise for HTML function
window.MathJax.typesetPromise = (elements) => {
  // If using the component system, startup handles this
  if (startup && startup.promise) {
    return startup.promise.then(() => startup.typeset(elements));
  }
  // Fallback to manual conversion if not using the component sequence
  return Promise.resolve();
};

// 4. Signal that everything is ready
window.MathJax.startup = window.MathJax.startup || {};
window.MathJax.startup.promise = Promise.resolve();