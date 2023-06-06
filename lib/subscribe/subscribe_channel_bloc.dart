import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_chat/constants/constants.dart';
import 'package:my_chat/screens/chat/bloc/chat_bloc.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/services/appwirte_service.dart';

part 'subscribe_channel_event.dart';
part 'subscribe_channel_state.dart';

class SubscribeChannelBloc
    extends Bloc<SubscribeChannelEvent, SubscribeChannelState> {
  SubscribeChannelBloc() : super(SubscribeChannelInitial()) {
    on<SubscribeChannelEvent>((event, emit) {});
    on<UpdateDashBoardChatEvent>((event, emit) =>
        emit(UpdateDashBoardChatState(payload: event.payload)));
    on<SubscribeMessageAndChatChannelEvent>(_subscribeMessageAndChatChannel);
  }

  //Khushal: Listen chat and messages collection updates
  _subscribeMessageAndChatChannel(SubscribeMessageAndChatChannelEvent event,
      Emitter<SubscribeChannelState> emit) {
    //Khushal: Sunscribe chat and message collection
    final subscription = AppWriteService.realtime.subscribe([
      'databases.${AppCredentials.databaseId}.collections.${AppCredentials.messagesCollection}.documents',
      'databases.${AppCredentials.databaseId}.collections.${AppCredentials.chatCollection}.documents',
    ]);

    subscription.stream.listen((RealtimeMessage response) {
      if (response.payload["\$collectionId"] ==
          AppCredentials.messagesCollection) {
        print("Message Collection");
        print(response.payload);
        //Khushal: If update from message collection then should update into message
        Constants.navigatorKey.currentContext!
            .read<ChatBloc>()
            .add(UpdateNewChatMessageEvent(
              payload: Messages.fromJson(response.payload),
            ));
      } else if (response.payload["\$collectionId"] ==
          AppCredentials.chatCollection) {
        print("Chat Collection");
        print(response.payload);
        //Khushal: If update from chat collection then should update into chat list
        add(UpdateDashBoardChatEvent(payload: response.payload));
      }
    });
  }
}
