import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/source_code_view.dart';

main() async {
  if (!kIsWeb) {
    await TeXRenderingServer.start();
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Math2SVGExample(),
  ));
}

class Math2SVGExample extends StatefulWidget {
  const Math2SVGExample({super.key});

  @override
  State<Math2SVGExample> createState() => _Math2SVGExampleState();
}

class _Math2SVGExampleState extends State<Math2SVGExample> {
  double fontSize = 18.0;
  TextStyle baseStyle = TextStyle(fontSize: 18.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = Theme.of(context).textTheme.bodyMedium;

    return ExampleWrapper(
      filePath: 'lib/math2svg_example.dart',
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Math2SVG Example"),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("TeX",
                      style: baseStyle.copyWith(
                        fontSize: fontSize * 1.5,
                        color: Colors.black,
                      )),
                  RichText(
                    text: TextSpan(
                      style: baseStyle,
                      children: <InlineSpan>[
                        const TextSpan(text: 'When '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Math2SVG(
                            teXInputType: MathInputType.teX,
                            math: r"a \ne 0",
                            formulaWidgetBuilder: (context, svg) =>
                                SvgPicture.string(
                              svg,
                              height: defaultTextStyle?.fontSize != null
                                  ? defaultTextStyle!.fontSize! * 1.25
                                  : null,
                              width: null,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        const TextSpan(text: ', there are two solutions to'),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Math2SVG(
                            math: r"ax^2 + bx + c = 0",
                            formulaWidgetBuilder: (context, svg) =>
                                SvgPicture.string(
                              svg,
                              height: defaultTextStyle?.fontSize != null
                                  ? defaultTextStyle!.fontSize! * 1.25
                                  : null,
                              width: null,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        const TextSpan(text: ' and they are:'),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Math2SVG(
                    math: r"""x = {-b \pm \sqrt{b^2-4ac} \over 2a}""",
                    formulaWidgetBuilder: (context, svg) {
                      double displayFontSize = fontSize * 3;
                      return SvgPicture.string(
                        svg,
                        height: displayFontSize,
                        width: displayFontSize,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      );
                    },
                  )
                ],
              ),
            ),
            Divider(
              height: 20,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("MathML",
                      style: baseStyle.copyWith(
                        fontSize: fontSize * 1.5,
                        color: Colors.black,
                      )),
                  Math2SVG(
                    math: r"""
                            <math xmlns = "http://www.w3.org/1998/Math/MathML">
                              <mrow>
                                  <mrow>
                                    <msup> <mi>x</mi> <mn>2</mn> </msup> <mo>+</mo>
                                    <mrow>
                                        <mn>4</mn>
                                        <mo>⁢</mo>
                                        <mi>x</mi>
                                    </mrow>
                                    <mo>+</mo>
                                    <mn>4</mn>
                                  </mrow>
                                  
                                  <mo>=</mo>
                                  <mn>0</mn>
                              </mrow>
                            </math>""",
                    teXInputType: MathInputType.mathML,
                    formulaWidgetBuilder: (context, svg) {
                      double displayFontSize = fontSize * 1.25;
                      return SvgPicture.string(
                        svg,
                        height: displayFontSize,
                        width: displayFontSize,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("AsciiMath",
                      style: baseStyle.copyWith(
                        fontSize: fontSize * 1.5,
                        color: Colors.black,
                      )),
                  Math2SVG(
                    math: r"""sum_(i=1)^n i^3=((n(n+1))/2)^2""",
                    teXInputType: MathInputType.asciiMath,
                    formulaWidgetBuilder: (context, svg) {
                      double displayFontSize = fontSize * 5;
                      return SvgPicture.string(
                        svg,
                        height: displayFontSize,
                        width: displayFontSize,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
