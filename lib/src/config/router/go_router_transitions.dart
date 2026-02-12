part of 'router.dart';

abstract class GoRouterTransitions {
  static CustomTransitionPage<T> slideFromTop<T>({
    required Widget child,
    Offset begin = const Offset(0, -1),
    Offset end = Offset.zero,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOut,
  }) => CustomTransitionPage(
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: begin, end: end).animate(animation),
        child: child,
      );
    },
    child: child,
  );

  static CustomTransitionPage<T> fade<T>({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOut,
  }) => CustomTransitionPage(
    transitionDuration: duration,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curve),
      child: child,
    ),
    child: child,
  );
}
