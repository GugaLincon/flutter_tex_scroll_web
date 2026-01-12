import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:web/web.dart';
import 'package:flutter_tex/src/tex_server/tex_rendering_server_web.dart';
import 'package:flutter_tex/src/tex_view/tex_view.dart';
import 'package:flutter_tex/src/tex_view/utils/core_utils.dart';

class TeXViewState extends State<TeXView>
    with AutomaticKeepAliveClientMixin<TeXView> {
  final String _iframeId = UniqueKey().toString();
  final HTMLIFrameElement iframeElement = HTMLIFrameElement()
    ..src = "assets/packages/flutter_tex/core/flutter_tex.html"
    ..style.height = '100%'
    ..style.width = '100%'
    ..style.border = '0';
  final StreamController<double> heightStreamController = StreamController();
  late final Window _iframeContentWindow;

  String _oldRawData = '';
  bool _isReady = false;

  @override
  void initState() {
    TeXRenderingControllerWeb.registerInstance(_iframeId, this);

    iframeElement.onLoad.listen((_) {
      _iframeContentWindow = iframeElement.contentWindow!;
      _isReady = true;
      _renderTeXView();
    });

    platformViewRegistry.registerViewFactory(
        _iframeId, (int id) => iframeElement..id = _iframeId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _renderTeXView();
    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
          return SizedBox(
            height: snap.hasData ? snap.data! : initialHeight,
            child: HtmlElementView(
              key: widget.key ?? ValueKey(_iframeId),
              viewType: _iframeId,
            ),
          );
        });
  }

  void onTap(JSString tapId) => widget.child.onTapCallback(tapId.toString());

  void onWheel(JSNumber deltaY) {
    if (widget.scrollController?.position.isScrollingNotifier.value == false) {
      final delta = double.parse(deltaY.toString());
      final scaleFactor = 1.0;
      final adjustedDelta = delta * scaleFactor;
      if (delta.abs() < 10) {
        widget.scrollController?.position.jumpTo(
            widget.scrollController!.position.pixels + adjustedDelta);
      } else {
        final duration = Duration(
            milliseconds: (20 + delta.abs() * 0.5).clamp(20, 150).toInt());

        widget.scrollController?.position.animateTo(
          widget.scrollController!.position.pixels + adjustedDelta,
          duration: duration,
          curve: Curves.linear,
        );
      }
    }
  }

  void onTeXViewRendered(JSNumber h) {
    double height = double.parse(h.toString()) + widget.heightOffset;

    if (mounted) {
      heightStreamController.add(height);
      widget.onRenderFinished?.call(height);
    }
  }

  void _renderTeXView() {
    if (!_isReady) {
      return;
    }
    var currentRawData = getRawData(widget);
    if (currentRawData != _oldRawData) {
      initTeXViewWeb(_iframeContentWindow, _iframeId, currentRawData);
      _oldRawData = currentRawData;
    }
  }

  @override
  void dispose() {
    if (mounted) {
      heightStreamController.close();
    }
    TeXRenderingControllerWeb.unregisterInstance(_iframeId);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
