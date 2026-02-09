import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/tex.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/tex_editor/code_editor_widget.dart';
import 'package:flutter_tex_example/maths_examples.dart';

/// A widget for editing and previewing full documents containing mixed HTML and TeX.
///
/// This editor allows users to write raw content and see a live preview rendered by [TeXWidget].
class DocumentEditor extends StatefulWidget {
  const DocumentEditor({super.key});

  @override
  State<DocumentEditor> createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor>
    with AutomaticKeepAliveClientMixin {
  late CodeController _controller;
  String _previewContent = "";

  @override
  bool get wantKeepAlive => true; // Keeps tab state alive

  @override
  void initState() {
    super.initState();
    _controller = CodeController(
      text: teXWidgetContent,
      language: tex,
    );
    _previewContent = teXWidgetContent;
  }

  void _onTextChanged(String text) {
    if (mounted) setState(() => _previewContent = text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: TeXWidget(
                  content: _previewContent,
                ),
              )),
        ),
        const Divider(height: 1),
        Expanded(
          flex: 5,
          child: CodeEditorWidget(
            controller: _controller,
            label: "HTML / TeX Document",
            onChanged: _onTextChanged,
            isFullHeight: true,
          ),
        ),
      ],
    );
  }
}
