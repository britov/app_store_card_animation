import 'dart:developer';

import 'package:app_store_card_animation/src/tween.dart';
import 'package:app_store_card_animation/app_store_card_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: SafeArea(
          top: true,
          child: ListView(
            children: [
              for (int i = 0; i < 10; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AppStoreCard(
                    mainCardBuilder: (BuildContext context) {
                      return Container();
                    },
                    contentCardBuilder: (BuildContext context,
                        ScrollController scrollController,
                        ScrollPhysics? scrollPhysics,
                        double topScrollOffset) {
                      return ListView(
                        controller: scrollController,
                        physics: scrollPhysics,
                        padding: EdgeInsets.zero,
                        children: [
                          SizedBox(
                            height: topScrollOffset,
                          ),
                          for (int i = 0; i < 20; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: TemplateCard(
                                index: i,
                                detailCard: true,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppStoreCard extends StatelessWidget {
  final _heroTag = UniqueKey();
  final _scrollController = ScrollController();

  final MainCardBuilder mainCardBuilder;
  final ContentCardBuilder contentCardBuilder;

  AppStoreCard({
    Key? key,
    required this.mainCardBuilder,
    required this.contentCardBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _scrollController.jumpTo(0);
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, _, __) => DetailPage(
              heroTag: _heroTag,
              heroContent: HeroContent(mainCardBuilder, contentCardBuilder,
                  HeroContentState.fullscreen,
                  scrollController: _scrollController,
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
            child: HeroContent(
              mainCardBuilder,
              contentCardBuilder,
              HeroContentState.flight,
              scrollController: _scrollController,
              animation: animation,
              flightDirection: flightDirection,
            ),
          );
        },
        child: HeroContent(
            mainCardBuilder, contentCardBuilder, HeroContentState.card,
            scrollController: _scrollController,
            animation: const AlwaysStoppedAnimation(0)),
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  const TemplateCard({Key? key, required this.index, this.detailCard = false})
      : super(key: key);

  final int index;
  final bool detailCard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 80,
        child: Container(
          decoration: BoxDecoration(
            color: detailCard ? Colors.indigo : Colors.blueGrey,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: ListTile(
            title: Text(detailCard
                ? 'Detail info #$index'
                : 'Placeholder card #$index'),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.heroTag, required this.heroContent})
      : super(key: key);

  final Object heroTag;
  final HeroContent heroContent;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.bottom,
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: widget.heroTag,
        createRectTween: (begin, end) => CardHeroTween(
          begin: begin,
          end: end,
        ),
        child: widget.heroContent,
      ),
    );
  }
}

class ExapmpleCard extends StatelessWidget {
  const ExapmpleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum HeroContentState { card, flight, fullscreen }

class HeroContent extends AnimatedWidget {
  const HeroContent(
    this.mainCardBuilder,
    this.contentCardBuilder,
    this.state, {
    Key? key,
    required this.animation,
    required this.scrollController,
    this.cardHeight = 400,
    this.flightDirection = HeroFlightDirection.push,
    // this.dividerColor,
  }) : super(key: key, listenable: animation);

  final MainCardBuilder mainCardBuilder;
  final ContentCardBuilder contentCardBuilder;
  final HeroContentState state;

  final HeroFlightDirection flightDirection;
  final Animation<double> animation;

  // final Color? dividerColor;
  static const _paddingValue = 16.0;
  final double cardHeight;
  static const _cardHeightExtend = 40.0;

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

    final blackColor = const Color(0xFF1A1A1A);

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: h,
        child: Container(
          decoration: BoxDecoration(
            color: blackColor,
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
                      child: SizedBox(
                        height: totalCardHeight,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: const Radius.circular(15),
                                      bottom: Radius.circular(
                                          15 * (1 - sizeAnimationValue)),
                                    ),
                                    child: OverflowBox(
                                      maxHeight: totalCardHeight,
                                      maxWidth:
                                          MediaQuery.of(context).size.width,
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/images/image.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //     left: _paddingValue,
                                    //     top: topPadding,
                                    //     right: _paddingValue,
                                    //   ),
                                    //   child: Text(
                                    //     'LIFE HACK',
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyLarge
                                    //         ?.copyWith(
                                    //           color: Colors.black54,
                                    //         ),
                                    //     textAlign: TextAlign.left,
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //     left: _paddingValue,
                                    //     top: _paddingValue,
                                    //     right: _paddingValue,
                                    //   ),
                                    //   child: Text(
                                    //     'Can you master a\nnew language?',
                                    //     style: Theme.of(context).textTheme.displaySmall,
                                    //     textAlign: TextAlign.left,
                                    //   ),
                                    // ),

                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: _paddingValue,
                                        bottom: _paddingValue,
                                        right: _paddingValue,
                                      ),
                                      child: Text(
                                        'GAME\nOF THE\nDAY',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                    Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: blackColor,
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(
                                              15 * (1 - sizeAnimationValue)),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  _paddingValue),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      'assets/images/logo.jpg',
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Cooking Madness-\nKitchen Frenzy',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                        ),
                                                        Text(
                                                          'Cook food in restaurants!',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: _paddingValue,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(''),
                                                InputChip(
                                                  onPressed: () {},
                                                  label: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Text(
                                                      'GET',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                ),
                                                Text(
                                                  'In-app purchases',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                top: _paddingValue * 2,
                right: _paddingValue,
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

class ScrollBuilder extends StatefulWidget {
  const ScrollBuilder({
    Key? key,
    required this.builder,
    required this.scrollController,
  }) : super(key: key);

  final Widget Function(BuildContext context, double? extentBefore) builder;
  final ScrollController scrollController;

  @override
  State<ScrollBuilder> createState() => _ScrollBuilderState();
}

class _ScrollBuilderState extends State<ScrollBuilder> {
  double? extentBefore;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, extentBefore);
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(onUpdate);
    onUpdate();
  }

  void onUpdate() {
    if (!widget.scrollController.hasClients) {
      return;
    }
    final newExtentBefore =
        widget.scrollController.positions.first.extentBefore;
    if (newExtentBefore != extentBefore) {
      setState(() {
        extentBefore = newExtentBefore;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(onUpdate);
  }
}
