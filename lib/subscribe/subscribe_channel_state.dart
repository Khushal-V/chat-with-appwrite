part of 'subscribe_channel_bloc.dart';

@immutable
abstract class SubscribeChannelState {}

class SubscribeChannelInitial extends SubscribeChannelState {}

class UpdateDashBoardChatState extends SubscribeChannelState {
  final Map<String, dynamic> payload;

  UpdateDashBoardChatState({required this.payload});
}
