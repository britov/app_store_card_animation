import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

// This is the path that the child will follow. It's a CatmullRomSpline so
// that the coordinates can be specified that it must pass through. If the
// tension is set to 1.0, it will linearly interpolate between those points,


class FollowCurve2D extends StatefulWidget {
  const FollowCurve2D({
    super.key,
    this.curve = Curves.easeInOut,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  final Curve curve;
  final Duration duration;
  final Widget child;

  @override
  State<FollowCurve2D> createState() => _FollowCurve2DState();
}

class _FollowCurve2DState extends State<FollowCurve2D>
    with TickerProviderStateMixin {
  // The animation controller for this animation.
  late AnimationController controller;
  // The animation that will be used to apply the widget's animation curve.
  late Animation<double> animation;
  late Animation<double> animationY;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    animationY = CurvedAnimation(parent: controller, curve: ElasticOutCurve(0.7));
    // Have the controller repeat indefinitely. If you want it to "bounce" back
    // and forth, set the reverse parameter to true.
    controller.repeat();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // Always have to dispose of animation controllers when done.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scale the path values to match the -1.0 to 1.0 domain of the Alignment widget.
    final Offset position =   Offset(0, -animationY.value);

    return Align(
      alignment: Alignment(position.dx, position.dy),
      child: widget.child,
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100,),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: FollowCurve2D(
            duration: const Duration(seconds: 3),
            child: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge!,
                child: const Text('B'), // Buzz, buzz!
              ),
            ),
          ),
        ),
      ),
    );
  }
}