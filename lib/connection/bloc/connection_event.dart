part of 'connection_bloc.dart';

@immutable
abstract class ConnectionEvent {}

class ListenInternetConnectionEvent extends ConnectionEvent {}

class ConnectionGoneEvent extends ConnectionEvent {}

class ConnectionRestoreEvent extends ConnectionEvent {}
