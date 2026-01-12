const PACKAGE = require('mathjax-full/components/webpack.common.js');
const path = require('path');

const baseConfig = PACKAGE(
    'index',                     // the name of the package to build
    'node_modules/mathjax-full/js',    // location of the mathjax library
    [],                                   // packages to link to
    __dirname,                            // our directory
    'dist'                                   // where to put the packaged component
);

module.exports = {
    ...baseConfig, // Spread the base configuration
    output: {
        ...baseConfig.output, // Spread the base output configuration
        libraryTarget: 'umd',    // Universal Module Definition - makes it usable in various environments (CommonJS, AMD, global)
        filename: 'mathjax_core.js', // Or whatever you want the output file to be named
        path: path.resolve(__dirname, 'dist/'),
        globalObject: 'this' // Important for making it work in Node and browser environments
    },

};