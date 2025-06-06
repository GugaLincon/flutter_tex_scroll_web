import 'dart:js_interop';
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/utils/core_utils.dart';
import 'package:web/web.dart';

@JS('TeXViewRenderedCallback')
external set teXViewRenderedCallback(JSFunction callback);

@JS('OnTapCallback')
external set onTapCallback(JSFunction callback);

@JS('initWebTeXView')
external void initWebTeXView(String viewId, String rawData);

@JS('OnWheelCallback')
external set onWheelCallback(JSFunction callback);

class TeXViewState extends State<TeXView> {
  final String _viewId = UniqueKey().toString();
  final HTMLIFrameElement iframeElement = HTMLIFrameElement()
    ..src = "assets/packages/flutter_tex/core/flutter_tex.html"
    ..style.height = '100%'
    ..style.width = '100%'
    ..style.border = '0';

  double _teXViewHeight = initialHeight;
  String _lastRawData = '';
  bool _isReady = false;

  @override
  Widget build(BuildContext context) {
    _renderTeXView();
    return SizedBox(
      height: _teXViewHeight,
      child: HtmlElementView(
        key: widget.key ?? ValueKey(_viewId),
        viewType: _viewId,
      ),
    );
  }

  @override
  void initState() {
    iframeElement.id = _viewId;

    platformViewRegistry.registerViewFactory(
        _viewId, (int id) => iframeElement);

    teXViewRenderedCallback = onTeXViewRendered.toJS;
    onTapCallback = onTap.toJS;
    onWheelCallback = onWheel.toJS;

    _isReady = true;
    _renderTeXView();

    super.initState();
  }

  void onTap(JSString id) {
    widget.child.onTapCallback(id.toString());
  }

  void onWheel(JSNumber deltaY) {
    if (widget.scrollController?.position.isScrollingNotifier.value == false) {
      final delta = double.parse(deltaY.toString());
      final scaleFactor = 1.0;
      final adjustedDelta = delta * scaleFactor;
      if (delta.abs() < 10) {
        widget.scrollController?.position.jumpTo(
          widget.scrollController!.position.pixels + adjustedDelta
        );
      } else {
        final duration = Duration(milliseconds: (20 + delta.abs() * 0.5).clamp(20, 150).toInt());
        
        widget.scrollController?.position.animateTo(
          widget.scrollController!.position.pixels + adjustedDelta,
          duration: duration,
          curve: Curves.linear,
        );
      }
    }
  }

  void onTeXViewRendered(JSNumber message) {
    double viewHeight = double.parse(message.toString());
    if (viewHeight != _teXViewHeight && mounted) {
      setState(() {
        _teXViewHeight = viewHeight;
      });
    }
  }

  void _renderTeXView() {
    if (!_isReady) {
      return;
    }
    var currentRawData = getRawData(widget);
    if (currentRawData != _lastRawData) {
      initWebTeXView(_viewId, currentRawData);
      _lastRawData = currentRawData;
    }
  }
}
