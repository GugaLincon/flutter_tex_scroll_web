import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/source_code_view.dart';

class TeXWidgetExamples extends StatelessWidget {
  const TeXWidgetExamples({super.key});

  final String _formula =
      r"""Flutter $ \rm\TeX $ is a Flutter Package to render so many types of equations based on \( \rm\LaTeX \), It also includes full HTML with JavaScript support. Here's a simple example of $ \rm\TeX $ rendering:
          
      When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$ Another display formula is: \[ E = mc^2 + \frac{p^2}{2m} + \sum_{i} \frac{(p_i - qA_i)^2}{2m_i} + V(r) + ... \]""";

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = Theme.of(context).textTheme.bodyMedium;

    return ExampleWrapper(
      filePath: 'lib/tex_widget_example.dart',
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TeXWidget Example"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text("Default TeXWidget",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TeXWidget(content: _formula),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text("Custom TeXWidget",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TeXWidget(
                  content: _formula,
                  displayFormulaWidgetBuilder: (context, displayFormula) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Math2SVG(
                            math: displayFormula,
                            formulaWidgetBuilder: (context, svg) =>
                                SvgPicture.string(
                              svg,
                              colorFilter: const ColorFilter.mode(
                                  Colors.red, BlendMode.srcIn),
                              width: constraints.maxWidth,
                              height: defaultTextStyle?.fontSize != null
                                  ? defaultTextStyle!.fontSize! * 4
                                  : null,
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  inlineFormulaWidgetBuilder: (context, inlineFormula) {
                    return Math2SVG(
                      math: inlineFormula,
                      formulaWidgetBuilder: (context, svg) => SvgPicture.string(
                        svg,
                        height: defaultTextStyle?.fontSize != null
                            ? defaultTextStyle!.fontSize! * 1.25
                            : null,
                        width: null,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    );
                  },
                  textWidgetBuilder: (context, text) {
                    return TextSpan(
                      text: text,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
