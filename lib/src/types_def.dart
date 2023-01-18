
import 'package:flutter/material.dart';

typedef MainCardBuilder = Widget Function(
    BuildContext context,
    double animationValue,
    double heightValue, // TODO: may be we can delete it
    );

typedef ContentCardBuilder = Widget Function(
    BuildContext context,
    ScrollController scrollController,
    ScrollPhysics? scrollPhysics,
    double topScrollOffset,
    );
