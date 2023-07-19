import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/screens/chat/models/create_new_chat.dart';
import 'package:my_chat/screens/dashboard/models/chat_list_response.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/services/auth_service.dart';
import 'package:my_chat/services/chat_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ChatService chatService;
  final AuthService authService;
  DashboardBloc({required this.chatService, required this.authService})
      : super(DashboardState(
            pagingController: PagingController(firstPageKey: null))) {
    on<DashboardEvent>((event, emit) {});
    on<RefreshDashboardEvent>((event, emit) {
      emit(state.copyWith(pagingController: state.pagingController));
    });
    on<LoadChatUsersEvent>(_loadChatUsers);
    on<UpdateUserChatListEvent>(_updateUserChatList);
  }

  //Khushal: Load chat user
  _loadChatUsers(LoadChatUsersEvent event, Emitter<DashboardState> emit) async {
    ChatListResponse response =
        await chatService.getChatList(event.cursorAfter);
    //Khushal: If response have lastId then should we load other page
    if (response.lastId != null) {
      state.pagingController.appendPage(response.chats, response.lastId);
    } else {
      //Khushal: If response have'nt last id then it should last page
      state.pagingController.appendLastPage(response.chats);
    }
    add(RefreshDashboardEvent());
  }

  //Khushal: Update user chat list
  _updateUserChatList(
      UpdateUserChatListEvent event, Emitter<DashboardState> emit) async {
    CreateNewChat chat = CreateNewChat.fromJson(event.payload);

    //Khushal: Check if incomming message have current user id and last message not null
    if (chat.users!.contains(AppWriteService.user!.id) &&
        chat.lastMessage != null) {
      //Khushal: Getting current user from list
      CreateNewChat? getExistChat = state.pagingController.itemList
          ?.firstWhereOrNull((element) => element.id == chat.id);

      //Khushal: If "getExistChat" is null then should add new chat in it
      if (getExistChat == null) {
        //Khushal: Get incomming user ID
        String userId = chat.users!
            .firstWhere((element) => element != AppWriteService.user!.id);

        //Khushal: Get incomming user details
        chat.chatUser = await authService.getCurrentUser(userId);

        //Khushal: Update current list with new user
        state.pagingController.itemList?.insert(0, chat);
      } else {
        if (getExistChat.lastMessage != chat.lastMessage) {
          //Khushal: Remove incomming user
          state.pagingController.itemList!
              .removeWhere((element) => element.id == chat.id);

          //Khushal: Update incomming chat with "getExistChat" user
          chat.chatUser = getExistChat.chatUser;

          //Khushal: Update list with incomming chat user
          state.pagingController.itemList?.insert(0, chat);
        } else {
          final index = state.pagingController.itemList!
              .indexWhere((element) => element.id == getExistChat.id);
          chat.chatUser = getExistChat.chatUser;
          state.pagingController.itemList![index] = chat;
        }
      }
    }
    add(RefreshDashboardEvent());
  }
}
