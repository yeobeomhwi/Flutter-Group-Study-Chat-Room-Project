import 'package:flutter/material.dart';

mixin ScrollMixin<T extends StatefulWidget> on State<T> {
  late ScrollController _scrollController;
  final double _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent - _scrollController.position.pixels <= _scrollThreshold) {
      onScroll();
    }
  }

  void onScroll();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController get scrollController => _scrollController;
}
