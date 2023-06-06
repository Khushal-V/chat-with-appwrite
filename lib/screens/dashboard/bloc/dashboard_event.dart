part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class RefreshDashboardEvent extends DashboardEvent {
  RefreshDashboardEvent();
}

class LoadChatUsersEvent extends DashboardEvent {
  final String? cursorAfter;

  LoadChatUsersEvent({this.cursorAfter});
}

class UpdateUserChatListEvent extends DashboardEvent {
  final Map<String, dynamic> payload;
  UpdateUserChatListEvent({required this.payload});
}
