import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/custom_widgets/loader_view.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/screens/messages/bloc/messages_bloc.dart';
import 'package:my_chat/screens/messages/views/chat_images_view.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class MessagesPage extends StatelessWidget {
  final AuthUser chatUser;
  final String chatId;
  const MessagesPage({super.key, required this.chatUser, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagesBloc, MessagesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PagedListView<String?, Messages>(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          reverse: true,
          pagingController: state.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Messages>(
            newPageProgressIndicatorBuilder: (context) {
              return Center(
                heightFactor: 5,
                child: LoaderView(
                  loaderColor: Theme.of(context).primaryColor,
                ),
              );
            },
            firstPageProgressIndicatorBuilder: (context) {
              return Center(
                  heightFactor: 25,
                  widthFactor: 25,
                  child: LoaderView(
                    loaderColor: Theme.of(context).primaryColor,
                  ));
            },
            noItemsFoundIndicatorBuilder: (context) => 0.hSizedBox,
            itemBuilder: (context, item, index) {
              //Khushal: Check current and next message day and based on it show date between messages
              bool showDateTime = false;
              if (index != state.pagingController.itemList!.length - 1) {
                //Khushal: Get current message date
                DateTime currentMessageTime =
                    DateTime.parse(item.createdAt!).toLocal();
                //Khushal: Get next message date
                DateTime nextMessageTime = DateTime.parse(
                        state.pagingController.itemList![index + 1].createdAt!)
                    .toLocal();
                //Khushal: Check curent and next message day are not same, then should show date
                if (currentMessageTime.day != nextMessageTime.day) {
                  showDateTime = true;
                }
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Khushal: Show date
                  if (showDateTime) ...[
                    DateView(
                        dateTime: DateTime.parse(state
                            .pagingController.itemList![index].createdAt!)),
                  ],
                  //Khushal: Show date
                  if (index == state.pagingController.itemList!.length - 1 &&
                      !showDateTime) ...[
                    10.hSizedBox,
                    DateView(dateTime: DateTime.parse(item.createdAt!)),
                  ],
                  //Khushal: Messages tile
                  MessageTile(
                    messages: item,
                    chatUser: chatUser,
                    messagesState: state,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class DateView extends StatelessWidget {
  final DateTime dateTime;
  const DateView({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondTextColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TitleTextView(
        DateFormat("MMM dd").format(dateTime.toLocal()),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final Messages messages;
  final AuthUser chatUser;
  final MessagesState messagesState;
  const MessageTile({
    super.key,
    required this.messages,
    required this.chatUser,
    required this.messagesState,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (messages.isDeleted == false) {
          if (messagesState.deleteMessages.isNotEmpty &&
              messages.isCurrentUser) {
            context
                .read<MessagesBloc>()
                .add(CreateDeleteMessageListEvent(message: messages));
          }
        }
      },
      onLongPress: () {
        if (messages.isDeleted == false) {
          if (messagesState.deleteMessages.isEmpty && messages.isCurrentUser) {
            context
                .read<MessagesBloc>()
                .add(CreateDeleteMessageListEvent(message: messages));
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: messages.isCurrentUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: messages.isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 4.0),
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        decoration: BoxDecoration(
                          color: messages.isCurrentUser
                              ? Theme.of(context).primaryColor
                              : AppColors.secondTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                            bottomLeft: !messages.isCurrentUser
                                ? const Radius.circular(0.0)
                                : const Radius.circular(20.0),
                            bottomRight: messages.isCurrentUser
                                ? const Radius.circular(0.0)
                                : const Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: messages.isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (messages.isDeleted == true) ...[
                              TitleTextView(
                                "Message deleted",
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: messages.isCurrentUser
                                    ? AppColors.whiteColor
                                    : AppColors.textColor,
                              ),
                            ] else ...[
                              //Khushal: Messages image view
                              if (messages.messageType?.isPhoto == true) ...[
                                MessageImages(
                                  message: messages,
                                ),
                                12.hSizedBox
                              ],
                              //Khushal: Messages text view
                              if (messages.message?.isNotEmpty == true) ...[
                                TitleTextView(
                                  messages.message ?? "",
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: messages.isCurrentUser
                                      ? AppColors.whiteColor
                                      : AppColors.textColor,
                                ),
                              ],
                            ],
                            //Khushal: Messages time view
                            TitleTextView(
                              DateTime.parse(messages.createdAt!)
                                  .toLocal()
                                  .formatMessageTime,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.end,
                              color: messages.isCurrentUser
                                  ? AppColors.whiteColor
                                  : AppColors.textColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (messagesState.deleteMessages
                    .firstWhereOrNull((element) => element.id == messages.id) !=
                null) ...[
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                      bottomLeft: !messages.isCurrentUser
                          ? const Radius.circular(0.0)
                          : const Radius.circular(20.0),
                      bottomRight: messages.isCurrentUser
                          ? const Radius.circular(0.0)
                          : const Radius.circular(20.0),
                    ),
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MessageImages extends StatelessWidget {
  final Messages message;
  const MessageImages({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.status?.isSending == true &&
        message.localFiles?.isNotEmpty == true) {
      return SizedBox(
        height: 25.h,
        width: 75.w,
        child: Stack(
          children: [
            if (message.localFiles?.length == 2) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      child: SizedBox(
                        height: 25.h,
                        child: Image.file(
                          File(message.localFiles!.first.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: AppColors.backgroundColor,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                    width: 1,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.file(
                        File(message.localFiles![1].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (message.localFiles?.length == 3) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      child: SizedBox(
                        height: 25.h,
                        child: Image.file(
                          File(message.localFiles!.first.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: AppColors.backgroundColor,
                    thickness: 2,
                    indent: 0,
                    endIndent: 0,
                    width: 1,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 25.h,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.file(
                          File(message.localFiles![1].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    TitleTextView("+1",
                        fontSize: 48, color: AppColors.backgroundColor),
                  ],
                ),
              ),
            ] else if (message.localFiles?.length == 4) ...[
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              // bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            child: SizedBox(
                              height: 12.5.h,
                              child: Image.file(
                                File(message.localFiles!.first.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: AppColors.backgroundColor,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                          width: 1,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 12.4.h,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                // bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Image.file(
                                File(message.localFiles![1].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.backgroundColor,
                    thickness: 1,
                    height: 0,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              // topLeft: Radius.circular(20),
                            ),
                            child: SizedBox(
                              height: 12.5.h,
                              child: Image.file(
                                File(message.localFiles![2].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: AppColors.backgroundColor,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                          width: 1,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 12.4.h,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                // topRight: Radius.circular(20),
                              ),
                              child: Image.file(
                                File(message.localFiles![3].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else if ((message.localFiles?.length ?? 0) > 4) ...[
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                            child: SizedBox(
                              height: 12.5.h,
                              child: Image.file(
                                File(message.localFiles!.first.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: AppColors.backgroundColor,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                          width: 1,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 12.4.h,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                              ),
                              child: Image.file(
                                File(message.localFiles![1].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.backgroundColor,
                    thickness: 1,
                    height: 0,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                            child: SizedBox(
                              height: 12.5.h,
                              child: Image.file(
                                File(message.localFiles![2].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: AppColors.backgroundColor,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                          width: 1,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 12.4.h,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.file(
                                File(message.localFiles![3].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleTextView("+${((message.localFiles?.length ?? 0) - 4)}",
                        fontSize: 48, color: AppColors.backgroundColor),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(
                width: 75.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(message.localFiles!.first.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoaderView(loaderColor: Theme.of(context).primaryColor),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (message.status?.isSent == true &&
        message.imageUrls.isNotEmpty == true) {
      return GestureDetector(
        onTap: () {
          context.pushNamed(
              path: RoutesName.viewImage, arguments: message.imageUrls);
        },
        child: ChatImageView(
          imageUrls: message.imageUrls,
        ),
      );
    }
    return 0.hSizedBox;
  }

  int getRemainingCount(int minuesCount) =>
      (message.uploadedFile?.length ?? 0) - minuesCount;
}
