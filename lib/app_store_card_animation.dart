library app_store_card_animation;

import 'package:flutter/widgets.dart';

typedef MainCardBuilder = Widget Function(BuildContext context);

typedef ContentCardBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
  ScrollPhysics? scrollPhysics,
    double topScrollOffset,
);
