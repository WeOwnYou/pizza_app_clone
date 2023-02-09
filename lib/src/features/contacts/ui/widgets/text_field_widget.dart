import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:dodo_clone/src/features/contacts/ui/utils/constants.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/full_screen_image.dart';
import 'package:dodo_clone/src/features/contacts/ui/widgets/select_files_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart' hide Message;
import 'package:photo_manager/photo_manager.dart';

class TextFieldWidget extends StatefulWidget {
  final BuildContext parentContext;
  final ScrollController scrollController;
  const TextFieldWidget({
    required this.parentContext,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final ScrollController scrollController;
  late final TextEditingController textEditingController;
  @override
  void initState() {
    scrollController = widget.scrollController;
    textEditingController = TextEditingController()
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    widget.parentContext.read<ContactsCubit>().markRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contactsCubit = widget.parentContext.read<ContactsCubit>();
    return BlocBuilder<ContactsCubit, ContactsState>(
      bloc: BlocProvider.of(widget.parentContext),
      buildWhen: (oldState, newState) {
        return oldState.selectedImages != newState.selectedImages ||
            oldState.replyingMessage != newState.replyingMessage;
      },
      builder: (context, state) {
        final borderStyle = OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mainIconGrey),
          borderRadius: BorderRadius.circular(14),
        );
        return Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.mainBgGrey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.replyingMessage != null)
                  _ShowReplyingMessageWidget(
                    onRemove: contactsCubit.removeReplyingMessage,
                    replyingMessage: state.replyingMessage!,
                  ),
                if (state.selectedImages != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: SizedBox(
                      height: supportChatPictureSize + 19,
                      child: _ShowTemporaryImagesWidget(
                        onRemove: contactsCubit.removeImage,
                        chatImages: state.selectedImages!,
                      ),
                    ),
                  ),
                SizedBox(
                  height: supportChatTextFieldHeight,
                  child: Row(
                    children: [
                      IconButton(
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.attach_file,
                          color: AppColors.mainBgOrange,
                          size: 30,
                        ),
                        onPressed: () async {
                          final recentImages = <AssetEntity>[];
                          final ps =
                              await PhotoManager.requestPermissionExtend();
                          if (ps.hasAccess) {
                            final galleries =
                                await PhotoManager.getAssetPathList(
                              onlyAll: true,
                              filterOption: FilterOptionGroup(
                                imageOption: const FilterOption(
                                  sizeConstraint:
                                      SizeConstraint(ignoreSize: true),
                                ),
                              ),
                            );
                            if (galleries.isNotEmpty) {
                              final path = galleries.first;
                              recentImages.addAll(
                                await path.getAssetListPaged(
                                  page: 0,
                                  size: 100,
                                ),
                              );
                            }
                          }
                          // ignore: use_build_context_synchronously
                          await showModalBottomSheet<void>(
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (_) {
                              return SelectFilesBottomSheet(
                                recentImages: recentImages,
                                parentContext: widget.parentContext,
                              );
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            textInputAction: TextInputAction.go,
                            controller: textEditingController,
                            maxLines: null,
                            cursorColor: AppColors.mainBgOrange,
                            onSubmitted: (_) {
                              contactsCubit
                                  .onSubmitted(textEditingController.text);
                              textEditingController.clear();
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Сообщение',
                              focusedBorder: borderStyle,
                              enabledBorder: borderStyle,
                              errorBorder: borderStyle,
                              disabledBorder: borderStyle,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        color: AppColors.mainBgOrange,
                        disabledColor: AppColors.mainIconGrey,
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.send,
                          size: 30,
                        ),
                        onPressed: textEditingController.text.isEmpty &&
                                state.selectedImages == null
                            ? null
                            : () {
                                contactsCubit
                                    .onSubmitted(textEditingController.text);
                                textEditingController.clear();
                              },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShowReplyingMessageWidget extends StatelessWidget {
  final Message replyingMessage;
  final void Function() onRemove;
  const _ShowReplyingMessageWidget({
    Key? key,
    required this.replyingMessage,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: supportChatReplyWidgetHeight,
          width: MediaQuery.of(context).size.width,
          color: AppColors.mainBgGrey,
          child: ListTile(
            leading: SizedBox(
              height: 60,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.reply,
                    color: AppColors.mainIconGrey,
                    size: 30,
                  ),
                  if (replyingMessage.images != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.memory(
                        replyingMessage.images!.first.byteImage!,
                        fit: BoxFit.fitHeight,
                        frameBuilder: (ctx, child, __, ___) {
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.circular(kMainBorderRadius / 3),
                            child: child,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.mainBgOrange,
                size: 30,
              ),
              onPressed: onRemove,
            ),
            title: Text(
              replyingMessage.username,
            ),
            subtitle: Text(
              replyingMessage.textMessage == ''
                  ? '${replyingMessage.images!.length} фотографии'
                  : replyingMessage.textMessage,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        const Divider(
          color: AppColors.mainIconGrey,
          height: supportChatDividerHeight,
        ),
      ],
    );
  }
}

class _ShowTemporaryImagesWidget extends StatelessWidget {
  const _ShowTemporaryImagesWidget({
    Key? key,
    required this.onRemove,
    required this.chatImages,
  }) : super(key: key);

  final void Function(int) onRemove;
  final List<ChatImage> chatImages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.memory(
              chatImages[index].byteImage!,
              fit: BoxFit.cover,
              width: supportChatPictureSize,
              height: supportChatPictureSize,
              frameBuilder: (ctx, child, __, ___) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(kMainBorderRadius / 4),
                      child: Hero(
                        tag: '${chatImages[index].imageId!}image_in_panel',
                        child: GestureDetector(
                          child: child,
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              transitionDuration:
                                  const Duration(milliseconds: 100),
                              pageBuilder: (_, __, ___) {
                                return FullScreenImage(
                                  chatImages: chatImages,
                                  selectedImageIndex: index,
                                  imageIn: ImageIn.panel,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          onRemove(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.mainIconGrey,
                                  shape: BoxShape.circle,
                                ),
                                width: 20,
                                height: 20,
                              ),
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      right: 5,
                      top: 0,
                    )
                  ],
                );
              },
            ),
            const Divider(
              color: AppColors.mainIconGrey,
              height: supportChatDividerHeight,
            )
          ],
        ),
      ),
      itemCount: chatImages.length,
    );
  }
}
