import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/input.dart';
import 'package:my_chat/custom_widgets/loader_view.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/chat/bloc/chat_bloc.dart';
import 'package:my_chat/screens/chat/models/create_new_chat.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/screens/messages/bloc/messages_bloc.dart';
import 'package:my_chat/screens/messages/messages_page.dart';
import 'package:my_chat/service_impl/chat_service_impl.dart';
import 'package:my_chat/service_impl/messages_service_impl.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class ChatPage extends StatelessWidget {
  final AuthUser user;
  const ChatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesBloc(
        chatService: ChatServiceImpl(),
        messagesService: MessagesServiceImpl(),
      ),
      child: ChatPageUI(
        user: user,
      ),
    );
  }
}

class ChatPageUI extends StatefulWidget {
  final AuthUser user;
  const ChatPageUI({super.key, required this.user});

  @override
  State<ChatPageUI> createState() => _ChatPageUIState();
}

class _ChatPageUIState extends State<ChatPageUI> {
  late String chatID;
  final TextEditingController _messageController = TextEditingController();
  List<XFile> selectedImages = [];

  @override
  void initState() {
    super.initState();

    //Khushal: Get current loggedIn user id
    String currentUserId = AppWriteService.user!.id!.substring(0, 10);

    //Khushal: Get chatting with user id
    String chatUserId = widget.user.id!.substring(0, 10);

    //Khushal: Create new chat ID
    if (chatUserId.hashCode > currentUserId.hashCode) {
      chatID = "${chatUserId}_$currentUserId";
    } else {
      chatID = "${currentUserId}_$chatUserId";
    }

    //Khushal: Create new chat object
    CreateNewChat chat =
        CreateNewChat(users: [widget.user.id ?? "", AppWriteService.user!.id!]);

    //Khushal: Update chat ID
    chat.id = chatID;

    //Khushal: Add create new chat event with "chat" object
    context.read<ChatBloc>().add(CreateNewChatEvent(chat: chat));

    //Khushal: Add event to listen current chat messages
    context.read<MessagesBloc>().add(AddPageListnerEvent(chatId: chatID));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        //Khushal: Update unread message count as 0 for current user and chatID
        if (state is CreateNewChatSuccessState) {
          context.read<MessagesBloc>().add(
                UpdateMessageUnReadCountEvent(
                  chatID: chatID,
                  count: 0,
                  userId: AppWriteService.user?.id ?? "",
                ),
              );
        }

        //Khushal: Update message list if got any new message from user
        if (state is UpdateNewChatMessageState) {
          Future.delayed(const Duration(milliseconds: 100))
              .then((value) => context.read<MessagesBloc>().add(
                    UpdateNewMessageEvent(
                        message: state.payload, chatID: chatID),
                  ));
        }
      },
      builder: (context, state) {
        //Khushal: Clear _messageController if message send success
        if (state is MessageSentSuccessState) {
          _messageController.clear();
        }

        //Khushal: Update messages images
        if (state is SelectChatImageState) {
          selectedImages.addAll(state.files);
          selectedImages = selectedImages.toSet().toList();
        }

        //Khushal: Remove selected images
        if (state is RemoveSelectedImageState) {
          selectedImages.remove(state.file);
        }

        //Khushal: Update local message if message have images
        if (state is UpdateLocalMessageState) {
          //Khushal: Clear controller and selectedImages array
          _messageController.clear();
          selectedImages.clear();

          //Khushal: Add event to update local message
          context
              .read<MessagesBloc>()
              .add(UpdateLocalMessageEvent(message: state.messages));
        }

        final bool isLoading = state is CreatingNewChatBusyState;
        return BaseScafflod(
          appBarTitle: widget.user.name ?? "",
          actions: [
            BlocConsumer<MessagesBloc, MessagesState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.deleteMessages.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      context.read<ChatBloc>().add(DeleteSelectedMessagesEvent(
                          messages: state.deleteMessages));

                      context.read<MessagesBloc>().add(
                          UpdateDeletedMessageListEvent(messages: const []));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.sp),
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.pinkColor,
                      ),
                    ),
                  );
                }
                return 0.hSizedBox;
              },
            ),
          ],
          body: SafeArea(
            child: Column(
              mainAxisAlignment:
                  isLoading ? MainAxisAlignment.center : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //Khushal: Show loader if new chat is creating
                if (isLoading) ...[
                  Center(
                    child: LoaderView(
                      loaderColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Stack(
                      children: [
                        //Khushal: All messages view
                        MessagesPage(
                          chatUser: widget.user,
                          chatId: chatID,
                        ),
                        //Khushal: Selected images view
                        if (selectedImages.isNotEmpty) ...[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ShowMessageImages(
                              files: selectedImages,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  //Khushal: Message texx box
                  SendMessageView(
                    controller: _messageController,
                    onSend: sendMessage,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  //Khushal: Send new message flow
  void sendMessage() {
    if (_messageController.text.isNotEmpty || selectedImages.isNotEmpty) {
      Messages messages = Messages(
        senderId: AppWriteService.user?.id,
        receiverId: widget.user.id,
        message: _messageController.text,
        chatId: chatID,
        messageType:
            selectedImages.isEmpty ? MessageTypes.text : MessageTypes.photo,
        localFiles: selectedImages.map((e) => e).toList(),
      );
      context.read<ChatBloc>().add(SnedTextMessageEvent(messages: messages));
    }
  }
}

class SendMessageView extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSend;
  const SendMessageView(
      {super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor),
          top: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      child: Input(
        maxLine: 5,
        controller: controller,
        hintText: AppStrings.typeMessage,
        suffixIcon: GestureDetector(
          onTap: onSend,
          child: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor,
          ),
        ),
        inputBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.whiteColor,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        prefixIcon: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //Khushal: Open image selection view
            context.read<ChatBloc>().add(SelectChatImageEvent());
          },
          child: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class ShowMessageImages extends StatelessWidget {
  final List<XFile> files;
  const ShowMessageImages({super.key, required this.files});

  void show(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 60.sp,
                    width: 60.sp,
                    child: Image.file(
                      File(files[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      //Khushal: Add event to remove current selected image
                      context
                          .read<ChatBloc>()
                          .add(RemoveSelectedImageEvent(file: files[index]));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.whiteColor,
                        fill: 0.9,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => 12.wSizedBox,
      ),
    );
  }
}
