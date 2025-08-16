import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadResponseModel {
  final String id;
  final String userId;
  final String promptId;
  final String response;
  final DateTime createdAt;
  final bool isAnonymous;
  final String? username;
  final String? avatar;
  final int sameCount;

  ThreadResponseModel({
    required this.id,
    required this.userId,
    required this.promptId,
    required this.response,
    required this.createdAt,
    required this.isAnonymous,
    this.username,
    this.avatar,
    this.sameCount = 0,
  });

  factory ThreadResponseModel.fromMap(Map<String, dynamic> map) {
    return ThreadResponseModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      promptId: map['promptId'] ?? '',
      response: map['response'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isAnonymous: map['isAnonymous'] ?? true,
      username: map['username'],
      avatar: map['avatar'],
      sameCount: map['sameCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'promptId': promptId,
      'response': response,
      'createdAt': createdAt,
      'isAnonymous': isAnonymous,
      'username': username,
      'avatar': avatar,
      'sameCount': sameCount,
    };
  }

  ThreadResponseModel copyWith({
    String? id,
    String? userId,
    String? promptId,
    String? response,
    DateTime? createdAt,
    bool? isAnonymous,
    String? username,
    String? avatar,
    int? sameCount,
  }) {
    return ThreadResponseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      promptId: promptId ?? this.promptId,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      sameCount: sameCount ?? this.sameCount,
    );
  }
}
