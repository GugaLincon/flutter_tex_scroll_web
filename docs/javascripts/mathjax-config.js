window.MathJax = {
  // 1. Basic configuration for LaTeX
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']],
    displayMath: [['$$', '$$'], ['\\[', '\\]']],
    processEscapes: true
  },
  // 2. The "Fastest" SVG setting
  svg: {
    fontCache: 'global' 
  }
};