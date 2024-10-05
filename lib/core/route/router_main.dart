part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SportsScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
            create: (context) => serviceLocator<SportsBloc>(),
            child: const SportsScreen()),
        settings: settings,
      );

    default:
      return _pageBuilder(
        (_) => BlocProvider(
            create: (context) => serviceLocator<SportsBloc>(),
            child: const SportsScreen()),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext context) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
