import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

/// A reusable widget providing a code editing interface with syntax highlighting.
///
/// Wraps [CodeField] and adds utility buttons like Copy and Clear.
class CodeEditorWidget extends StatelessWidget {
  /// The controller for the code field.
  final CodeController controller;

  /// The label displayed above the editor.
  final String label;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether the editor should expand to fill available height.
  final bool isFullHeight;

  /// Whether the editor is editable.
  final bool enabled;

  const CodeEditorWidget({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.isFullHeight = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF282C34),
      padding: const EdgeInsets.only(bottom: 8),
      height: isFullHeight ? null : 250,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF21252B),
            child: Row(
              children: [
                Icon(Icons.code, color: Colors.blue[300], size: 16),
                const SizedBox(width: 8),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                EditorActionButton(
                  icon: Icons.copy,
                  tooltip: "Copy",
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: controller.text)),
                ),
                const SizedBox(width: 8),
                EditorActionButton(
                  icon: Icons.cleaning_services_rounded,
                  tooltip: "Clear",
                  onTap: () {
                    controller.clear();
                    if (onChanged != null) onChanged!("");
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: CodeTheme(
              data: CodeThemeData(styles: atomOneDarkTheme),
              child: SingleChildScrollView(
                child: CodeField(
                  wrap: true,
                  controller: controller,
                  enabled: enabled,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                  onChanged: onChanged,
                  lineNumberStyle: const LineNumberStyle(
                    textStyle: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                    margin: 16.0,
                    width: 45.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditorActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const EditorActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, color: Colors.grey[500], size: 16),
        ),
      ),
    );
  }
}
