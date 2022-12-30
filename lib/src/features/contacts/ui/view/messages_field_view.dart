import 'dart:async';

import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/ui/utils/constants.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/full_screen_image.dart';
import 'package:dodo_clone/src/features/contacts/ui/widgets/widgets.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesFieldWidget extends StatefulWidget {
  final BuildContext parentContext;
  final ScrollController scrollController;
  final FutureOr<void> Function(String id, bool fromSearch)
      animateToSpecificMessage;
  const MessagesFieldWidget({
    required this.parentContext,
    Key? key,
    required this.scrollController,
    required this.animateToSpecificMessage,
  }) : super(key: key);

  @override
  State<MessagesFieldWidget> createState() => _MessagesFieldWidgetState();
}

class _MessagesFieldWidgetState extends State<MessagesFieldWidget> {
  late final ScrollController controller;
  @override
  void initState() {
    controller = widget.scrollController;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.hasClients &&
          !widget.parentContext
              .read<ContactsCubit>()
              .state
              .shouldShowFloatingButton) {
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.parentContext.read<ContactsCubit>().onDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      buildWhen: (oldState, newState) {
        if (oldState.messages.length != newState.messages.length) {
          Future<void>.delayed(
            const Duration(milliseconds: 300),
            () {
              if (controller.hasClients) {
                if (controller.position.pixels == controller.position.pixels &&
                    newState.chatState == ChatState.active) {
                  context
                      .read<ContactsCubit>()
                      .markRead(message: newState.messages.last);
                }
                controller.jumpTo(controller.position.maxScrollExtent);
              }
            },
          ); //не скролится так как сначала происходит скрол, а потом добавление
        }
        return true;
      },
      bloc: BlocProvider.of<ContactsCubit>(widget.parentContext),
      builder: (context, state) {
        if (state.messagesState == MessagesState.data) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: supportChatTextFieldHeight +
                  (state.selectedImages == null
                      ? 0
                      : supportChatPictureSize + supportChatDividerHeight) +
                  (state.replyingMessage == null
                      ? 0
                      : supportChatReplyWidgetHeight +
                          supportChatDividerHeight),
            ),

            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: List.generate(
                  state.messages.length,
                  (index) => _BuildMessageBloc(
                    index: state.messages.length - index - 1,
                    parentContext: widget.parentContext,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    onReplyingMessageTap: widget.animateToSpecificMessage,
                  ),
                ),
              ),
            ),
          );
        } else if (state.messagesState == MessagesState.empty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FlutterLogo(
                size: 200,
              ),
              Text(
                'Напишите нам',
                textAlign: TextAlign.center,
                textScaleFactor: 2,
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}

class _BuildMessageBloc extends StatelessWidget {
  const _BuildMessageBloc({
    Key? key,
    required this.index,
    required this.parentContext,
    required this.margin,
    required this.onReplyingMessageTap,
  }) : super(key: key);

  final int index;
  final BuildContext parentContext;
  final EdgeInsets margin;
  final FutureOr<void> Function(String id, bool fromSearch)
      onReplyingMessageTap;

  @override
  Widget build(BuildContext context) {
    final contactsCubit = parentContext.read<ContactsCubit>();
    return BlocBuilder<ContactsCubit, ContactsState>(
      bloc: BlocProvider.of(parentContext),
      builder: (context, state) {
        final person = parentContext.read<ProfileBloc>().state.person;
        final messages = state.messages.reversed.toList();
        final fromCustomer = messages[index].userId == person.id;
        return Column(
          children: [
            if (index == messages.length - 1 ||
                (index != messages.length - 1 &&
                    messages[index].createdAt.dayMonthYearFormat !=
                        messages[index + 1].createdAt.dayMonthYearFormat))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(messages[index].createdAt.dayMonthYearFormat),
              ),
            Padding(
              key: messages[index].globalKey,
              padding: margin,
              child: GestureDetector(
                onLongPress: () {
                  contactsCubit.selectMessage(index);
                },
                child: ColoredBox(
                  color: messages[index].selected
                      ? AppColors.mainIconGrey
                      : Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!fromCustomer)
                        if (index == 0 ||
                            messages[index - 1].userId == person.id)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.mainBgOrange,
                              ),
                            ),
                          )
                        else
                          const SizedBox(
                            width: 38, //leftPadding + circleSize
                          ),
                      Expanded(
                        child: MessageWidget(
                          message: messages[index],
                          fromCustomer: fromCustomer,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          replyPadding: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          imagePadding:
                              const EdgeInsets.only(bottom: 17, top: 5),
                          onReplyingMessageTap: onReplyingMessageTap,
                          onDelete: contactsCubit.onDeleteErrorMessage,
                          onReSendMessage: contactsCubit.onSendMessage,
                          onImageTap: (imageIndex) {
                            showGeneralDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              transitionDuration:
                                  const Duration(milliseconds: 100),
                              pageBuilder: (_, __, ___) {
                                return FullScreenImage(
                                  chatImages: messages[index].images!,
                                  selectedImageIndex: imageIndex,
                                  imageIn: ImageIn.chat,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
