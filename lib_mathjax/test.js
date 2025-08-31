const { source } = require('@mathjax/src/components/js/source.js');
AllPackages = Object.keys(source).filter((name) => name.substring(0, 6) === '[tex]/').sort()

console.log(AllPackages);

for (const ext of AllPackages.map((ext) => ext.replace('[tex]/', ''))) {
    console.log(`@mathjax/src/components/js/input/tex/extensions/${ext}/${ext}.js`);
}