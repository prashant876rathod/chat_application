import 'dart:convert';

class RecieverResponse {
  List<Comment>? comments;
  int? total;
  int? skip;
  int? limit;

  RecieverResponse({
    this.comments,
    this.total,
    this.skip,
    this.limit,
  });

  factory RecieverResponse.fromRawJson(String str) => RecieverResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecieverResponse.fromJson(Map<String, dynamic> json) => RecieverResponse(
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class Comment {
  int? id;
  String? body;
  int? postId;
  int? likes;
  User? user;

  Comment({
    this.id,
    this.body,
    this.postId,
    this.likes,
    this.user,
  });

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    body: json["body"],
    postId: json["postId"],
    likes: json["likes"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "body": body,
    "postId": postId,
    "likes": likes,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? username;
  String? fullName;

  User({
    this.id,
    this.username,
    this.fullName,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    fullName: json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "fullName": fullName,
  };
}
