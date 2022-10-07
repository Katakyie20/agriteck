class CommentObject {
  String? id;
  String? senderId;
  String? postId;
  String? comment;
  int? createdAt;
  String? senderName;
  String? senderProfile;

  CommentObject({
    this.id,
    this.senderId,
    this.postId,
    this.comment,
    this.createdAt,
    this.senderName,
    this.senderProfile,
  });

  CommentObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    postId = json['postId'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    senderName = json['senderName'];
    senderProfile = json['senderProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['senderId'] = senderId;
    data['postId'] = postId;
    data['comment'] = comment;
    data['createdAt'] = createdAt;
    data['senderName'] = senderName;
    data['senderProfile'] = senderProfile;
    return data;
  }
}
