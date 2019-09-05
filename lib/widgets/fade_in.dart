import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn({
    this.delay,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track('opacity')
        .add(Duration(milliseconds: 500), Tween(begin: 0, end: 1)),
      Track('translateX')
          .add(Duration(milliseconds: 500), Tween(begin: 130, end: 0),
        curve: Curves.easeOut),
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) {
        print('ANIMATION -> $animation');
        return Opacity(
          opacity: double.parse(animation['opacity'].toString()),
          child: Transform.translate(
            offset: Offset(double.parse(animation['translateX'].toString()), 0),
            child: child,
          ),
        );
      }
    );
  }
}
