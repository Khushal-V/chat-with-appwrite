import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_chat/configs/app_strings.dart';
import 'package:my_chat/custom_widgets/base_scaffold.dart';
import 'package:my_chat/custom_widgets/circle_image.dart';
import 'package:my_chat/custom_widgets/loader_view.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/screens/auth/models/auth_user.dart';
import 'package:my_chat/screens/users/bloc/users_bloc.dart';
import 'package:my_chat/service_impl/users_service_impl.dart';
import 'package:my_chat/utils/app_router.dart';
import 'package:my_chat/utils/extensions.dart';
import 'package:sizer/sizer.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(userService: UsersServiceImpl()),
      child: const UsersPageUI(),
    );
  }
}

class UsersPageUI extends StatefulWidget {
  const UsersPageUI({super.key});

  @override
  State<UsersPageUI> createState() => _UsersPageUIState();
}

class _UsersPageUIState extends State<UsersPageUI> {
  final PagingController<String?, AuthUser> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();
    //Khushal: Add listener to get users
    _pagingController.addPageRequestListener((pageKey) {
      context.read<UsersBloc>().add(LoadUsersEvent(offSet: pageKey));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScafflod(
      appBarTitle: AppStrings.selectUser,
      body: BlocConsumer<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UserLoadedSuccessState) {
            //Khushal: Update controller base on response
            if (state.response.lastId == null) {
              _pagingController.appendLastPage(state.response.users);
            } else {
              _pagingController.appendPage(
                  state.response.users, state.response.lastId!);
            }
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () async => _pagingController.refresh(),
            child: PagedListView<String?, AuthUser>.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<AuthUser>(
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
                itemBuilder: (context, item, index) => UserTile(user: item),
              ),
              separatorBuilder: (context, index) => 1.h.hSizedBox,
            ),
          );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final AuthUser user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context.pushNamedWithResult(
            path: RoutesName.chat, arguments: user);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
          child: Row(
            children: [
              //Khushal: User profile
              CircleImage(
                image: user.profileUrl,
              ),
              2.w.wSizedBox,
              //Khushal: User name
              Expanded(
                child: TitleTextView(
                  user.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
