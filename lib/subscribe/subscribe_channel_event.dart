part of 'subscribe_channel_bloc.dart';

@immutable
abstract class SubscribeChannelEvent {}

class SubscribeMessageAndChatChannelEvent extends SubscribeChannelEvent {}

class UpdateDashBoardChatEvent extends SubscribeChannelEvent {
  final Map<String, dynamic> payload;

  UpdateDashBoardChatEvent({required this.payload});
}
