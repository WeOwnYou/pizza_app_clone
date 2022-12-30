import 'dart:async';

import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/string_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/toggle_button.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'full_screen_image.dart';

class SearchDialogView extends StatefulWidget {
  final BuildContext parentContext;
  final FutureOr<void> Function(String id, bool fromSearch)
      onSearchedMessageTap;
  const SearchDialogView({
    Key? key,
    required this.parentContext,
    required this.onSearchedMessageTap,
  }) : super(key: key);

  @override
  State<SearchDialogView> createState() => _SearchDialogViewState();
}

///Stateful, чтобы не кидать лишнего в стейт
class _SearchDialogViewState extends State<SearchDialogView> {
  late int selectedCategoryIndex;
  late final TextEditingController controller;

  @override
  void initState() {
    selectedCategoryIndex = 0;
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      child: Scaffold(
        primary: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: const SizedBox.shrink(),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 5, left: width * 0.01, right: width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.73,
                  child: CupertinoSearchTextField(
                    prefixIcon: const Icon(Icons.search),
                    borderRadius: BorderRadius.circular(kMainBorderRadius / 1.5),
                    controller: controller,
                    suffixIcon: const Icon(Icons.close),
                    placeholder: 'Поиск',
                    enabled: selectedCategoryIndex != 1,
                  ),
                ),
                SizedBox(
                  width: width * 0.2,
                  child: TextButton(
                    child: const Text(
                      'Отменить',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      await AppRouter.instance().popTop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: AppColors.mainTextOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ColoredBox(
          color: (controller.text != '' && selectedCategoryIndex == 0 ||
                  selectedCategoryIndex == 1)
              ? Colors.white
              : Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ColoredBox(
                  color: Colors.white,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 0.15, color: Colors.grey),
                      ),
                    ),
                    child: ToggleButton(
                      choices: const ['Сообщения', 'Изображения'],
                      onToggled: (index) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                if (selectedCategoryIndex == 1)
                  _ShowImagesWidget(
                    parentContext: widget.parentContext,
                  )
                else if (controller.text.isNotEmpty)
                  _BuildSearchedMessagesList(
                    parentContext: widget.parentContext,
                    searchText: controller.text,
                    onSearchedMessageTap: widget.onSearchedMessageTap,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildSearchedMessagesList extends StatelessWidget {
  final BuildContext parentContext;
  final String searchText;
  final FutureOr<void> Function(String id, bool fromSearch)
      onSearchedMessageTap;
  const _BuildSearchedMessagesList({
    Key? key,
    required this.parentContext,
    required this.searchText,
    required this.onSearchedMessageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages =
        parentContext.read<ContactsCubit>().searchedMessages(searchText);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.of(context).size.width,
          color: AppColors.mainBgGrey,
          alignment: Alignment.center,
          child: Text('сообщений найдено: ${messages.length}'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return _SearchedMessageWidget(
                message: messages[index],
                parentContext: parentContext,
                searchText: searchText,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                onTap: onSearchedMessageTap,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
              );
            },
            itemCount: messages.length,
          ),
        ),
      ],
    );
  }
}

class _SearchedMessageWidget extends StatelessWidget {
  final Message message;
  final BuildContext parentContext;
  final String searchText;
  final EdgeInsets margin;
  final FutureOr<void> Function(String id, bool fromSearch) onTap;
  const _SearchedMessageWidget({
    Key? key,
    required this.message,
    required this.parentContext,
    required this.searchText,
    required this.margin,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCustomer =
        parentContext.read<ProfileBloc>().state.person.id == message.userId;
    const titleStyle = TextStyle(color: Colors.grey, fontSize: 14);
    final firstLastIndexOf =
        message.textMessage.searchContentStartEnd(searchText);
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: () {
          onTap(message.messageId, true);
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isCustomer ? AppColors.mainIconGrey : AppColors.mainBgOrange,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCustomer ? 'Вы' : message.username,
                style: titleStyle,
              ),
              Text(
                message.createdAt.ddmmyyyyFormat,
                style: titleStyle,
              ),
            ],
          ),
          subtitle: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text:
                      message.textMessage.substring(0, firstLastIndexOf.first),
                ),
                TextSpan(
                  text: message.textMessage.substring(
                    firstLastIndexOf.first,
                    firstLastIndexOf.last + 1,
                  ),
                  style: const TextStyle(color: AppColors.mainBgOrange),
                ),
                TextSpan(
                  text:
                      message.textMessage.substring(firstLastIndexOf.last + 1),
                )
              ],
            ),
            maxLines: 1,
            // message.message
          ),
        ),
      ),
    );
  }
}

class _ShowImagesWidget extends StatelessWidget {
  final BuildContext parentContext;
  const _ShowImagesWidget({Key? key, required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = parentContext.read<ContactsCubit>().chatImages;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (ctx, index) {
          return Image.memory(
            fit: BoxFit.fill,
            images[index].byteImage!,
            frameBuilder: (ctx, child, __, ___) {
              return Padding(
                padding: const EdgeInsets.all(1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kMainBorderRadius / 4),
                  child: Hero(
                    tag: '${images[index].imageId!}image_in_search',
                    child: GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          transitionDuration: const Duration(milliseconds: 100),
                          pageBuilder: (_, __, ___) {
                            return FullScreenImage(
                              chatImages: images,
                              selectedImageIndex: index,
                              imageIn: ImageIn.search,
                            );
                          },
                        );
                      },
                      child: child,
                    ),
                  ),
                ),
              );
            },
          );
        },
        itemCount: images.length,
      ),
    );
  }
}
