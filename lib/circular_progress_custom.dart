import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressCustom extends StatefulWidget {
  const CircularProgressCustom({Key? key}) : super(key: key);

  @override
  State<CircularProgressCustom> createState() => _CircularProgressCustomState();
}

class _CircularProgressCustomState extends State<CircularProgressCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _startAngleAnimation, _sweepAngleAnimation, _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));

    _startAngleAnimation = TweenSequence(
      [
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 1.3),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.75), weight: 0.3),
        TweenSequenceItem(tween: Tween(begin: 0.75, end: 1.0), weight: 0.1),
      ],
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _sweepAngleAnimation = TweenSequence(
      [
        TweenSequenceItem(tween: Tween(begin: 0.05, end: 0.8), weight: 0.3),
        TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.8), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.05), weight: 0.3),
        TweenSequenceItem(tween: Tween(begin: 0.05, end: 0.05), weight: 0.1),
      ],
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _rotateAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Transform.rotate(
            angle: 2 * pi * _rotateAnimation.value,
            child: CustomPaint(
              painter: CircularPainter(
                startAngle: _startAngleAnimation.value,
                sweepAngle: _sweepAngleAnimation.value,
              ),
            ),
          );
        });
  }
}

class CircularPainter extends CustomPainter {
  CircularPainter({required this.startAngle, required this.sweepAngle});

  double startAngle;
  double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    var paintProgress = Paint()
      ..color = Colors.red
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(Rect.fromCenter(center: center, width: 55.0, height: 55.0),
        2 * pi * startAngle, 2 * pi * sweepAngle, false, paintProgress);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
