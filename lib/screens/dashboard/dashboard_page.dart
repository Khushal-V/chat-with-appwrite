import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/circle_image.dart';
import 'package:my_chat/custom_widgets/custom_button.dart';
import 'package:my_chat/custom_widgets/loader_view.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/screens/chat/models/create_new_chat.dart';
import 'package:my_chat/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_chat/screens/messages/models/message.dart';
import 'package:my_chat/service_impl/auth_service_impl.dart';
import 'package:my_chat/service_impl/chat_service_impl.dart';
import 'package:my_chat/services/appwirte_service.dart';
import 'package:my_chat/subscribe/subscribe_channel_bloc.dart';
import 'package:my_chat/utils/app_colors.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        authService: AuthServiceImpl(),
        chatService: ChatServiceImpl(),
      ),
      child: const DashboardPageUI(),
    );
  }
}

class DashboardPageUI extends StatefulWidget {
  const DashboardPageUI({super.key});

  @override
  State<DashboardPageUI> createState() => _DashboardPageUIState();
}

class _DashboardPageUIState extends State<DashboardPageUI> {
  @override
  void initState() {
    super.initState();
    //Khushal: Get DashboardState
    DashboardState dashboardState = context.read<DashboardBloc>().state;

    //Khushal: Add page listner to get chat users
    dashboardState.pagingController.addPageRequestListener((pageKey) {
      context.read<DashboardBloc>().add(LoadChatUsersEvent(
            cursorAfter: pageKey,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscribeChannelBloc, SubscribeChannelState>(
      listener: (context, state) {
        //Khushal: Update chat user if any other user do message
        if (state is UpdateDashBoardChatState) {
          context
              .read<DashboardBloc>()
              .add(UpdateUserChatListEvent(payload: state.payload));
        }
      },
      builder: (context, state) {
        return BlocConsumer<DashboardBloc, DashboardState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BaseScafflod(
              appBarTitle: AppStrings.chats,
              actions: [
                //Khushal: Go to user profile view
                Padding(
                  padding: EdgeInsets.only(right: 8.sp),
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(path: RoutesName.profile);
                    },
                    child: const Icon(
                      Icons.person,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
              body: RefreshIndicator(
                onRefresh: () async => state.pagingController.refresh(),
                child: PagedListView<String?, CreateNewChat>.separated(
                  pagingController: state.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<CreateNewChat>(
                    newPageProgressIndicatorBuilder: (context) {
                      return Center(
                        heightFactor: 25,
                        child: LoaderView(
                          loaderColor: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                    firstPageProgressIndicatorBuilder: (context) {
                      return Center(
                        heightFactor: 25,
                        child: LoaderView(
                          loaderColor: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                    noItemsFoundIndicatorBuilder: (context) =>
                        const NoChatFoundView(),
                    itemBuilder: (context, item, index) => ChatTile(chat: item),
                  ),
                  separatorBuilder: (context, index) => 1.h.hSizedBox,
                ),
              ),
              floatingActionButton: (state.pagingController.itemList != null &&
                      state.pagingController.itemList?.isNotEmpty == true)
                  ? FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        context.pushNamed(path: RoutesName.selectUser);
                      },
                      child: const Icon(Icons.add, color: AppColors.whiteColor),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}

class ChatTile extends StatelessWidget {
  final CreateNewChat chat;
  const ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context
            .pushNamedWithResult(
                path: RoutesName.chat, arguments: chat.chatUser)
            .then((value) {
          context.read<DashboardBloc>().add(RefreshDashboardEvent());
        });
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
          child: Row(
            children: [
              //Khushal: User profile
              CircleImage(
                image: chat.chatUser?.profileUrl,
              ),
              10.wSizedBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //Khushal: User name
                        Expanded(
                          child: TitleTextView(
                            chat.chatUser?.name,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        //Khushal: User last time chat date
                        TitleTextView(
                          DateTime.parse(chat.updatedAt!).timeAgo(),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //Khushal: Display last message
                        if (chat.lastMessageType?.isPhoto == true) ...[
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.photo,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                                5.wSizedBox,
                                TitleTextView(
                                  "Photo",
                                  fontWeight: FontWeight.w400,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12.sp,
                                ),
                              ],
                            ),
                          ),
                        ] else if (chat.lastMessage?.isNotEmpty == true) ...[
                          Expanded(
                            child: TitleTextView(
                              chat.lastMessage ?? "",
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ] else ...[
                          const Expanded(child: SizedBox()),
                        ],
                        10.wSizedBox,
                        //Khushal: Display unread message count
                        UnReadMessageCount(
                          chat: chat,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnReadMessageCount extends StatelessWidget {
  final CreateNewChat chat;
  const UnReadMessageCount({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    if ((chat.unreadCount?[AppWriteService.user?.id] ?? 0) > 0) {
      return Container(
        height: 18.sp,
        width: 18.sp,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: TitleTextView(
            (chat.unreadCount?[AppWriteService.user?.id] ?? 0).toString()),
      );
    } else {
      return 0.hSizedBox;
    }
  }
}

class NoChatFoundView extends StatelessWidget {
  const NoChatFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(
          title: AppStrings.startChat,
          onTap: () {
            context.pushNamed(path: RoutesName.selectUser);
          },
        ),
      ],
    );
  }
}
