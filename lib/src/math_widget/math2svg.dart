import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class Math2SVG extends StatefulWidget {
  final String math;
  final MathInputType teXInputType;
  final WidgetBuilder? loadingWidgetBuilder;
  final Widget Function(BuildContext context, String svg)? formulaWidgetBuilder;
  final Widget Function(BuildContext context, Object? error)?
      errorWidgetBuilder;
  final bool wantKeepAlive;

  const Math2SVG({
    super.key,
    required this.math,
    this.wantKeepAlive = false,
    this.teXInputType = MathInputType.teX,
    this.loadingWidgetBuilder,
    this.formulaWidgetBuilder,
    this.errorWidgetBuilder,
  });

  @override
  State<Math2SVG> createState() => _Math2SVGState();
}

class _Math2SVGState extends State<Math2SVG>
    with AutomaticKeepAliveClientMixin<Math2SVG> {
  String? _svgData;
  Object? _error;
  bool _isRendering = false;

  @override
  void initState() {
    super.initState();
    _svgData =
        TeXRenderingServer.getCachedSVG(widget.math, widget.teXInputType);
    if (_svgData == null) {
      _resolveMath();
    }
  }

  @override
  void didUpdateWidget(Math2SVG oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.math != oldWidget.math ||
        widget.teXInputType != oldWidget.teXInputType) {
      final cached =
          TeXRenderingServer.getCachedSVG(widget.math, widget.teXInputType);
      if (cached != null) {
        setState(() {
          _svgData = cached;
          _isRendering = false;
        });
      } else {
        _resolveMath();
      }
    }
  }

  Future<void> _resolveMath() async {
    if (!mounted) return;

    setState(() {
      _isRendering = true;
      _error = null;
    });

    try {
      final result = await TeXRenderingServer.math2SVG(
        math: widget.math,
        mathInputType: widget.teXInputType,
      );

      if (mounted) {
        setState(() {
          _svgData = result;
          _isRendering = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _isRendering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for KeepAlive

    // 3. PERFORMANCE: Priority logic for the UI tree
    if (_error != null && _svgData == null) {
      return widget.errorWidgetBuilder?.call(context, _error) ??
          _buildDefaultError();
    }

    if (_svgData != null) {
      // We wrap the SVG in a RepaintBoundary here to cache the rasterized pixels on the GPU
      return RepaintBoundary(
        child: Opacity(
          opacity: _isRendering
              ? 0.6
              : 1.0, // Subtly indicate "updating" without a jarring spinner
          child: widget.formulaWidgetBuilder?.call(context, _svgData!) ??
              SvgPicture.string(
                _svgData!,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                // Use the raw text as a placeholder during the very first parse of the SVG string
                placeholderBuilder: (_) => Text(widget.math),
              ),
        ),
      );
    }

    // Initial loading state
    return widget.loadingWidgetBuilder?.call(context) ??
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.math, style: const TextStyle(color: Colors.grey)),
        ));
  }

  Widget _buildDefaultError() {
    return Text('Error: $_error',
        style: const TextStyle(color: Colors.red, fontSize: 12));
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
