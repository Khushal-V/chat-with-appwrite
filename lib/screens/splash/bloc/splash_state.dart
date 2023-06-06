part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class UserAlreadyLoggedInState extends SplashState {}

class UserIsNotLoggedInState extends SplashState {}
