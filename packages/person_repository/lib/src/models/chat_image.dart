import 'dart:convert';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class ChatImage {
  final String? imageId;
  final Uint8List? byteImage;
  const ChatImage._({this.imageId, this.byteImage})
      : assert(byteImage != null || imageId != null);

  factory ChatImage.fromJson(
      {required String imageId, required dynamic jsonImage}) {
    final byteImage =
        Uint8List.fromList((jsonDecode(jsonImage) as List).cast<int>());
    return ChatImage._(imageId: imageId, byteImage: byteImage);
  }

  factory ChatImage.fromState({required Uint8List byteImage}) {
    return ChatImage._(byteImage: byteImage);
  }

  factory ChatImage.fromBd({required String imageId}) {
    return ChatImage._(imageId: imageId);
  }

  ChatImage copyWith({String? imageId}) {
    return ChatImage._(
      imageId: imageId ?? this.imageId,
      byteImage: byteImage,
    );
  }

  bool equals(ChatImage chatImage) {
    final bool Function(List<int>?, List<int>?) eq =
        const ListEquality<int>().equals;
    return eq(chatImage.byteImage, byteImage) && (chatImage.imageId == imageId);
  }
}

extension ChatImagesEquals on List<ChatImage>? {
  bool equals(List<ChatImage>? chatImages) {
    if (chatImages?.length != this?.length ||
        this == null ||
        chatImages == null) {
      return false;
    }
    for (var i = 0; i < this!.length; i++) {
      if (chatImages[i].equals(this![i])) return false;
    }
    return true;
  }
}

extension AddChatImage on List<ChatImage> {
  bool addImage(ChatImage chatImage) {
    for (final image in this) {
      if (image.imageId == chatImage.imageId) {
        return false;
      }
    }
    add(chatImage);
    return true;
  }

  void addAllImages(Iterable<ChatImage> chatImages) {
    for (final imageToAdd in chatImages) {
      bool ableToAdd = true;
      for (final image in this) {
        if (image.imageId == imageToAdd.imageId) {
          ableToAdd = false;
          break;
        }
      }
      if (ableToAdd) addImage(imageToAdd);
    }
  }
}
