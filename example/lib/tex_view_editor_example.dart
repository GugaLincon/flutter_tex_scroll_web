import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/source_code_view.dart';

class TeXViewEditorExample extends StatelessWidget {
  const TeXViewEditorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleWrapper(
      filePath: 'lib/tex_view_editor_example.dart',
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("TeX View Editor Example"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Formula Editor"),
                Tab(text: "Document Editor"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FormulaEditor(),
              DocumentEditor(),
            ],
          ),
        ),
      ),
    );
  }
}

class FormulaEditor extends StatelessWidget {
  const FormulaEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Material(
            color: Colors.white,
            child: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "TeX"),
                Tab(text: "MathML"),
                Tab(text: "AsciiMath"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SpecificFormulaEditor(
                  inputType: MathInputType.teX,
                  examples: const {
                    "Quadratic Formula":
                        r"x = {-b \pm \sqrt{b^2-4ac} \over 2a}",
                    "Gaussian Integral":
                        r"\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}",
                    "Matrix": r"\begin{bmatrix} a & b \\ c & d \end{bmatrix}",
                  },
                ),
                SpecificFormulaEditor(
                  inputType: MathInputType.mathML,
                  examples: const {
                    "Fraction":
                        r"<math><mfrac><mn>1</mn><mn>2</mn></mfrac></math>",
                    "Quadratic Equation": r"""
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
                  },
                ),
                SpecificFormulaEditor(
                  inputType: MathInputType.asciiMath,
                  examples: const {
                    "Quadratic Formula": r"x = (-b +- sqrt(b^2 - 4ac))/(2a)",
                    "Summation": r"sum_(i=1)^n i^3=((n(n+1))/2)^2",
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpecificFormulaEditor extends StatefulWidget {
  final MathInputType inputType;
  final Map<String, String> examples;

  const SpecificFormulaEditor({
    super.key,
    required this.inputType,
    required this.examples,
  });

  @override
  State<SpecificFormulaEditor> createState() => _SpecificFormulaEditorState();
}

class _SpecificFormulaEditorState extends State<SpecificFormulaEditor> {
  final TextEditingController _controller = TextEditingController();
  late String _selectedExample;

  @override
  void initState() {
    super.initState();
    _selectedExample = widget.examples.keys.first;
    _controller.text = widget.examples.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedExample,
                decoration: const InputDecoration(
                  labelText: 'Select Example',
                  border: OutlineInputBorder(),
                ),
                items: widget.examples.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedExample = newValue;
                      _controller.text = widget.examples[newValue]!;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Edit ${widget.inputType.name} Code',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Container(
            color: Colors.grey[50], // Light background
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Math2SVG(
              math: _controller.text,
              teXInputType: widget.inputType,
              errorWidgetBuilder: (context, error) => Center(
                child: Card(
                  elevation: 2,
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Invalid Formula",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              formulaWidgetBuilder: (context, svg) => Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SvgPicture.string(
                    svg,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DocumentEditor extends StatefulWidget {
  const DocumentEditor({super.key});

  @override
  State<DocumentEditor> createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text =
        r"""Flutter $ \rm\TeX $ is a Flutter Package to render so many types of equations based on \( \rm\LaTeX \), It also includes full HTML with JavaScript support. Here's a simple example of $ \rm\TeX $ rendering:
          
      When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$ Another display formula is: \[ E = mc^2 + \frac{p^2}{2m} + \sum_{i} \frac{(p_i - qA_i)^2}{2m_i} + V(r) + ... \]""";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter Document Content',
              border: OutlineInputBorder(),
              hintText: 'Type your TeX content here...',
            ),
            maxLines: 6,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Container(
            color: Colors.grey[50],
            child: TeXWidget(
              content: _controller.text,
              // loadingWidgetBuilder: (context) =>
              //     const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }
}
