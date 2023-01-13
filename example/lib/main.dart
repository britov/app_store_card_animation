
import 'package:app_store_card_animation/app_store_card_animation.dart';
import 'package:example/src/cards/card_1.dart';
import 'package:flutter/material.dart';


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
                    mainCardBuilder: (
                      BuildContext context,
                      double animationValue,
                      double heightValue,
                    ) {
                      return MainCardView1(
                        animationValue: animationValue,
                        heightValue: heightValue,
                      );
                    },
                    contentCardBuilder: (
                      BuildContext context,
                      ScrollController scrollController,
                      ScrollPhysics? scrollPhysics,
                      double topScrollOffset,
                    ) {
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

