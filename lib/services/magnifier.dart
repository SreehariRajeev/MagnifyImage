import 'dart:developer';
import 'dart:ui';

import 'package:camerazoomapp/services/magnifier_painter.dart';
import 'package:flutter/material.dart';

class Magnifier extends StatefulWidget {
  const Magnifier(
      {required this.child,
      this.position,
      this.visible = true,
      this.scale = 6, //Zoom Control
      this.size = const Size(160, 160)});

  final Widget child;
  final Offset? position;
  final bool visible;
  final double scale;
  final Size size;

  @override
  _MagnifierState createState() => _MagnifierState();
}

class _MagnifierState extends State<Magnifier> {
  Size? _magnifierSize;
  double? _scale;
  Matrix4? _matrix;

  @override
  void initState() {
    _calculateMatrix();

    super.initState();
  }

  @override
  void didUpdateWidget(Magnifier oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateMatrix();
  }

  @override
  Widget build(BuildContext context) {
    _scale = widget.scale;
    _magnifierSize = widget.size;

    return Stack(
      children: [
        widget.child,
        if (widget.visible && widget.position != null) _getMagnifier(context)
      ],
    );
  }

  void _calculateMatrix() {
    log(widget.position.toString());
    if (widget.position == null) {
      return;
    }

    setState(() {
      double newX = widget.position!.dx;
      double newY = widget.position!.dy;

      if (_bubbleCrossesMagnifier()) {
        final box = context.findRenderObject() as RenderBox;
        newX -= ((box.size.width - _magnifierSize!.width) / _scale!);
      }

      final Matrix4 updatedMatrix = Matrix4.identity()
        ..scale(_scale, _scale)
        ..translate(-newX, -newY);

      _matrix = updatedMatrix;
    });
  }

  Widget _getMagnifier(BuildContext context) {
    return Align(
      alignment: _getAlignment(),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.matrix(_matrix!.storage),
          child: CustomPaint(
            painter: MagnifierPainter(color: Theme.of(context).accentColor),
            size: _magnifierSize!,
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    if (_bubbleCrossesMagnifier()) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  bool _bubbleCrossesMagnifier() =>
      widget.position!.dx < widget.size.width &&
      widget.position!.dy < widget.size.height;
}
