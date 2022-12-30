import 'dart:async';
import 'dart:typed_data';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart'
    as dodo_clone_repository;
import 'package:uuid/uuid.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final dodo_clone_repository.PersonRepository _personRepository;

  ContactsCubit(
    this._personRepository,
  ) : super(ContactsState(messages: const [])) {
    _init();
  }

  void changeFloatingButtonStatus({required bool enabled}) {
    return emit(state.copyWith(shouldShowFloatingButton: enabled));
  }

  Future<void> _init() async {
    await _getMessagesFromBd();
    _personRepository.messageStream.listen((repositoryMessage) async {
      final messages = List.of(state.messages);
      final message = Message.fromRepository(repositoryMessage);

      ///Добавляем новое сообщение от саппорта или (если отправитель юзер)
      ///меняем локальное сообщение на сообщение из базы
      if (!messages.containsId(message.messageId)) {
        final updatedTempMessagesWithReply =
            _updatedMessagesWithReply(messages..add(message));

        ///Сообщение от саппорта
        if (message.userId != (await _personRepository.person).id) {
          return emit(state.copyWith(messages: updatedTempMessagesWithReply));
        }

        ///Находит индекс первого локального сообщения юзера с теми же полями
        final localMessageIndex =
            updatedTempMessagesWithReply.localIndexOf(message);
        if (localMessageIndex == -1) {
          updatedTempMessagesWithReply.removeLast();
          return;
        }
        updatedTempMessagesWithReply.removeAt(localMessageIndex);
        return emit(state.copyWith(messages: updatedTempMessagesWithReply));
      } else if (message.isWatched) {
        ///Если сообщение уже на экране, значит оно было просмотренно.
        ///Следовательно меняем все предыдущие сообщения на просмотренные
        final indexRead = messages
            .indexWhere((element) => element.messageId == message.messageId);
        messages[indexRead] = message.copyWith(isWatched: true);
        emit(state.copyWith(messages: _updatedMessagesWithReply(messages)));
        markRead();
      }
    });
  }

  Future<void> _getMessagesFromBd() async {
    final messages = (await _personRepository.readMessages())
        ?.map(Message.fromRepository)
        .toList();
    if (messages == null || messages.isEmpty) {
      return emit(state.copyWith(messagesState: MessagesState.empty));
    }
    return emit(
      state.copyWith(
        messages: _updatedMessagesWithReply(messages),
        messagesState: MessagesState.data,
      ),
    );
  }

  void markRead({Message? message}) {
    if (state.messages.isNotEmpty) {
      _personRepository
          .markReadBefore(message?.messageId ?? state.messages.last.messageId);
    }
  }

  ///Обновляем все загруженные сообщения, которые хранят в себе ответ, на уже загруженное сообщение
  List<Message> _updatedMessagesWithReply(List<Message> messages) {
    final messagesWithReplyFromRepo = (_personRepository.messages)
        .where((element) => element.replyingMessageId != null)
        .toList();
    final stateMessages = List<Message>.of(messages);
    for (var i = 0; i < messagesWithReplyFromRepo.length; i++) {
      ///Индекс сообщения на которое ответили
      final indexMentionedMessage = stateMessages.indexWhere(
        (stateMessage) =>
            messagesWithReplyFromRepo[i].replyingMessageId ==
            stateMessage.messageId,
      );
      if (indexMentionedMessage != -1) {
        ///Индекс сообщения, которое содержит ответ
        final indexMessageWithReply = stateMessages.indexWhere(
          (stateMessage) =>
              stateMessage.messageId == messagesWithReplyFromRepo[i].messageId,
        );
        stateMessages[indexMessageWithReply] =
            stateMessages[indexMessageWithReply].copyWith(
          replyingMessage: stateMessages[indexMentionedMessage],
        );
      } else {
        ///Сообщение еще не было загружено
      }
    }
    return stateMessages;
  }

  Future<void> onSubmitted(String text) async {
    final person = await _personRepository.person;
    final message = Message.local(
      userId: person.id,
      textMessage: text,
      images: state.selectedImages,
      replyingMessage: state.replyingMessage,
      username: person.name,
    );
    return onSendMessage(message);
  }

  Future<void> onSendMessage(Message message) async {
    final person = await _personRepository.person;
    if (message.textMessage == '' && message.images == null) {
      return;
    }
    if (person.activeChatId == null) {
      if (!(await _personRepository.createChat())) {
        return;
      }
    }

    ///Если мы отправляем первое сообщение
    if (state.messagesState == MessagesState.empty) {
      emit(state.copyWith(messagesState: MessagesState.data));
    }
    unawaited(
      _personRepository.uploadMessage(message.toRepository()).then((sent) {
        ///Если сообщение не было отправлено, помечаем его как сообщение с ощибкой
        if (!sent) {
          emit(
            state.updateAfterSubmit(
              localMessage: message.error,
            ),
          );
        }
      }),
    );
    return emit(state.updateAfterSubmit(localMessage: message.local));
  }

  void onDeleteErrorMessage(Message message) {
    final messages = List<Message>.of(state.messages);
    final indexToRemove = messages.localLastIndexOf(message);
    messages.removeAt(indexToRemove);
    return emit(state.copyWith(messages: messages));
  }

  ///Добавляет картинку из галереи на панель выбранных картинок над текстовым полем
  Future<void> addImages({
    required List<dodo_clone_repository.ChatImage> chatImages,
  }) async {
    for (var i = 0; i < chatImages.length; i++) {
      if (chatImages[i].imageId == null) {
        chatImages[i] = chatImages[i].copyWith(imageId: const Uuid().v4());
      }
    }
    final images = state.selectedImages == null
        ? <dodo_clone_repository.ChatImage>[]
        : List<dodo_clone_repository.ChatImage>.of(state.selectedImages!)
      ..addAll(chatImages);
    return emit(state.copyWith(selectedImages: images));
  }

  void removeImage(int index) {
    return emit(state.deleteImage(index));
  }

  ///Добавляет сообщение, на которое отвечает, на панель над текстовым поелм
  void addReplyingMessage() {
    emit(
      state.copyWith(replyingMessage: state.messages.selectedMessage),
    );
    removeSelection();
  }

  void removeReplyingMessage() {
    return emit(state.deleteReply());
  }

  ///Странные вещи из за reversed listView
  void selectMessage(int index) {
    final messages = List<Message>.of(state.messages.reversed.toList());
    final prevSelectedIndex =
        messages.indexWhere((element) => element.selected);
    if (prevSelectedIndex != -1) {
      messages[prevSelectedIndex] =
          messages[prevSelectedIndex].copyWith(selected: false);
    }
    messages[index] = messages[index].copyWith(selected: true);
    return emit(state.copyWith(messages: messages.reversed.toList()));
  }

  void removeSelection() {
    final messages = List<Message>.of(state.messages.reversed.toList());
    final selectedIndex = messages.indexWhere((element) => element.selected);
    if (selectedIndex != -1) {
      messages[selectedIndex] =
          messages[selectedIndex].copyWith(selected: false);
    }
    return emit(state.copyWith(messages: messages.reversed.toList()));
  }

  List<Message> searchedMessages(String content) {
    return state.messages
        .where(
          (element) =>
              element.textMessage.toLowerCase().contains(content.toLowerCase()),
        )
        .toList();
  }

  List<dodo_clone_repository.ChatImage> get chatImages =>
      _personRepository.images;

  Uint8List getImage(String imageId) {
    final image = _personRepository.images
        .firstWhere((chatImage) => chatImage.imageId == imageId);
    return image.byteImage!;
  }

  void onDisposed({ChatState chatState = ChatState.disabled}) {
    // ignore: avoid_bool_literals_in_conditional_expressions
    final shouldShowFloatingButton = chatState == ChatState.disabled
        ? false
        : state.shouldShowFloatingButton;
    return emit(
      state.copyWith(
        shouldShowFloatingButton: shouldShowFloatingButton,
        chatState: chatState,
      ),
    );
  }

  Future<void> initChat() async {
    await _personRepository.initChat();
    return emit(state.copyWith(chatState: ChatState.active));
  }

  void updateInternetStatus({required bool hasInternet}) {
    return emit(state.copyWith(hasInternet: hasInternet));
  }
}
