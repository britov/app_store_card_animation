
import 'package:flutter/widgets.dart';

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