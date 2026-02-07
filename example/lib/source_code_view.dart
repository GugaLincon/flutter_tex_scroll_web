import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';

class SourceCodeView extends StatelessWidget {
  final String filePath;
  final Widget? child;

  const SourceCodeView({
    super.key,
    required this.filePath,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(filePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final code = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Source Code"),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 20),
              actions: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy Code',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Code copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
            body: SizedBox.expand(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: HighlightView(
                  code,
                  language: 'dart',
                  theme: atomOneLightTheme,
                  padding: const EdgeInsets.all(12),
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Source Code"),
            ),
            body: Center(child: Text('Error loading code: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Source Code"),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class ExampleWrapper extends StatefulWidget {
  final Widget child;
  final String filePath;

  const ExampleWrapper({
    super.key,
    required this.child,
    required this.filePath,
  });

  @override
  State<ExampleWrapper> createState() => _ExampleWrapperState();
}

class _ExampleWrapperState extends State<ExampleWrapper> {
  bool _showCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _showCode ? SourceCodeView(filePath: widget.filePath) : widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showCode = !_showCode;
          });
        },
        tooltip: _showCode ? "Show Preview" : "Show Code",
        child: Icon(_showCode ? Icons.code_off : Icons.code),
      ),
    );
  }
}
