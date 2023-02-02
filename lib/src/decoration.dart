import 'dart:ui';

import 'package:flutter/material.dart';

class AppStoreCardDecoration {
  /// Top padding when card opened as fullscreen page
  final double? fullscreenTopPadding;

  final Color? backgroundColor;

  /// Just size of card when one as card
  final double? cardHeight;

  const AppStoreCardDecoration({
    this.fullscreenTopPadding,
    this.backgroundColor = Colors.grey,
    this.cardHeight,
  });
}
