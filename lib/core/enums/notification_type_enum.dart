enum NotificationType {
  comment('comment'),
  reply('reply'),
  like('like'),
  follow('follow');

  final String type;
  const NotificationType(this.type);
}

extension ConvertPost on String {
  NotificationType toNotificationTypeEnum() {
    switch (this) {
      case 'comment':
        return NotificationType.comment;
      case 'reply':
        return NotificationType.reply;
      case 'like':
        return NotificationType.like;
      case 'follow':
        return NotificationType.follow;
      default:
        return NotificationType.like;
    }
  }
}
