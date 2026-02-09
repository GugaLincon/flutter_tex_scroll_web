import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/maths_examples.dart';
import 'package:flutter_tex_example/source_code_view.dart';

/// A widget that demonstrates the usage of the [TeXWidget].
///
/// It shows both a default implementation and a custom implementation where
/// specific builders are used to style text, inline formulas, and display formulas differently.
class TeXWidgetExamples extends StatelessWidget {
  const TeXWidgetExamples({super.key});

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
                child: TeXWidget(content: teXWidgetContent),
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
                  content: teXWidgetContent,
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
