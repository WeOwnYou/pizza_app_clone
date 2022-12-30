part of 'contacts_cubit.dart';

enum MessagesState { loading, data, empty }

enum ChatState { active, paused, disabled } ///активный, свернутый, диспоженный

class ContactsState {
  final List<Message> messages;
  final List<dodo_clone_repository.ChatImage>? selectedImages;
  final Message? replyingMessage;
  final bool shouldShowFloatingButton;
  final MessagesState messagesState;
  final ChatState chatState;
  final bool hasInternet;
  ContactsState({
    required this.messages,
    List<dodo_clone_repository.ChatImage>? selectedImages,
    this.shouldShowFloatingButton = false,
    this.replyingMessage,
    this.messagesState = MessagesState.loading,
    this.chatState = ChatState.disabled,
    this.hasInternet = false,
  }) : selectedImages =
            (selectedImages?.isEmpty ?? true) ? null : selectedImages;

  ContactsState updateAfterSubmit({required Message localMessage}) {
    final newMessages = List<Message>.of(messages);
    final index = newMessages.localLastIndexOf(localMessage);
    if (index == -1) {
      ///Новое локальное сообщение
      newMessages.add(localMessage.updateTime());
    } else if(localMessage.isError){
      ///Сообщение с ошибкой
      newMessages[index] = localMessage.updateTime();
    }else{
      ///Совпадающее локальное сообщение с чем либо
      newMessages.add(localMessage.updateTime());
    }
    return ContactsState(
      messages: newMessages,
      shouldShowFloatingButton: shouldShowFloatingButton,
      messagesState: messagesState,
      chatState: chatState,
      hasInternet: hasInternet,
    );
  }

  ContactsState deleteImage(int index) {
    final images = List<dodo_clone_repository.ChatImage>.of(selectedImages!)
      ..removeAt(index);
    return ContactsState(
      messages: messages,
      shouldShowFloatingButton: shouldShowFloatingButton,
      replyingMessage: replyingMessage,
      messagesState: messagesState,
      chatState: chatState,
      selectedImages: images.isEmpty ? null : images,
      hasInternet: hasInternet,
    );
  }

  ContactsState deleteReply() {
    return ContactsState(
      messages: messages,
      shouldShowFloatingButton: shouldShowFloatingButton,
      messagesState: messagesState,
      selectedImages: selectedImages,
      chatState: chatState,
      hasInternet: hasInternet,
    );
  }

  ContactsState copyWith({
    List<Message>? messages,
    List<dodo_clone_repository.ChatImage>? selectedImages,
    bool? shouldShowFloatingButton,
    Message? replyingMessage,
    MessagesState? messagesState,
    ChatState? chatState,
    bool? hasInternet,
  }) {
    return ContactsState(
      messages: messages ?? this.messages,
      selectedImages: selectedImages ??
          ((this.selectedImages?.isEmpty ?? false)
              ? null
              : this.selectedImages),
      shouldShowFloatingButton:
          shouldShowFloatingButton ?? this.shouldShowFloatingButton,
      replyingMessage: replyingMessage ?? this.replyingMessage,
      messagesState: messagesState ?? this.messagesState,
      chatState: chatState ?? this.chatState,
      hasInternet: hasInternet ?? this.hasInternet,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! ContactsState) return false;
    if (identical(this, other)) return true;
    if (!other.messages.equals(messages)) return false;
    if (!other.selectedImages.equals(other.selectedImages)) return false;
    if (replyingMessage == other.replyingMessage &&
        shouldShowFloatingButton == other.shouldShowFloatingButton &&
        messagesState == other.messagesState &&
        chatState == other.chatState &&
        hasInternet == other.hasInternet) return true;
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      messages.hashCode ^
      selectedImages.hashCode ^
      replyingMessage.hashCode ^
      shouldShowFloatingButton.hashCode ^
      messagesState.hashCode ^
      chatState.hashCode ^
      hasInternet.hashCode;
}
