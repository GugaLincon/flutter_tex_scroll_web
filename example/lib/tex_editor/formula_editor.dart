import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' show Mode;
import 'package:highlight/languages/tex.dart';
import 'package:highlight/languages/xml.dart';
import 'package:highlight/languages/python.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/maths_examples.dart';
import 'package:flutter_tex_example/tex_editor/code_editor_widget.dart';

class FormulaEditor extends StatelessWidget {
  const FormulaEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF282C34),
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                  label: "LaTeX",
                  examples: laTeXExamples,
                  language: tex,
                ),
                SpecificFormulaEditor(
                  inputType: MathInputType.mathML,
                  label: "MathML",
                  examples: mathMLExamples,
                  language: xml,
                ),
                SpecificFormulaEditor(
                  inputType: MathInputType.asciiMath,
                  label: "AsciiMath",
                  examples: asciiMathExamples,
                  language: python,
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
  final String label;
  final Mode? language;

  const SpecificFormulaEditor({
    super.key,
    required this.inputType,
    required this.examples,
    required this.label,
    this.language,
  });

  @override
  State<SpecificFormulaEditor> createState() => _SpecificFormulaEditorState();
}

class _SpecificFormulaEditorState extends State<SpecificFormulaEditor>
    with AutomaticKeepAliveClientMixin {
  late CodeController _controller;
  late String _selectedExample;

  String _previewText = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedExample = widget.examples.keys.first;
    _controller = CodeController(
      text: widget.examples.values.first,
      language: widget.language,
    );
    _previewText = _controller.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadExample(String? key) {
    if (key == null) return;
    setState(() {
      _selectedExample = key;
      _controller.text = widget.examples[key]!;
      _previewText = widget.examples[key]!;
    });
  }

  void _onTextChanged(String text) {
    if (mounted && _previewText != text) {
      setState(() {
        _previewText = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Math2SVG(
                          math: _previewText,
                          teXInputType: widget.inputType,
                          errorWidgetBuilder: (context, error) =>
                              _buildErrorWidget(error),
                          formulaWidgetBuilder: (context, svg) => Center(
                            child: SvgPicture.string(
                              svg,
                              width: constraints.maxWidth - 32,
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    const Text("Load Example:",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedExample,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.blue),
                            items: widget.examples.keys.map((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(key),
                              );
                            }).toList(),
                            onChanged: _loadExample,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: CodeEditorWidget(
                  controller: _controller,
                  label: widget.label,
                  onChanged: _onTextChanged, // Use the debounced function
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withAlpha(30)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Syntax Error: $error",
              style: TextStyle(color: Colors.red[900]),
            ),
          ),
        ],
      ),
    );
  }
}
