
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'hero_container.dart';
import 'tween.dart';

class FullscreenPage extends StatefulWidget {
  const FullscreenPage({Key? key, required this.heroTag, required this.heroContent})
      : super(key: key);

  final Object heroTag;
  final HeroContent heroContent;

  @override
  State<FullscreenPage> createState() => _FullscreenPageState();
}

class _FullscreenPageState extends State<FullscreenPage> {
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