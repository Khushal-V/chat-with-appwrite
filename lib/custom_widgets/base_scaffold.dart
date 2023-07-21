import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/connection/bloc/connection_bloc.dart' as connection;
import 'package:my_chat/custom_widgets/title_text_view.dart';

class BaseScafflod extends StatelessWidget {
  final Widget body;
  final String appBarTitle;
  final Widget? titleWidget;
  final double elevation;
  final List<Widget> actions;
  final FloatingActionButton? floatingActionButton;
  const BaseScafflod(
      {super.key,
      required this.body,
      required this.appBarTitle,
      this.elevation = 1,
      this.actions = const [],
      this.floatingActionButton,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<connection.ConnectionBloc, connection.ConnectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bool isConnectionGone = state is connection.ConnectionGoneState;
        return WillPopScope(
          onWillPop: () async => !isConnectionGone,
          child: Scaffold(
            appBar: isConnectionGone
                ? null
                : AppBar(
                    title: titleWidget ?? TitleTextView(appBarTitle),
                    elevation: elevation,
                    actions: actions,
                    centerTitle: true,
                  ),
            body: isConnectionGone
                ? const Center(
                    child: TitleTextView("No Internet Connection"),
                  )
                : body,
            floatingActionButton:
                isConnectionGone ? null : floatingActionButton,
          ),
        );
      },
    );
  }
}
