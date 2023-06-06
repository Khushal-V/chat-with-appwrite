import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthService authService;
  SplashBloc({required this.authService}) : super(SplashInitial()) {
    on<SplashEvent>((event, emit) {});
    on<CheckUserIsLoggedInEvent>(_checkUserIsLoggedIn);
  }

  //Khushal: Check current user flow
  _checkUserIsLoggedIn(
      CheckUserIsLoggedInEvent event, Emitter<SplashState> emit) async {
    try {
      //Khushal: Get current user
      User user = await AppWriteService.account.get();
      //Khushal: Get current user details
      AppWriteService.user = await authService.getCurrentUser(user.$id);
      emit(UserAlreadyLoggedInState());
    } catch (e) {
      //Khushal: Show error if any occured
      emit(UserIsNotLoggedInState());
    }
  }
}
