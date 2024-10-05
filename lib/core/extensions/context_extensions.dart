import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_build_balancer/core/providers/tab_navigator.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  TabNavigator get tabNavigator => read<TabNavigatorProvider>().navigator;
  void pop() => tabNavigator.pop();

  void push(Widget page) => tabNavigator.push(page);

  void popUntil(Widget page) => tabNavigator.popUntil(TabItem(child: page));
}
