import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/source_code_view.dart';

/// A widget that demonstrates the interactivity of [TeXViewInkWell].
///
/// This example shows how to handle tap events on different elements within the [TeXView],
/// distinguishing between them using unique IDs and optionally showing a ripple effect.
class TeXViewInkWellExample extends StatefulWidget {
  const TeXViewInkWellExample({super.key});

  @override
  State<TeXViewInkWellExample> createState() => _TeXViewInkWellExampleState();
}

class _TeXViewInkWellExampleState extends State<TeXViewInkWellExample> {
  final TeXViewStyle _teXViewStyle = const TeXViewStyle(
    margin: TeXViewMargin.all(10),
    padding: TeXViewPadding.all(10),
    borderRadius: TeXViewBorderRadius.all(10),
    overflow: TeXViewOverflow.hidden,
    border: TeXViewBorder.all(
      TeXViewBorderDecoration(
          borderColor: Colors.blue,
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 2),
    ),
  );

  String tappedId = "No InkWell!!! Please Tap an InkWell";

  @override
  Widget build(BuildContext context) {
    return ExampleWrapper(
      filePath: 'lib/tex_view_ink_well_example.dart',
      child: Scaffold(
        appBar: AppBar(
          title: Text("TeXViewInkWell: You tapped: $tappedId"),
        ),
        body: ListView(
          children: [
            TeXView(
                child: TeXViewColumn(children: [
                  TeXViewInkWell(
                      child: const TeXViewDocument(
                          r"""<h2>\( \rm\\TeXViewInkWell\) 1 with ripple</h2>"""),
                      style: _teXViewStyle,
                      id: "inkwell_1",
                      rippleEffect: true,
                      onTap: tapCallbackHandler),
                  TeXViewInkWell(
                      child: const TeXViewDocument(
                          r"""<h2>\( \rm\\TeXViewInkWell\) 2 without ripple</h2>"""),
                      style: _teXViewStyle,
                      id: "inkwell_2",
                      rippleEffect: false,
                      onTap: tapCallbackHandler),
                  TeXViewInkWell(
                      child: const TeXViewDocument(
                          r"""<h2>\( \rm\\TeXViewInkWell\) 3 with ripple</h2>"""),
                      style: _teXViewStyle,
                      id: "inkwell_3",
                      rippleEffect: true,
                      onTap: tapCallbackHandler),
                  TeXViewInkWell(
                      child: const TeXViewDocument(
                          r"""<h2>\( \rm\\TeXViewInkWell\) 4 without ripple</h2>"""),
                      style: _teXViewStyle,
                      id: "inkwell_4",
                      rippleEffect: false,
                      onTap: tapCallbackHandler),
                ]),
                style: const TeXViewStyle(
                  margin: TeXViewMargin.all(16),
                  padding: TeXViewPadding.all(16),
                  borderRadius: TeXViewBorderRadius.all(16),
                  overflow: TeXViewOverflow.visible,
                  elevation: 2,
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
                    )),
          ],
        ),
      ),
    );
  }

  void tapCallbackHandler(String id) {
    setState(() {
      tappedId = id;
    });
  }
}
