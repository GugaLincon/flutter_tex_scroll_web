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

<div style="display: flex; justify-content: space-around; align-items: stretch; gap: 20px; text-align: center; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;">
  
  <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
    <div style="height: 80px; display: flex; align-items: center; justify-content: center;">
      <a href="https://flutter-tex.web.app">
        <img src="https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png" width="225" alt="Flutter Web">
      </a>
    </div>
    <h3 style="margin: 20px 0 10px 0; height: 1.2em;">Web Demo</h3>
    <p style="font-size: 14px; color: #555; line-height: 1.4; margin: 0;">View the live Flutter TeX implementation directly in your browser.</p>
  </div>

  <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
    <div style="height: 80px; display: flex; align-items: center; justify-content: center;">
      <a href="https://play.google.com/store/apps/details?id=com.shahxad.flutter_tex_example">
        <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="250" alt="Get it on Google Play"/>
      </a>
    </div>
    <h3 style="margin: 20px 0 10px 0; height: 1.2em;">Android App</h3>
    <p style="font-size: 14px; color: #555; line-height: 1.4; margin: 0;">Download and install the example application from the Google Play Store.</p>
  </div>

  <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
    <div style="height: 80px; display: flex; align-items: center; justify-content: center;">
      <a href="https://www.youtube.com/watch?v=YiNbVEXV_NM">
         <img src="https://upload.wikimedia.org/wikipedia/commons/0/09/YouTube_full-color_icon_%282017%29.svg" width="100" alt="YouTube Demo"/>
      </a>
    </div>
    <h3 style="margin: 20px 0 10px 0; height: 1.2em;">Video Demo</h3>
    <p style="font-size: 14px; color: #555; line-height: 1.4; margin: 0;">Watch a quick video on YouTube showcasing the features.</p>
  </div>

</div>

