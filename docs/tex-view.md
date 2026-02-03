This is an advanced widget, based on [webview_flutter_plus](https://pub.dartlang.org/packages/webview_flutter_plus), engineered for a rich user experience. It excels at rendering complex mathematical equations and offers a flexible environment for dynamic content through its support for:

- **Inline HTML:** Directly embed and render HTML content.
- **JavaScript:** Execute custom scripts for interactive elements.
- **Markdown:** Display text with Markdown formatting.

> [!CAUTION]
Avoid using multiple `TeXView` instances on a single page, It's based on a `webview` and it can lead to performance issues. Instead, use `TeXWidget` or `Math2SVG` for multiple TeX elements.


```dart
TeXView(
    child: TeXViewColumn(children: [
      TeXViewInkWell(
        id: "id_0",
        child: TeXViewColumn(children: [
          TeXViewDocument(r"""<h2>Flutter \( \rm\\TeX \)</h2>""",
              style: TeXViewStyle(textAlign: TeXViewTextAlign.center)),
          TeXViewContainer(
            child: TeXViewImage.network(
                'https://raw.githubusercontent.com/Shahxad-Akram/flutter_tex/main/example/assets/flutter_tex_banner.png'),
            style: TeXViewStyle(
              margin: TeXViewMargin.all(10),
              borderRadius: TeXViewBorderRadius.all(20),
            ),
          ),
          TeXViewDocument(r"""<p>                                
                       When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are
                       $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$</p>""",
              style: TeXViewStyle.fromCSS(
                  'padding: 15px; color: white; background: green'))
        ]),
      )
    ]),
    style: TeXViewStyle(
      elevation: 10,
      borderRadius: TeXViewBorderRadius.all(25),
      border: TeXViewBorder.all(TeXViewBorderDecoration(
          borderColor: Colors.blue,
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 5)),
      backgroundColor: Colors.white,
    ),
   );
```


## API Usage

- `children` A list of `TeXViewWidget`
- `heightOffset` Height offset to be added to the rendered height.

- **`TeXViewWidget`s**
    - `TeXViewDocument` Holds TeX data by using a raw string e.g. `r"""$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$<br> """` You can also put HTML and Javascript code in it.
    - `TeXViewMarkdown` Holds markdown data.
    - `TeXViewContainer` Holds a single `TeXViewWidget` with styling.
    - `TeXViewImage` renders image from assets or network.
    - `TeXViewColumn` holds a list of `TeXViewWidget` vertically.
    - `TeXViewInkWell` for listening tap events..
    - `TeXViewDetails` like html `<details>`.


- `TeXViewStyle()` You can style each and everything using `TeXViewStyle()` or by using custom `CSS` code by `TeXViewStyle.fromCSS()` where you can pass hard coded String containing CSS code. For more information please check the example.
    

- `loadingWidgetBuilder` Shows a loading widget before rendering completes.

- `onRenderFinished` Callback with the rendered page height, when TEX rendering finishes.