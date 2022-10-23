import 'package:flutter/material.dart';

class CircleAnimation extends StatefulWidget {
  const CircleAnimation({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  CircleAnimationState createState() => CircleAnimationState();
}

class CircleAnimationState extends State<CircleAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _controller.forward();
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
    child: widget.child,
    );
  }
}
