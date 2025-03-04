// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/utils/core_utils.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui;

class TeXViewState extends State<TeXView> {
  String? _lastData;
  double widgetHeight = initialHeight;
  final String _viewId = UniqueKey().toString();

  final TeXViewRenderingEngine renderingEngine =
      TeXRederingServer.renderingEngine;

  @override
  Widget build(BuildContext context) {
    _initTeXView();
    return SizedBox(
      height: widgetHeight,
      child: HtmlElementView(
        key: widget.key ?? ValueKey(_viewId),
        viewType: _viewId,
      ),
    );
  }

  @override
  void initState() {
    _initWebview();
    super.initState();
  }

  void _initWebview() {
    ui.platformViewRegistry.registerViewFactory(
        _viewId,
        (int id) => html.IFrameElement()
          ..src =
              "assets/packages/flutter_tex/js/${renderingEngine.name}/index.html"
          ..id = _viewId
          ..style.height = '100%'
          ..style.overflow = 'hidden'
          ..style.width = '100%'
          ..style.border = '0');

    js.context['TeXViewRenderedCallback'] = (message) {
      double viewHeight = double.parse(message.toString());
      if (viewHeight != widgetHeight) {
        setState(() {
          widgetHeight = viewHeight;
        });
      }
    };

    js.context['OnTapCallback'] = (id) {
      widget.child.onTapCallback(id);
    };

    js.context['OnWheelCallback'] = (deltaY) {
      // first make sure no other scroll is happening
      if (widget.scrollController?.position.isScrollingNotifier.value ==
          false) {
        widget.scrollController?.position.animateTo(
          widget.scrollController!.position.pixels + deltaY * 2,
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeInOut,
        );
      }
    };
  }

  void _initTeXView() {
    var rawData = getRawData(widget);

    if (rawData != _lastData) {
      js.context.callMethod(
          'initWebTeXView', [_viewId, rawData, renderingEngine.name]);
      _lastData = rawData;
    }
  }
}
