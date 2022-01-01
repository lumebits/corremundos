import 'package:flutter/material.dart';

class AnimatedPage<T> extends Page<T> {
  const AnimatedPage({required this.child, LocalKey? key}) : super(key: key);

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return child;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
