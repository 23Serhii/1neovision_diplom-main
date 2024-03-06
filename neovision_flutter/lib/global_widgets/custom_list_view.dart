import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;

  const CustomListView({super.key, required this.children, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      children: children,
    );
  }
}
