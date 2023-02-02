import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'decoration.dart';
import 'scroll_builder.dart';
import 'tween.dart';
import 'types_def.dart';

/// States of card
enum HeroContentState { card, flight, fullscreen }

class HeroContent extends AnimatedWidget {
  const HeroContent(
    this.mainCardBuilder,
    this.contentCardBuilder,
    this.closeButtonBuilder, {
    Key? key,
    required this.state,
    required this.animation,
    required this.scrollController,
    required this.decoration,
    this.flightDirection = HeroFlightDirection.push,
  }) : super(key: key, listenable: animation);

  final MainCardBuilder mainCardBuilder;
  final ContentCardBuilder contentCardBuilder;
  final CloseButtonBuilder closeButtonBuilder;
  final HeroContentState state;
  final AppStoreCardDecoration decoration;

  final HeroFlightDirection flightDirection;
  final Animation<double> animation;

  static const _defaultCardHeight = 400;
  static const _cardHeightExtend = 40.0;
  static const _sizeAnimationDuration = 0.4;
  static const _closeButtonPadding = EdgeInsets.only(top: 32, right: 16);

  final ScrollController scrollController;

  ScrollPhysics? get scrollPhysics => state != HeroContentState.fullscreen
      ? const NeverScrollableScrollPhysics()
      : null;

  @override
  Widget build(BuildContext context) {
    final sizeAnimationValue = flightDirection == HeroFlightDirection.push
        ? math.min(1.0, animation.value / _sizeAnimationDuration)
        : (1.0 -
            math.min(1.0, (1.0 - animation.value) / _sizeAnimationDuration));

    var cardHeightExtendValue = _cardHeightExtend * sizeAnimationValue;
    var topPadding =
        (decoration.fullscreenTopPadding ?? 0) * sizeAnimationValue;
    final totalCardHeight =
        (decoration.cardHeight ?? _defaultCardHeight) + cardHeightExtendValue;
    final h = (MediaQuery.of(context).size.height - totalCardHeight) *
            sizeAnimationValue +
        totalCardHeight;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: h,
        child: Container(
          decoration: BoxDecoration(
            color: decoration.backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Stack(
            children: [
              ScrollBuilder(
                  scrollController: scrollController,
                  builder: (context, offset) {
                    double top =
                        0.0 - (math.min(totalCardHeight, offset ?? 0.0));
                    if (top != 0.0 &&
                        animation.status == AnimationStatus.reverse) {
                      top = lerpDouble(0, top, sizeAnimationValue)!;
                    }

                    return Positioned(
                      top: top + topPadding,
                      left: 0,
                      right: 0,
                      height: totalCardHeight,
                      child: mainCardBuilder(
                          context, sizeAnimationValue, totalCardHeight),
                    );
                  }),
              Positioned.fill(
                child: FadeTransition(
                  opacity: animation.drive(InternalTween(
                    width: 0.4,
                    reverse: flightDirection == HeroFlightDirection.pop,
                  )),
                  child: contentCardBuilder(context, scrollController,
                      scrollPhysics, totalCardHeight + topPadding),
                ),
              ),
              Positioned(
                top: _closeButtonPadding.top,
                right: _closeButtonPadding.right,
                child: closeButtonBuilder(context, animation),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
