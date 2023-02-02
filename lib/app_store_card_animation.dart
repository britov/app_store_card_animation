library app_store_card_animation;

import 'package:flutter/material.dart';

import 'app_store_card_animation.dart';
import 'src/fullscreen_page.dart';
import 'src/hero_container.dart';
import 'src/tween.dart';
import 'src/types_def.dart';

export 'src/decoration.dart';

class AppStoreCard extends StatelessWidget {
  final _heroTag = UniqueKey();
  final _scrollController = ScrollController();

  final MainCardBuilder mainCardBuilder;
  final ContentCardBuilder contentCardBuilder;
  final CloseButtonBuilder closeButtonBuilder;
  final AppStoreCardDecoration decoration;

  AppStoreCard({
    Key? key,
    required this.mainCardBuilder,
    required this.contentCardBuilder,
    required this.closeButtonBuilder,
    this.decoration = const AppStoreCardDecoration(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      onTap: () {
        _scrollController.jumpTo(0);
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, _, __) => FullscreenPage(
              heroTag: _heroTag,
              heroContent: HeroContent(
                mainCardBuilder,
                contentCardBuilder,
                closeButtonBuilder,
                state: HeroContentState.fullscreen,
                decoration: decoration,
                scrollController: _scrollController,
                animation: const AlwaysStoppedAnimation(1),
              ),
            ),
            transitionDuration: const Duration(milliseconds: 1200),
            reverseTransitionDuration: const Duration(milliseconds: 1400),
          ),
        );
      },
      child: Hero(
        tag: _heroTag,
        createRectTween: (begin, end) => CardHeroTween(
          begin: begin,
          end: end,
        ),
        placeholderBuilder: (context, size, child) {
          return SizedBox.fromSize(size: size);
        },
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          return Material(
            color: Colors.transparent,
            child: HeroContent(
              mainCardBuilder,
              contentCardBuilder,
              closeButtonBuilder,
              state: HeroContentState.flight,
              decoration: decoration,
              scrollController: _scrollController,
              animation: animation,
              flightDirection: flightDirection,
            ),
          );
        },
        child: HeroContent(
          mainCardBuilder,
          contentCardBuilder,
          closeButtonBuilder,
          state: HeroContentState.card,
          decoration: decoration,
          scrollController: _scrollController,
          animation: const AlwaysStoppedAnimation(0),
        ),
      ),
    );
  }
}
