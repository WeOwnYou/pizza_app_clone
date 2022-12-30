import 'dart:math';

import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:dodo_clone/src/features/contacts/ui/utils/constants.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/search_dialog.dart';
import 'package:dodo_clone/src/features/contacts/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'messages_field_view.dart';

class SupportChatView extends StatefulWidget {
  final BuildContext parentContext;
  const SupportChatView({
    required this.parentContext,
    Key? key,
  }) : super(key: key);

  @override
  State<SupportChatView> createState() => _SupportChatViewState();
}

class _SupportChatViewState extends State<SupportChatView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    final contactsCubit = context.read<ContactsCubit>();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.pixels <=
            scrollController.position.maxScrollExtent - 50) {
          contactsCubit.markRead();
        }
        if (scrollController.position.pixels <=
            scrollController.position.maxScrollExtent - 50) {
          contactsCubit.changeFloatingButtonStatus(enabled: true);
        } else {
          contactsCubit.changeFloatingButtonStatus(enabled: false);
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contactsCubit = widget.parentContext.read<ContactsCubit>();
    return BlocBuilder<ContactsCubit, ContactsState>(
      buildWhen: (oldState, newState) {
        return newState.messages.isNotEmpty;
      },
      bloc: BlocProvider.of(widget.parentContext),
      builder: (context, state) {

        Future<void> animateToMessage(
          String messageId,
          bool fromSearch,
        ) async {
          if (fromSearch) await AppRouter.instance().popTop();
          final renderBox = state.messages
              .firstWhere((element) => element.messageId == messageId)
              .globalKey
              .currentContext
              ?.findRenderObject() as RenderBox?;
          if (renderBox == null) {
            return;
          }
          final widgetPosition = renderBox.localToGlobal(Offset.zero).dy;
          final widgetHeight = renderBox.size.height;
          // ignore: use_build_context_synchronously
          final height = MediaQuery.of(context).size.height;
          final bottomPadding = supportChatTextFieldHeight +
              (state.selectedImages == null
                  ? 0
                  : supportChatPictureSize + supportChatDividerHeight) +
              (state.replyingMessage == null
                  ? 0
                  : supportChatReplyWidgetHeight + supportChatDividerHeight) +
              // ignore: use_build_context_synchronously
              MediaQuery.of(context).viewInsets.bottom;
          await scrollController.animateTo(
            max(
              min(
                scrollController.position.maxScrollExtent,
                scrollController.position.pixels -
                    height +
                    widgetPosition +
                    bottomPadding +
                    widgetHeight,
              ),
              0,
            ),
            duration: AppAnimationDurations.scroll,
            curve: Curves.easeIn,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: WillPopScope(
            onWillPop: () async {
              if (state.messages.selectionApplied) {
                contactsCubit.removeSelection();
                return false;
              }
              return true;
            },
            child: FractionallySizedBox(
              heightFactor: 0.953,
              child: Scaffold(
                appBar: state.messages.selectionApplied
                    ? AppBar(
                        centerTitle: true,
                        foregroundColor: AppColors.mainBgOrange,
                        leading: IconButton(
                          onPressed: contactsCubit.removeSelection,
                          icon: Icon(Icons.adaptive.arrow_back),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.reply),
                              onPressed: contactsCubit.addReplyingMessage,
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: state
                                        .messages.selectedMessage.textMessage,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      )
                    : AppBar(
                        foregroundColor: Colors.black,
                        title: const Text('Додо чат'),
                        leading: IconButton(
                          icon: Icon(Icons.adaptive.arrow_back),
                          onPressed: Navigator.of(context).pop,
                        ),
                        actions: [
                          IconButton(
                            onPressed: () async {
                              await showGeneralDialog(
                                context: context,
                                barrierColor: Colors.black12
                                    .withOpacity(0.6), // Background color
                                barrierDismissible: false,
                                transitionDuration:
                                    const Duration(milliseconds: 400),
                                pageBuilder: (_, __, ___) {
                                  return SearchDialogView(
                                    parentContext: widget.parentContext,
                                    onSearchedMessageTap: animateToMessage,
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                body: Stack(
                  children: [
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          child: MessagesFieldWidget(
                            animateToSpecificMessage: animateToMessage,
                            parentContext: widget.parentContext,
                            scrollController: scrollController,
                          ),
                        )
                      ],
                    ),
                    TextFieldWidget(
                      parentContext: widget.parentContext,
                      scrollController: scrollController,
                    ),
                  ],
                ),
                floatingActionButton: state.shouldShowFloatingButton
                    ? Container(
                        height: 35,
                        margin: EdgeInsets.only(
                          bottom: 10 +
                              supportChatTextFieldHeight +
                              (state.selectedImages == null
                                  ? 0
                                  : supportChatPictureSize +
                                      supportChatDividerHeight) +
                              (state.replyingMessage == null
                                  ? 0
                                  : supportChatReplyWidgetHeight +
                                      supportChatDividerHeight),
                        ),
                        child: FloatingActionButton(
                          backgroundColor: AppColors.mainBgGrey,
                          onPressed: () {
                            if (scrollController.hasClients) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: AppAnimationDurations.scroll,
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.mainBgOrange,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
