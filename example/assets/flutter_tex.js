window.MathJax = {
    tex: {
        packages: ['mhchem'],
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']],

    },
    svg: {
        fontCache: 'global'
    }
};

console.log('MathJax configuration loaded...!');