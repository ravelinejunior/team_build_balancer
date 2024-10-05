import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/* 
Class Overview: The TabNavigator class manages a stack of tabs, allowing you to 
navigate between them.

Class Methods:

push(Widget page): Adds a new tab to the top of the navigation stack.

pop(): Removes the top tab from the navigation stack, if there is more than one 
tab.

popToRoot(): Clears the navigation stack and returns to the initial tab.

popTo(TabItem page): Removes a specific tab from the navigation stack.

popUntil(TabItem? page): Removes all tabs from the navigation stack until a 
specific tab is reached, or clears the stack if no tab is specified.

pushAndRemoveUntil(TabItem page): Clears the navigation stack and adds a new tab
to the top.

Note that the notifyListeners() method is called after each navigation action, 
which likely notifies any listeners that the navigation stack has changed.
 */
class TabNavigator extends ChangeNotifier {
  TabNavigator(this._initialPage) {
    _navigationStack.add(_initialPage);
  }

  final List<TabItem> _navigationStack = [];
  final TabItem _initialPage;

  List<TabItem> get navigationStack => _navigationStack;
  TabItem get currentPage => _navigationStack.last;

  void push(Widget page) {
    _navigationStack.add(TabItem(child: page));
    notifyListeners();
  }

  void pop() {
    if (_navigationStack.length > 1) {
      _navigationStack.removeLast();
      notifyListeners();
    }
  }

  void popToRoot() {
    _navigationStack
      ..clear()
      ..add(_initialPage);
    notifyListeners();
  }

  void popTo(TabItem page) {
    _navigationStack.remove(page);
    notifyListeners();
  }

  void popUntil(TabItem? page) {
    if (page == null) return popToRoot();
    _navigationStack.removeWhere((element) => element.id != page.id);
    notifyListeners();
  }

  void pushAndRemoveUntil(TabItem page) {
    _navigationStack
      ..clear()
      ..add(page);
    notifyListeners();
  }
}

class TabNavigatorProvider extends InheritedNotifier<TabNavigator> {
  const TabNavigatorProvider({
    required this.navigator,
    required super.child,
    super.key,
  }) : super(notifier: navigator);

  final TabNavigator navigator;

  static TabNavigator of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TabNavigatorProvider>()!
        .navigator;
  }
}

class TabItem extends Equatable {
  TabItem({required this.child}) : id = const Uuid().v1();

  final String id;
  final Widget child;

  @override
  List<Object?> get props => [id];
}
