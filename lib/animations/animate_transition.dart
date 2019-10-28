import 'dart:async';

import 'package:flutter/material.dart';

enum AnimationType { FADE,SCALE }

class AnimateTransition extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final int durationInMilliseconds;
  final AnimationType animationType;
  final StreamController<bool> controller;

  AnimateTransition({
    @required this.firstChild,
    @required this.secondChild,
    @required this.controller,
    this.animationType = AnimationType.FADE,
    this.durationInMilliseconds = 500,
  });

  @override
  _AnimateTransition createState() {
   return _AnimateTransition();
  }
}

class _AnimateTransition extends State<AnimateTransition> {
  Widget _animate;

  @override
  void initState() {
    _animate = widget.firstChild;
    widget.controller.stream.listen(_handleListen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.durationInMilliseconds),
      child: _animate,
      transitionBuilder: (Widget _widget, Animation<double> animation) =>
        getTransition(_widget, animation),
    );
  }

  getTransition(final Widget _widget, final Animation<double> animation) {
    if (widget.animationType == AnimationType.FADE) {
      return FadeTransition(
        child: _widget,
        opacity: animation,
      );
    } else {
      return ScaleTransition(
        child: _widget,
        scale: animation,
      );
    }
  }

  void _handleListen(final bool value) {
    if (value == null) {
      return;
    }

    if (value) {
      _updateState(widget.secondChild);
    } else {
      _updateState(widget.firstChild);
    }
  }

  void _updateState(final Widget widget) => setState(() => _animate = widget);
}
