import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/source_code_view.dart';

/// A widget that demonstrates how to display images and videos within a [TeXView].
///
/// This example includes loading images from assets and the network, as well as
/// embedding videos using [TeXViewVideo] (though the video part is currently commented out).
class TeXViewImageVideoExample extends StatelessWidget {
  const TeXViewImageVideoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleWrapper(
      filePath: 'lib/tex_view_image_video_example.dart',
      child: Scaffold(
          appBar: AppBar(
            title: const Text("TeXView Image & Video"),
          ),
          body: TeXView(
            child: const TeXViewColumn(children: [
              TeXViewDocument(
                  r"""<h2>Flutter \( \rm\\TeX \) Image Example</h2>""",
                  style: TeXViewStyle(textAlign: TeXViewTextAlign.center)),
              TeXViewDocument('Image Loaded From Assets'),
              TeXViewContainer(
                child: TeXViewImage.asset('assets/flutter_tex_banner.png'),
                style: TeXViewStyle(
                  margin: TeXViewMargin.all(10),
                  borderRadius: TeXViewBorderRadius.all(20),
                ),
              ),
              // TeXViewDocument('Video loaded form Youtube link'),
              // TeXViewVideo.youtube(
              //     "https://www.youtube.com/watch?v=YiNbVEXV_NM&lc=Ugyg4ljzrK0D6YfrO854AaABAg"),
              TeXViewDocument(
                  'Image Loaded From Network, this may take some time according to your network speed'),
              TeXViewContainer(
                child: TeXViewImage.network(
                    'https://raw.githubusercontent.com/Shahxad-Akram/flutter_tex/main/example/assets/flutter_tex_banner.png'),
                style: TeXViewStyle(
                  margin: TeXViewMargin.all(10),
                  borderRadius: TeXViewBorderRadius.all(20),
                ),
              ),
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(16),
              padding: TeXViewPadding.all(16),
              borderRadius: TeXViewBorderRadius.all(16),
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
            ),
          )),
    );
  }
}
