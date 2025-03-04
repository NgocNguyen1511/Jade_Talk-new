enum FriendViewType {
  friends,
  friendRequests,
  groupView,
}

enum MessageEnum {
  text,
  audio,
  image,
  video,
}

// extension convertMessageEnumToString on String
extension MessageEnumExtension on String {
  MessageEnum toMessageEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'image':
        return MessageEnum.image;
      case 'video':
        return MessageEnum.video;
      case 'audio':
        return MessageEnum.audio;
      default:
        return MessageEnum.text;
    }
  }
}

enum GroupType {
  private,
  public,
}
