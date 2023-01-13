import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainCardView1 extends StatelessWidget {
  const MainCardView1({Key? key, required this.animationValue, required this.heightValue}) : super(key: key);

  final double animationValue;
  final double heightValue;

  @override
  Widget build(BuildContext context) {
    const _paddingValue = 16.0;

    const blackColor = Color(0xFF1A1A1A);

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(15),
              bottom:
              Radius.circular(15 * (1 - animationValue)),
            ),
            child: OverflowBox(
              maxHeight: heightValue,
              maxWidth: MediaQuery.of(context).size.width,
              child: const Image(
                image: AssetImage('assets/images/image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
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
                        15 * (1 - animationValue)),
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
        ),
      ],
    );
  }
}
