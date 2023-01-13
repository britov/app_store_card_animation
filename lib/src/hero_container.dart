import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_store_card_animation.dart';
import 'scroll_builder.dart';
import 'tween.dart';

enum HeroContentState { card, flight, fullscreen }

class HeroContent extends AnimatedWidget {
  const HeroContent(
      this.mainCardBuilder,
      this.contentCardBuilder,
      this.state, {
        Key? key,
        required this.animation,
        required this.scrollController,
        required this.backgroundColor,
        this.cardHeight = 400,
        this.flightDirection = HeroFlightDirection.push,
        // this.dividerColor,
      }) : super(key: key, listenable: animation);

  final MainCardBuilder mainCardBuilder;
  final ContentCardBuilder contentCardBuilder;
  final HeroContentState state;
  final Color backgroundColor;

  final HeroFlightDirection flightDirection;
  final Animation<double> animation;

  // final Color? dividerColor;
  final double cardHeight;
  static const _cardHeightExtend = 40.0;
  static const _closeButtonPadding = EdgeInsets.only(top: 32, right: 16);

  final ScrollController scrollController;

  ScrollPhysics? get scrollPhysics => state != HeroContentState.fullscreen
      ? const NeverScrollableScrollPhysics()
      : null;

  final _sizeEnd = 0.4;

  @override
  Widget build(BuildContext context) {
    final sizeAnimationValue = flightDirection == HeroFlightDirection.push
        ? math.min(1.0, animation.value / _sizeEnd)
        : (1.0 - math.min(1.0, (1.0 - animation.value) / _sizeEnd));

    var cardHeightExtendValue = _cardHeightExtend * sizeAnimationValue;
    final totalCardHeight = cardHeight + cardHeightExtendValue;
    final h = (MediaQuery.of(context).size.height - totalCardHeight) *
        sizeAnimationValue +
        totalCardHeight;

    // log('$flightDirection ${animation.value} sizeAnimationValue $sizeAnimationValue h $h');

    // final topPadding = _paddingValue +
    //     MediaQuery.of(context).viewPadding.top * animation.value;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: h,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
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
                      top: top,
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
                      scrollPhysics, totalCardHeight),
                  // child: ListView(
                  //   controller: scrollController,
                  //   physics: scrollPhysics,
                  //   padding: EdgeInsets.zero,
                  //   children: [
                  //     SizedBox(
                  //       height: totalCardHeight,
                  //     ),
                  //     for (int i = 0; i < 20; i++)
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: _paddingValue),
                  //         child: TemplateCard(
                  //           index: i,
                  //           detailCard: true,
                  //         ),
                  //       ),
                  //   ],
                  // ),
                ),
              ),
              Positioned(
                top: _closeButtonPadding.top,
                right: _closeButtonPadding.right,
                child: FadeTransition(
                  opacity: animation,
                  child: IconButton(
                    onPressed: () {
                      if (animation.value == 1) {
                        Navigator.pop(context);
                      }
                    },
                    icon: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        CupertinoIcons.multiply,
                        size: 25,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}