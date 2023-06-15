enum CommentType {
  comment('comment'),
  reply_to_comment('reply_to_comment');

  final String type;
  const CommentType(this.type);
}

extension ConvertPost on String {
  CommentType toCommentTypeEnum() {
    switch (this) {
      case 'comment':
        return CommentType.comment;
      case 'reply_to_comment':
        return CommentType.reply_to_comment;
      default:
        return CommentType.comment;
    }
  }
}
