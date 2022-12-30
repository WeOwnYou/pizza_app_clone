import 'package:equatable/equatable.dart';
import 'package:person_repository/src/models/chat_image.dart';

class Message extends Equatable {
  final int userId;
  final String username;
  final String message;
  final DateTime createdAt;
  final bool isWatched;
  final List<ChatImage>? images;
  final String messageId;
  final String? replyingMessageId;

  const Message({
    required this.userId,
    required this.message,
    required this.createdAt,
    required this.messageId,
    this.images,
    this.isWatched = false,
    this.replyingMessageId,
    required this.username,
  });

  @override
  List<Object?> get props => [messageId];

  @override
  String toString() {
    return 'Message{ idUser: $userId, message: $message, createdAt: $createdAt,}';
  }

  Message copyWith({
    int? userId,
    String? username,
    String? message,
    DateTime? createdAt,
    bool? isWatched,
    List<ChatImage>? images,
    String? messageId,
    Message? replyingMessage,
  }) {
    return Message(
      userId: userId ?? this.userId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isWatched: isWatched ?? this.isWatched,
      messageId: messageId ?? this.messageId,
      images: images ?? this.images,
      replyingMessageId: replyingMessageId,
      username: username ?? this.username,
    );
  }

  Message updateTime({required DateTime createdAt}) {
    return Message(
      userId: userId,
      message: message,
      createdAt: createdAt,
      isWatched: isWatched,
      messageId: messageId,
      images: images,
      replyingMessageId: replyingMessageId,
      username: username,
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    required String messageId,
  }) {
    final images = json['imageIds'] == null
        ? null
        : (json['imageIds'] as List)
            .cast<String>()
            .map<ChatImage>((imageId) => ChatImage.fromBd(imageId: imageId))
            .toList();
    final localDate = _localDate(
      timezoneOffsetString: json['timezoneOffset'],
      senderDatetime: DateTime.parse(json['createdAt'] as String),
    );
    return Message(
      userId: int.tryParse(json['userId']) ?? 0,
      message: json['textMessage'] as String,
      createdAt: localDate,
      isWatched: json['isWatched'] as bool,
      messageId: messageId,
      images: images,
      replyingMessageId: json['replyingMessageId'],
      username: json['username'] ?? 'Поддержка',
    );
  }

  ///Переводит любую дату, в дату локальную на устройстве
  static DateTime _localDate({
    required String timezoneOffsetString,
    required DateTime senderDatetime,
  }) {
    return senderDatetime
        .subtract(_parseDuration(timezoneOffsetString))
        .add(DateTime.now().timeZoneOffset);
  }

  static Duration _parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId.toString(),
      'textMessage': message.trim(),
      'createdAt': createdAt.toString(),
      'isWatched': false,
      'imageIds': images?.map((image) => image.imageId!),
      'replyingMessageId': replyingMessageId,
      'username': username,
      'timezoneOffset': createdAt.timeZoneOffset.toString(),
    };
  }
}
