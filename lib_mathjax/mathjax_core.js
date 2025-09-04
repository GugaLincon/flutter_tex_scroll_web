import { startup } from '@mathjax/src/components/js/startup/init.js';
import { Loader } from '@mathjax/src/js/components/loader.js';

import '@mathjax/src/components/js/core/core.js';
// Input
import '@mathjax/src/components/js/input/tex/tex.js';
import '@mathjax/src/components/js/input/mml/mml.js';
import '@mathjax/src/components/js/input/asciimath/asciimath.js';
// TeX Extensions

// import '@mathjax/src/components/js/input/tex/extensions/newcommand/newcommand.js';
// import '@mathjax/src/components/js/input/tex/extensions/noundefined/noundefined.js';
// import '@mathjax/src/components/js/input/tex/extensions/textmacros/textmacros.js';
// import '@mathjax/src/components/js/input/tex/extensions/ams/ams.js';
// import '@mathjax/src/components/js/input/tex/extensions/autoload/autoload.js';
// import '@mathjax/src/components/js/input/tex/extensions/configmacros/configmacros.js';
// import '@mathjax/src/components/js/input/tex/extensions/require/require.js';

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
// Output
import { loadFont } from '@mathjax/src/components/js/output/svg/svg.js';

Loader.preLoaded(
  'loader',
  'startup',
  'core',
  'input/tex',
  'input/mml',
  'input/asciimath',
  'output/svg',
);


Loader.saveVersion('mathjax_core.js');

loadFont(startup, true);

import '@mathjax/mathjax-mhchem-font-extension/svg.js';

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


import { mathjax } from '@mathjax/src/js/mathjax.js';
import { liteAdaptor } from '@mathjax/src/js/adaptors/liteAdaptor.js';
import { RegisterHTMLHandler } from '@mathjax/src/js/handlers/html.js';
import { TeX } from '@mathjax/src/js/input/tex.js';
import { MathML } from '@mathjax/src/js/input/mathml.js';
import { AsciiMath } from '@mathjax/src/js/input/asciimath.js';
import { SVG } from '@mathjax/src/js/output/svg.js';
import { GLOBAL } from '@mathjax/src/js/components/global.js';


class FlutterTeXLiteDOM {

  constructor() {
    this.adaptor = liteAdaptor();
    RegisterHTMLHandler(this.adaptor);
    this.outputJax = new SVG();

  }

  // ['base'].concat(Object.keys(source).filter((name) => name.substring(0, 6) === '[tex]/').sort().map((name) => name.substring(6)))

  initTeXInput(packages, options) {
    this.texInput = new TeX({
      packages: ['base',
        'ams',
        'newcommand',
        'textmacros',
        'noundefined',
        'require',
        'autoload',
        'configmacros'].concat(packages || []),
      ...options
    });
  }

  initMathMLInput(options) {
    this.mathmlInput = new MathML(options);
  }

  initAsciiMathInput(options) {
    this.asciiInput = new AsciiMath(options);
  }

  teX2SVG(math, inputType, options) {
    return this.adaptor.innerHTML(mathjax.document('', {
      InputJax: this.#getInputType(inputType), OutputJax: this.outputJax
    }).convert(math, options));
  }

  #getInputType(input) {
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
GLOBAL.MathJax.flutterTeXLiteDOM = flutterTeXLiteDOM;