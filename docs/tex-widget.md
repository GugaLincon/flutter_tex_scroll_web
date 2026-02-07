# TeXWidget

`TeXWidget` is a convenient, high-level wrapper around [Math2SVG](math-2-svg.md) designed specifically for easy LaTeX rendering. It automatically handles text and math mixtures, making it ideal for displaying paragraphs containing equations.

## Usage

### Simple Example
Render a sentence with mixed text and math effortlessly.

```dart
TeXWidget(
    math: r"When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) "
          r"and they are $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$"
)
```

### Formatting Options
You can customize how text, inline math, and display math are rendered individually.

??? quote "View Advanced Implementation"
    ```dart
    TeXWidget(
      math: _formula,
      // Customize the main display equations (centered, large)
      displayFormulaWidgetBuilder: (context, displayFormula) {
        return Center(
          child: Math2SVG(
            math: displayFormula,
            formulaWidgetBuilder: (context, svg) => SvgPicture.string(
              svg,
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
              height: 50,
            ),
          ),
        );
      },
      // Customize inline math (embedded in text)
      inlineFormulaWidgetBuilder: (context, inlineFormula) {
        return Math2SVG(
          math: inlineFormula,
          formulaWidgetBuilder: (context, svg) => SvgPicture.string(
            svg,
            colorFilter: const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
            height: 16,
          ),
        );
      },
      // Customize standard text
      textWidgetBuilder: (context, text) {
        return TextSpan(text: text, style: TextStyle(color: Colors.black));
      },
    )
    ```

## API Reference
- **`math`**: The string input containing LaTeX.
- **`style`**: General style for the widget.
- **`loadingWidgetBuilder`**: Widget to show while parsing.
- **`onFinished`**: Callback when rendering completes.
