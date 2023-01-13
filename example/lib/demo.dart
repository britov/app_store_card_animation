import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<int> top = <int>[];
  List<int> bottom = <int>[0, 1, 2, 3, 4, 5, 6, 7];

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Press on the plus to add items above and below'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              top.add(-top.length - 1);
              bottom.add(bottom.length);
            });
          },
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollBuilder(
              scrollController: scrollController,
              builder: (context, offset) => Transform.translate(
                offset: Offset(0, -(min(300.0, offset ?? 0))),//0 - max(300, offset ?? 0)),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.blue,
                  height: 300,
                  child: Text('Item: 123'),
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverPadding(padding: EdgeInsets.only(top: 300)),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        color: Colors.blue[200 + bottom[index] % 4 * 100],
                        height: 100 + bottom[index] % 4 * 20.0,
                        child: Text('Item: ${bottom[index]}'),
                      );
                    },
                    childCount: bottom.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
  }

  void onUpdate() {
    if (!widget.scrollController.hasClients) {
      return;
    }
    final newExtentBefore = widget.scrollController.position.extentBefore;
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
