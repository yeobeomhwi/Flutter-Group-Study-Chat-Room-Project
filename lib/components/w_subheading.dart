import 'package:flutter/material.dart';

class subheading extends StatelessWidget {
  final String title;
  const subheading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
