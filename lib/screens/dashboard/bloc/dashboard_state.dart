part of 'dashboard_bloc.dart';

@immutable
class DashboardState {
  final PagingController<String?, CreateNewChat> pagingController;

  const DashboardState({required this.pagingController});

  DashboardState copyWith(
      {required PagingController<String?, CreateNewChat> pagingController}) {
    return DashboardState(
      pagingController: pagingController,
    );
  }
}
