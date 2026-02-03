import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

String _markdownFlutterTeX = r"""
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
  - [Math2SVG](https://flutter-tex.readthedocs.io/en/latest/Math2SVG/): Pure Flutter based (no webview) high-performance widget, for maths formulas rendering, support LaTeX, MathML and AsciiMath.
  - [TeXWidget](https://flutter-tex.readthedocs.io/en/latest/TeXWidget/): Based on `Math2SVG` dedicated for LaTeX rendering.
  - [TeXView](https://flutter-tex.readthedocs.io/en/latest/TeXView/): Advanced webview-based rendering for complex HTML/JS content.
* [👉 Click Here for Full Documentation](https://flutter-tex.readthedocs.io/en/latest/)

## 🌏 Web Demo: [https://flutter-tex.web.app/](https://flutter-tex.web.app/)


## 📦 Installation

For the detailed installation and setup instructions for different platforms , please refer to the [Installation Guide](https://flutter-tex.readthedocs.io/en/latest/Installation/).

## 📖 Full Documentation

For detailed setup instructions, API references, and advanced configurations (Custom Fonts, MathJax settings, etc.), please visit our official documentation:
<p align="center">
  <a href="https://flutter-tex.readthedocs.io/en/latest/">
    <img src="https://img.shields.io/badge/READ_THE_DOCS-PASSING?style=for-the-badge&logo=readthedocs&logoColor=white&color=blueviolet">
  </a>
</p>

<h2 align="center">
  👉 <a href="https://flutter-tex.readthedocs.io/en/latest/">Click Here for Full Documentation</a>
</h2>

# Demo Application
<a href='https://play.google.com/store/apps/details?id=com.shahxad.flutter_tex_example&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'  height="150px"/></a>

""";

class TeXViewMarkdownExamples extends StatelessWidget {
  const TeXViewMarkdownExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXViewMarkdown"),
      ),
      body: TeXView(
        child: TeXViewMarkdown(_markdownFlutterTeX,
            style: TeXViewStyle.fromCSS("")),
        style: const TeXViewStyle(
          margin: TeXViewMargin.all(10),
          padding: TeXViewPadding.all(20),
          elevation: 10,
          borderRadius: TeXViewBorderRadius.all(25),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
                borderColor: Colors.blue,
                borderStyle: TeXViewBorderStyle.solid,
                borderWidth: 5),
          ),
          backgroundColor: Colors.white,
        ),
        loadingWidgetBuilder: (context) => const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Rendering...")
            ],
          ),
        ),
      ),
    );
  }
}
