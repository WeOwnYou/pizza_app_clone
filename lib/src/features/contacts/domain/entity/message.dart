import 'package:flutter/cupertino.dart';
import 'package:person_repository/person_repository.dart' as person_repository
    show Message, ChatImage;

enum MessageStatus { local, error, active }

class Message {
  final String username;
  final int userId;
  final String textMessage;
  final DateTime createdAt;
  final bool isWatched;
  final String messageId;
  final List<person_repository.ChatImage>? images;
  final Message? replyingMessage;
  final bool selected;
  final GlobalKey globalKey;
  final MessageStatus status;

  Message({
    required this.userId,
    required this.textMessage,
    required this.createdAt,
    required this.messageId,
    required this.username,
    required this.status,
    this.images,
    this.isWatched = false,
    this.selected = false,
    this.replyingMessage,
  }) : globalKey = GlobalKey();

  bool get isLocal => status == MessageStatus.local;
  bool get isError => status == MessageStatus.error;

  factory Message.fromRepository(person_repository.Message message) {
    return Message(
      status: MessageStatus.active,
      username: message.username,
      userId: message.userId,
      textMessage: message.message,
      createdAt: message.createdAt,
      isWatched: message.isWatched,
      messageId: message.messageId,
      images: message.images,
    );
  }

  factory Message.local({
    required String username,
    required int userId,
    required String textMessage,
    List<person_repository.ChatImage>? images,
    Message? replyingMessage,
  }) {
    final dateTime = DateTime.now();
    return Message(
      status: MessageStatus.local,
      userId: userId,
      textMessage: textMessage,
      createdAt: dateTime,
      messageId: '${dateTime.microsecondsSinceEpoch}',
      username: username,
      images: images,
      replyingMessage: replyingMessage,
    );
  }

  person_repository.Message toRepository() {
    return person_repository.Message(
      createdAt: DateTime.now(),
      message: textMessage,
      userId: userId,
      isWatched: isWatched,
      messageId: messageId,
      images: images,
      replyingMessageId: replyingMessage?.messageId,
      username: username,
    );
  }

  ///Сравнивает все поля кроме [messageId] и [createdAt].
  ///Так как они равноценны и завият от реального времени часового пояса,
  /// а приходящие сообщения с сервера имеют отличное время
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! Message) return false;
    if (identical(this, other)) return true;
    if (userId == other.userId &&
        textMessage == other.textMessage &&
        username == other.username &&
        isWatched == other.isWatched) {
      if (images?.length != other.images?.length || images?.length == null) {
        return true;
      }
      for (var j = 0; j < (images?.length ?? -1); j++) {
        if (!other.images![j].equals(images![j])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      username.hashCode ^
      userId.hashCode ^
      textMessage.hashCode ^
      createdAt.hashCode ^
      isWatched.hashCode ^
      messageId.hashCode ^
      images.hashCode ^
      replyingMessage.hashCode ^
      selected.hashCode ^
      globalKey.hashCode;

  @override
  String toString() {
    return 'Message{ message: $textMessage, id: $messageId, $status }'; //, createdAt: $createdAt, reply: $replyingMessage}';
  }

  Message copyWith({
    int? userId,
    String? username,
    String? textMessage,
    DateTime? createdAt,
    bool? isWatched,
    bool? selected,
    Message? replyingMessage,
    String? messageId,
    MessageStatus? status,
  }) {
    return Message(
      status: status ?? this.status,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      textMessage: textMessage ?? this.textMessage,
      createdAt: createdAt ?? this.createdAt,
      isWatched: isWatched ?? this.isWatched,
      messageId: messageId ?? this.messageId,
      images: images,
      selected: selected ?? this.selected,
      replyingMessage: replyingMessage ?? this.replyingMessage,
    );
  }

  Message updateTime() => copyWith(createdAt: DateTime.now());
  Message get local => copyWith(status: MessageStatus.local);
  Message get error => copyWith(status: MessageStatus.error);
}

extension MessageInfo on List<Message> {
  bool containsId(String messageId) {
    var containId = false;
    forEach((element) {
      if (element.messageId == messageId) {
        containId = true;
      }
    });
    return containId;
  }

  bool get selectionApplied {
    return indexWhere((element) => element.selected) != -1;
  }

  Message get selectedMessage {
    return firstWhere((element) => element.selected);
  }

  List<Message> unreadMessages(int personId) {
    final messages =
        where((element) => (element.userId != personId) && !element.isWatched)
            .toList();
    return messages;
  }

  bool equals(List<Message> messages) {
    if (messages.length != length) return false;
    for (var i = 0; i < length; i++) {
      if (this[i] != messages[i]) return false;
    }
    return true;
  }

  int localIndexOf(Message message) {
    for (var i = 0; i < length; i++) {
      final element = this[i];
      if (element == message && (element.isLocal || element.isError)) {
        return i;
      }
    }
    return -1;
    // return indexWhere(
    //   (element) =>
    //       (element == message) && (element.isLocal || element.isError),
    // );
  }

  int localLastIndexOf(Message message) {
    for (var i = length - 1; i >= 0; i--) {
      final element = this[i];
      if (element.messageId == message.messageId &&
          (element.isLocal || element.isError)) {
        return i;
      }
    }
    return -1;
    // return lastIndexWhere(
    //   (element) =>
    //       (element == message) && (element.isLocal || element.isError),
    // );
  }
}
