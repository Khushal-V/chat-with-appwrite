part of 'connection_bloc.dart';

@immutable
abstract class ConnectionState {}

class ConnectionInitial extends ConnectionState {}

class ConnectionGoneState extends ConnectionState {}

class ConnectionRestoreState extends ConnectionState {}
