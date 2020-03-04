import 'package:flutter/material.dart';
import 'circularRevealClipper.dart';

/// TAKEN FROM https://medium.com/@onetdev/circle-reveal-page-route-transition-in-flutter-7b44460d22e2

class RevealRoute extends PageRouteBuilder {
  final Widget page;
  final AlignmentGeometry centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;
  final Duration transitionDuration;

  /// Reveals the next item pushed to the navigation using circle shape.
  ///
  /// You can provide [centerAlignment] for the reveal center or if you want a
  /// more precise use only [centerOffset] and leave other blank.
  ///
  /// The transition doesn't affect the entry screen so we will only touch
  /// the target screen.
  RevealRoute({
    @required this.page,
    this.minRadius = 0,
    @required this.maxRadius,
    this.centerAlignment,
    this.centerOffset,
    this.transitionDuration = const Duration(milliseconds: 500),
  })  : assert(centerOffset != null || centerAlignment != null),
        super(
        /// We could override pageBuilder but it's a required parameter of
        /// [PageRouteBuilder] and it won't build unless it's provided.
        pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            ) {
          return page;
        },
      );

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: animation.value < 1 ? animation.value : 0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).canvasColor,
          ),
        ),

        ClipPath(
          clipper: CircularRevealClipper(
          fraction: animation.value,
          centerAlignment: centerAlignment,
          centerOffset: centerOffset,
          minRadius: minRadius,
          maxRadius: maxRadius,
          ),
          child: child,
        ),
      ],
    );


  }
}