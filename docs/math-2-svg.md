# Math2SVG

`Math2SVG` is the core engine for high-performance, pure Flutter math rendering. It parses TeX, MathML, or AsciiMath and converts it into Scalable Vector Graphics (SVG), which are then rendered using the `flutter_svg` package.

## Key Features
- **🚀 Pure Flutter**: No WebView required. Lightweight and fast.
- **💎 High Quality**: Resolution-independent rendering that looks sharp on any device.
- **🎨 Full Control**: Custom painters, colors, and sizes.

## Usage

### Basic Rendering
Pass your math string and specify the input type (default is TeX).

```dart
Math2SVG(
  math: r"ax^2 + bx + c = 0",
)
```

### Integration with RichText
`Math2SVG` can be embedded inside `RichText` via `WidgetSpan` for perfect baseline alignment.

```dart
RichText(
  text: TextSpan(
    style: TextStyle(fontSize: 18, color: Colors.black),
    children: [
      TextSpan(text: "The roots are "),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math2SVG(math: r"x = \pm 1"),
      ),
      TextSpan(text: "."),
    ],
  ),
)
```

### Full Example
A complete example showing MathJax server initialization and rendering.

??? quote "View Full Source Code"
    ```dart
    import 'package:flutter/foundation.dart';
    import 'package:flutter/material.dart';
    import 'package:flutter_tex/flutter_tex.dart';

    void main() async {
      // Initialize the rendering server (Required for mobile)
      if (!kIsWeb) {
        await TeXRenderingServer.start();
      }
      runApp(const MaterialApp(home: Math2SVGExample()));
    }

    class Math2SVGExample extends StatelessWidget {
      const Math2SVGExample({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text("Math2SVG Example")),
          body: Center(
            child: Math2SVG(
              math: r"\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}",
              formulaWidgetBuilder: (context, svg) => SvgPicture.string(
                svg,
                width: 200,
              ),
            ),
          ),
        );
      }
    }
    ```
