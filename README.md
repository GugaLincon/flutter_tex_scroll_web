[![GitHub stars](https://img.shields.io/github/stars/Shahxad-Akram/flutter_tex?style=social)](https://github.com/Shahxad-Akram/flutter_tex/stargazers) [![pub package](https://img.shields.io/pub/v/flutter_tex.svg)](https://pub.dev/packages/flutter_tex)

<div align="middle">
  <img src="https://raw.githubusercontent.com/Shahxad-Akram/flutter_tex/master/logo.png" height="250px"/>
</div>


A self-contained Flutter package leveraging [MathJax](https://github.com/mathjax/MathJax) to deliver robust, fully offline rendering of mathematical and chemical notations.
---

## 🚀 Key Features

* **Offline Rendering**: No internet connection required after setup.
* **Multiple Formats**: Supports LaTeX, MathML, and AsciiMath.
* **Three Powerful Widgets**:
  - [Math2SVG](https://flutter-tex.readthedocs.io/en/latest/math-2-svg/): Pure Flutter based (no webview) high-performance widget, for maths formulas rendering, support LaTeX, MathML and AsciiMath.
  - [TeXWidget](https://flutter-tex.readthedocs.io/en/latest/tex-widget/): Based on `Math2SVG` dedicated for LaTeX rendering.
  - [TeXView](https://flutter-tex.readthedocs.io/en/latest/tex-view/): Advanced webview-based rendering for complex HTML/JS content.
* [👉 Click Here for Full Documentation](https://flutter-tex.readthedocs.io/en/latest/)

# Screenshots
 |                                                 TeXWidget                                                  |                                                  Quiz Sample                                                  |                                               TeX Document                                               |
 | :--------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: |
 | <img src="https://raw.githubusercontent.com/Shahxad-Akram/flutter_tex/master/screenshots/tex_widget.png"/> | <img src="https://raw.githubusercontent.com/Shahxad-Akram/flutter_tex/master/screenshots/tex_view_quiz.png"/> | <img src="https://raw.githubusercontent.com/Shahxad-Akram/flutter_tex/master/screenshots/tex_view.png"/> |


## 📦 Installation

For the detailed installation and setup instructions for different platforms , please refer to the [Installation Guide](https://flutter-tex.readthedocs.io/en/latest/installation/).

## 🛠 Quick Example

> [!CAUTION]
Make sure to follow the [Installation Guide](https://flutter-tex.readthedocs.io/en/latest/installation/) before running the example.

```dart
TeXWidget(math: r"When \(a \ne 0 \), then $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$")
```
Output:

When $a \ne 0$, then
$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$



## 📖 Full Documentation

For detailed setup instructions, API references, and advanced configurations (Custom Fonts, MathJax settings, etc.), please visit our official documentation:
<p align="center">
  <a href="https://flutter-tex.readthedocs.io">
    <img src="https://img.shields.io/badge/READ_THE_DOCS-PASSING?style=for-the-badge&logo=readthedocs&logoColor=white&color=blueviolet">
  </a>
</p>

<h2 align="center">
  👉 <a href="https://flutter-tex.readthedocs.io">Click Here for Full Documentation</a>
</h2>


## Demos
<table>
  <tr>
    <td align="center">
      <a href="https://flutter-tex.web.app" target="_blank">
        <img src="https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png" height="75" alt="Flutter Web">
      </a>
      <br />
      <h3>Web Demo</h3>
      <p>View Flutter TeX implementation directly in your browser.</p>
    </td>
    <td align="center">
      <a href="https://play.google.com/store/apps/details?id=com.shahxad.flutter_tex_example" target="_blank">
        <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" height="75" alt="Get it on Google Play"/>
      </a>
      <br />
      <h3>Android App</h3>
      <p>Install the example application from the Play Store.</p>
    </td>
    <td align="center">
      <a href="https://www.youtube.com/watch?v=YiNbVEXV_NM" target="_blank">
         <img src="https://upload.wikimedia.org/wikipedia/commons/0/09/YouTube_full-color_icon_%282017%29.svg" height="75" alt="YouTube Demo"/>
      </a>
      <br />
      <h3>Video Demo</h3>
      <p>A quick video showcasing the features.</p>
    </td>
  </tr>
</table>