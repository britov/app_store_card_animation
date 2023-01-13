import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/animation.dart';

class CardHeroTween extends Tween<Rect?> {
  CardHeroTween({super.begin, super.end});

  /// How changed size of card
  late final sizeTween = CurveTween(curve: Curves.linear);

  /// Originally, card resizing ends before the card finishes moving.
  /// [_sizeGrowPeriod] sets a time period for resizing while the card is moving
  final _sizeGrowPeriod = 0.4;

  /// How is moving top of the card.
  late final verticalMovingTween =
  CurveTween(curve: const ElasticOutCurve(0.7));

  @override
  Rect? transform(double t) {
    final sizeValue = sizeTween.transform(math.min(1, t / _sizeGrowPeriod));
    final verticalMovingValue = verticalMovingTween.transform(t);

    final top = lerpDouble(
      begin?.top,
      end?.top,
      verticalMovingValue,
    );

    final sizeRect = Rect.lerp(begin, end, sizeValue);

    if (top == null || sizeRect == null) {
      return null;
    }

    return Rect.fromLTWH(sizeRect.left, top, sizeRect.width, sizeRect.height);
  }
}



class InternalTween extends Tween<double> {
  InternalTween({
    required this.width,
    bool reverse = false,
  })  : isGrow = !reverse,
        assert(width <= 1 && width >= 0),
        super(
        begin: 0,
        end: 1,
      );

  late final double width;

  bool isGrow;

  @override
  double lerp(double t) {
    if (t == 0) isGrow = true;
    if (t == 1) isGrow = false;

    if (isGrow) {
      if (t >= width) return end!;
      return t / width;
    } else {
      if (t <= (end! - width)) return begin!;
      return (t - (end! - width)) / width;
    }
  }
}
