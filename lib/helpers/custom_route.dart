import 'package:flutter/material.dart';


// this here for single route animation for the fly creation.
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name=='/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    // return super
    //     .buildTransitions(context, animation, secondaryAnimation, child);
  }
}

// This here for general theme which affect all route 
// transaction or animation for all routes in app.
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name=='/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
}
}