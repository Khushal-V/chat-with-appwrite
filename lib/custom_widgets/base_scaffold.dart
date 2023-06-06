import 'package:flutter/material.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';

class BaseScafflod extends StatelessWidget {
  final Widget body;
  final String appBarTitle;
  final double elevation;
  final List<Widget> actions;
  final FloatingActionButton? floatingActionButton;
  const BaseScafflod(
      {super.key,
      required this.body,
      required this.appBarTitle,
      this.elevation = 1,
      this.actions = const [],
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextView(appBarTitle),
        elevation: elevation,
        actions: actions,
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
