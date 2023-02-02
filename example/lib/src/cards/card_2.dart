import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainCardView2 extends StatelessWidget {
  const MainCardView2(
      {Key? key, required this.animationValue, required this.heightValue})
      : super(key: key);

  final double animationValue;
  final double heightValue;

  @override
  Widget build(BuildContext context) {
    final cards = [1, 1, 1, 1];
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'OUR FAVOURITES',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Top iPhone apps\nthis week',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Spacer(),
          for (int i = 0; i < cards.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: AppStoreAppTile(
                  showDivider: i != cards.length - 1 || animationValue > 0),
            )
        ],
      ),
    );
  }
}

class AppStoreAppTile extends StatelessWidget {
  final bool showDivider;

  const AppStoreAppTile({Key? key, this.showDivider = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 47,
                width: 47,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YouTubeL Watch,\nListen, Stream',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Videos, Music and Live Streams',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    InputChip(
                      onPressed: () {},
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'GET',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color:
                        showDivider ? Colors.grey.shade800 : Colors.transparent,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
