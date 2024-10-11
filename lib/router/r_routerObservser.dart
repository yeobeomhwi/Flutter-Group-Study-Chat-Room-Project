import 'package:flutter/material.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("DidPush: $route");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("DidPop: $route");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("DidRemove: $route");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print("DidReplace: $newRoute");
  }
}
