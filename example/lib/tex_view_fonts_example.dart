import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/source_code_view.dart';

/// A widget that demonstrates the use of custom fonts within [TeXView].
///
/// This example shows how to apply different font families to [TeXViewWidget]s
/// to change their appearance.
class TeXViewFontsExamples extends StatelessWidget {
  const TeXViewFontsExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleWrapper(
      filePath: 'lib/tex_view_fonts_example.dart',
      child: Scaffold(
          appBar: AppBar(
            title: const Text("TeXView Fonts"),
          ),
          body: TeXView(
            child: TeXViewColumn(children: [
              _teXViewWidget("Army", 'army'),
              _teXViewWidget("Budhrg", 'budhrg'),
              _teXViewWidget("CELTG", 'celtg'),
              _teXViewWidget("Hillock", 'hillock'),
              _teXViewWidget("intimacy", 'intimacy'),
              _teXViewWidget("Sansation Light", 'sansation_light'),
              _teXViewWidget("Slenmini", 'slenmini'),
              _teXViewWidget("Subaccuz Regular'", 'subaccuz_regular')
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(16),
              elevation: 2,
              borderRadius: TeXViewBorderRadius.all(16),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    borderColor: Colors.blueGrey,
                    borderStyle: TeXViewBorderStyle.solid,
                    borderWidth: 1),
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
          )),
    );
  }

  static TeXViewWidget _teXViewWidget(String title, String fontFamily) {
    return TeXViewColumn(
        style: const TeXViewStyle(
          margin: TeXViewMargin.all(5),
          padding: TeXViewPadding.all(5),
          borderRadius: TeXViewBorderRadius.all(10),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
                borderWidth: 2,
                borderStyle: TeXViewBorderStyle.groove,
                borderColor: Colors.green),
          ),
        ),
        children: [
          TeXViewDocument(title,
              style: TeXViewStyle(
                  fontStyle: TeXViewFontStyle(
                      fontSize: 20,
                      sizeUnit: TeXViewSizeUnit.pt,
                      fontFamily: fontFamily),
                  padding: const TeXViewPadding.all(10),
                  borderRadius: const TeXViewBorderRadius.all(10),
                  textAlign: TeXViewTextAlign.center,
                  width: 250,
                  margin: const TeXViewMargin.zeroAuto())),
        ]);
  }
}
