import 'package:flutter/material.dart';

class PagePadding extends StatelessWidget {
  final Widget child;
  const PagePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: child,
    );
  }
}
