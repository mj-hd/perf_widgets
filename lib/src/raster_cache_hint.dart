import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// set `isComplex`, `willChange` hints to current DisplayList
class RasterCacheHint extends SingleChildRenderObjectWidget {
  const RasterCacheHint({
    Key? key,
    this.isComplex,
    this.willChange,
  }) : super(key: key);

  final bool? isComplex;
  final bool? willChange;

  @override
  void updateRenderObject(
    BuildContext context,
    _RasterCacheHintRenderObject renderObject,
  ) {
    renderObject.isComplex = isComplex ?? false;
    renderObject.willChange = willChange ?? false;
  }

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RasterCacheHintRenderObject(isComplex, willChange);
}

class _RasterCacheHintRenderObject extends RenderProxyBox {
  _RasterCacheHintRenderObject(bool? _isComplex, bool? _willChange)
      : isComplex = _isComplex ?? false,
        willChange = _willChange ?? false;

  bool isComplex;
  bool willChange;

  @override
  void paint(PaintingContext context, Offset offset) {
    // we need this line to generate a PictureLayer to set the hints
    context.canvas;

    if (isComplex) {
      context.setIsComplexHint();
    }

    if (willChange) {
      context.setWillChangeHint();
    }

    super.paint(context, offset);
  }
}
