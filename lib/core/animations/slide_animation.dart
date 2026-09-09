import 'package:flutter/material.dart';

enum SlideDirection { fromLeft, fromRight, fromTop, fromBottom }

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.easeOut,
    this.direction = SlideDirection.fromBottom,
    this.distance = 100,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final SlideDirection direction;
  final double distance;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    Offset startOffset = _getStartOfset();
    _animation = Tween<Offset>(
      begin: startOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay.inMilliseconds > 0) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
    super.initState();
  }

  Offset _getStartOfset() {
    switch (widget.direction) {
      case SlideDirection.fromLeft:
        return Offset(-widget.distance / 100, 0);
      case SlideDirection.fromRight:
        return Offset(widget.distance / 100, 0);
      case SlideDirection.fromTop:
        return Offset(0, -widget.distance / 100);
      case SlideDirection.fromBottom:
        return Offset(0, widget.distance / 100);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
