library app_store_card_animation;

import 'package:flutter/material.dart';

import 'src/fullscreen_page.dart';
import 'src/hero_container.dart';
import 'src/tween.dart';
import 'src/types_def.dart';

class AppStoreCard extends StatelessWidget {
  final _heroTag = UniqueKey();
  final _scrollController = ScrollController();

  final MainCardBuilder mainCardBuilder;
  final ContentCardBuilder contentCardBuilder;
  final Color backgroundColor;
  final double mainContentExpandedTopPadding;

  AppStoreCard({
    Key? key,
    required this.mainCardBuilder,
    required this.contentCardBuilder,
    this.mainContentExpandedTopPadding = 0,
    this.backgroundColor = Colors.grey,
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
              heroContent: HeroContent(mainCardBuilder, contentCardBuilder,
                  HeroContentState.fullscreen,
                  backgroundColor: backgroundColor,
                  scrollController: _scrollController,
                  mainContentExpandedTopPadding: mainContentExpandedTopPadding,
                  animation: const AlwaysStoppedAnimation(1)),
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
              backgroundColor: backgroundColor,
              HeroContentState.flight,
              scrollController: _scrollController,
              mainContentExpandedTopPadding: mainContentExpandedTopPadding,
              animation: animation,
              flightDirection: flightDirection,
            ),
          );
        },
        child: HeroContent(
          mainCardBuilder,
          contentCardBuilder,
          HeroContentState.card,
          backgroundColor: backgroundColor,
          mainContentExpandedTopPadding: mainContentExpandedTopPadding,
          scrollController: _scrollController,
          animation: const AlwaysStoppedAnimation(0),
        ),
      ),
    );
  }
}
