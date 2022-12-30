import 'dart:async';

import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:dodo_clone/src/features/contacts/ui/widgets/chat_images_grid_view.dart';
import 'package:flutter/material.dart';

const _timeTextWidth = 40.0;
const _checkedIconWidth = 17.0;

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool fromCustomer;
  final EdgeInsets margin;
  final EdgeInsets replyPadding;
  final EdgeInsets padding;
  final EdgeInsets imagePadding;
  final double replySize;
  final FutureOr<void> Function(String id, bool fromSearch)
      onReplyingMessageTap;
  final void Function(int imageIndex)? onImageTap;
  final void Function(Message message)? onDelete;
  final void Function(Message message)? onReSendMessage;
  const MessageWidget({
    required this.fromCustomer,
    required this.message,
    required this.onReplyingMessageTap,
    this.margin = EdgeInsets.zero,
    this.replyPadding = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.imagePadding = EdgeInsets.zero,
    this.replySize = 60,
    this.onImageTap,
    this.onDelete,
    this.onReSendMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = message.textMessage.split(' ');
    final wordWithPadding = words[words.length - 1];
    var otherWords = '';
    if (words.length > 1) {
      otherWords = words.sublist(0, words.length - 1).join(' ');
      otherWords += ' ';
    }
    late final double timeWidgetWidth;
    if (fromCustomer) {
      timeWidgetWidth = _timeTextWidth + _checkedIconWidth;
    } else {
      timeWidgetWidth = _timeTextWidth;
    }

    return Align(
      alignment: fromCustomer ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: margin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.isError)
              SendErrorWidget(
                onDelete: onDelete,
                message: message,
                onReSend: onReSendMessage,
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
                minWidth: MediaQuery.of(context).size.width * 0.23,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kMainBorderRadius),
                color:
                    fromCustomer ? Colors.grey.shade400 : AppColors.mainBgGrey,
              ),
              child: Stack(
                textDirection: TextDirection.ltr,
                children: [
                  Padding(
                    padding: padding,
                    child: Wrap(
                      children: [
                        if (message.replyingMessage != null)
                          Padding(
                            padding: replyPadding,
                            child: ReplyingMessage(
                              onTap: () {
                                onReplyingMessageTap(
                                  message.replyingMessage!.messageId,
                                  false,
                                );
                              },
                              fromSupport: !fromCustomer,
                              // parentContext
                              //         .read<ProfileBloc>()
                              //         .state
                              //         .person
                              //         .id !=
                              //     message.userId,
                              replyingMessage: message.replyingMessage!,
                              replySize: replySize,
                            ),
                          ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: fromCustomer ? Colors.white : Colors.black,
                            ),
                            children: [
                              TextSpan(text: otherWords),
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: timeWidgetWidth * 1.3,
                                  ),
                                  child: Text(
                                    wordWithPadding,
                                    style: TextStyle(
                                      color: fromCustomer
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (message.images != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: ChatImagesGridView(
                              images: message.images!,
                              onImageTap: onImageTap,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 6,
                    child: SizedBox(
                      width: timeWidgetWidth,
                      child: message.isLocal
                          ? Container(
                              alignment: Alignment.bottomRight,
                              width: 9,
                              height: 9,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: const FittedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.mainIconGrey,
                                  ),
                                ),
                              ),
                            )
                          : Wrap(
                              children: [
                                Text(
                                  message.createdAt.hoursMinutesFormat,
                                  style: const TextStyle(
                                    color: AppColors.mainIconGrey,
                                  ),
                                ),
                                if (fromCustomer && !message.isError)
                                  Icon(
                                    message.isWatched
                                        ? Icons.done_all
                                        : Icons.check,
                                    color: AppColors.mainIconGrey,
                                    size: 17,
                                  ),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendErrorWidget extends StatelessWidget {
  final void Function(Message message)? onDelete;
  final void Function(Message message)? onReSend;
  final Message message;
  const SendErrorWidget({
    Key? key,
    required this.onDelete,
    required this.message,
    required this.onReSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Icon(
          Icons.error,
          color: AppColors.mainRed,
          size: 20,
        ),
      ),
      onTap: () {
        showModalBottomSheet<void>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          context: context,
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Повторить отправку',
                    style: TextStyle(color: AppColors.mainTextOrange),
                  ),
                  leading: const Icon(
                    Icons.send,
                    color: AppColors.mainBgOrange,
                  ),
                  onTap: () {
                    if (onReSend != null && onDelete != null) {
                      onDelete!(message);
                      onReSend!(message);
                    }
                    AppRouter.instance().popTop();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Удалить',
                    style: TextStyle(
                      color: AppColors.mainTextOrange,
                    ),
                  ),
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppColors.mainBgOrange,
                  ),
                  onTap: () {
                    if (onDelete != null) {
                      onDelete!(message);
                    }
                    AppRouter.instance().popTop();
                  },
                ),
              ],
            );
          },
        ).then(
          (value) => FocusManager.instance.primaryFocus?.unfocus(),
        );
      },
    );
  }
}

class ReplyingMessage extends StatelessWidget {
  final Message replyingMessage;
  final double replySize;
  final void Function() onTap;
  final bool fromSupport;
  const ReplyingMessage({
    Key? key,
    required this.replyingMessage,
    required this.replySize,
    required this.onTap,
    required this.fromSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: replySize,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalDivider(
                color: AppColors.mainBgOrange,
                thickness: 3,
              ),
              if (replyingMessage.images != null)
                Image.memory(
                  replyingMessage.images!.first.byteImage!,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  frameBuilder: (ctx, child, __, ___) {
                    return ClipRRect(
                      borderRadius:
                          BorderRadius.circular(kMainBorderRadius / 3),
                      child: child,
                    );
                  },
                ),
            ],
          ),
          title: Text(
            replyingMessage.username,
            style: TextStyle(color: fromSupport ? Colors.black : Colors.white),
          ),
          subtitle: Text(
            replyingMessage.textMessage == ''
                ? '${replyingMessage.images!.length} фотографии'
                : replyingMessage.textMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: fromSupport ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
