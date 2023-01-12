import 'dart:developer';

import 'package:cupertino_icons/cupertino_icons.dart';
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
              for (int i = 0; i < 10; i++) //TemplateCard(index: i),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AppStoreCard(),
                ),
              for (int i = 0; i < 20; i++) TemplateCard(index: i),
            ],
          ),
        ),
      ),
    );
  }
}

class AppStoreCard extends StatelessWidget {
  final heroTag = UniqueKey();

  AppStoreCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, _, __) => DetailPage(heroTag: heroTag),
            transitionDuration: const Duration(milliseconds: 1200),
            reverseTransitionDuration: const Duration(milliseconds: 1400),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        createRectTween: (begin, end) => CustomHeroTween(
          begin: begin,
          end: end,
        ),
        placeholderBuilder: (context, size, child) {
          return SizedBox.fromSize(size: size);
        },
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          return Material(
            child: HeroContainer(
                animation: animation, flightDirection: flightDirection),
          );
        },
        child: const HeroContainer(animation: AlwaysStoppedAnimation(0)),
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
  const DetailPage({Key? key, required this.heroTag}) : super(key: key);

  final Object heroTag;

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
        createRectTween: (begin, end) => CustomHeroTween(
          begin: begin,
          end: end,
        ),
        child: const HeroContainer(animation: AlwaysStoppedAnimation(1)),
      ),
    );
  }
}

class CustomHeroTween extends Tween<Rect?> {
  CustomHeroTween({super.begin, super.end});

  /// curveTweenX - for transform horizontal coordinates
  /// curveTweenY - for transform vertical coordinates
  late final curveTweenX = CurveTween(curve: Curves.linear);
  late final curveTweenY = CurveTween(curve: const ElasticOutCurve(0.7));
  final _xEnd = 0.4;

  @override
  Rect? transform(double t) {
    final x = curveTweenX.transform(math.min(1, t / _xEnd));
    final y = curveTweenY.transform(t);

    final verticalRect = Rect.lerp(begin, end, y);
    final horizontalRect = Rect.lerp(begin, end, x);

    if (horizontalRect == null || verticalRect == null) {
      return null;
    }

    // if (verticalRect.size.height < 400) {
    //   print('object');
    // }

    return Rect.fromLTWH(horizontalRect.left, verticalRect.top,
        horizontalRect.width, horizontalRect.height);
  }
}

class HeroContainer extends AnimatedWidget {
  const HeroContainer({
    Key? key,
    required this.animation,
    this.flightDirection = HeroFlightDirection.push,
    this.dividerColor,
  }) : super(key: key, listenable: animation);

  final HeroFlightDirection flightDirection;
  final Animation<double> animation;
  final Color? dividerColor;
  static const _paddingValue = 16.0;
  static const _cardHeight = 400.0;
  static const _cardHeightExtend = 40.0;

  final _sizeEnd = 0.4;

  @override
  Widget build(BuildContext context) {
    // final sizeAnimationValue = math.min(1.0, animation.value / _sizeEnd);
    final sizeAnimationValue = flightDirection == HeroFlightDirection.push
        ? math.min(1.0, animation.value / _sizeEnd)
        : (1.0 - math.min(1.0, (1.0 - animation.value) / _sizeEnd));

    var cardHeightExtendValue = _cardHeightExtend * sizeAnimationValue;
    final h = (MediaQuery.of(context).size.height -
                _cardHeight -
                cardHeightExtendValue) *
            sizeAnimationValue +
        _cardHeight +
        cardHeightExtendValue;

    log('$flightDirection ${animation.value} sizeAnimationValue $sizeAnimationValue h $h');

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: _cardHeight + cardHeightExtendValue,
                    // decoration: BoxDecoration(
                    //   image: const DecorationImage(
                    //     image: AssetImage('assets/images/image.jpg'),
                    //     fit: BoxFit.cover,
                    //   ),
                    //   borderRadius: BorderRadius.vertical(
                    //     top: const Radius.circular(15),
                    //     bottom: Radius.circular(15 * (1 - sizeAnimationValue)),
                    //   ),
                    // ),
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
                                  maxHeight: _cardHeight + _cardHeightExtend,
                                  maxWidth: MediaQuery.of(context).size.width,
                                  child: const Image(
                                    image:
                                        AssetImage('assets/images/image.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                    BorderRadius.circular(10),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Cooking Madness-\nKitchen Frenzy',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Cook food in restaurants!',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: Colors.white,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                  Expanded(
                    child: FadeTransition(
                      opacity: animation,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          if (dividerColor != null)
                            Divider(
                              color: dividerColor,
                              height: 1,
                            ),
                          for (int i = 0; i < 20; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: _paddingValue),
                              child: TemplateCard(
                                index: i,
                                detailCard: true,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
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
