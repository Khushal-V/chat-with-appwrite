part of 'messages_bloc.dart';

@immutable
class MessagesState {
  final PagingController<String?, Messages> pagingController;
  final List<Messages> deleteMessages;

  const MessagesState(
      {required this.pagingController, this.deleteMessages = const []});

  MessagesState copyWith(
      {required PagingController<String?, Messages> pagingController,
      List<Messages>? deleteMessages}) {
    return MessagesState(
      pagingController: pagingController,
      deleteMessages: deleteMessages ?? this.deleteMessages,
    );
  }
}
