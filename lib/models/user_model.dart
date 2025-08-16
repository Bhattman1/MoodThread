// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? email;
  final String? username;
  final String? avatar;
  final DateTime createdAt;
  final bool isAnonymous;
  final DateTime? lastActive;

  UserModel({
    required this.id,
    this.email,
    this.username,
    this.avatar,
    required this.createdAt,
    required this.isAnonymous,
    this.lastActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'],
      username: map['username'],
      avatar: map['avatar'],
      // TODO: Re-enable Firebase Timestamp handling after fixing initialization issues
      // createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdAt: map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.now(),
      isAnonymous: map['isAnonymous'] ?? true,
      // lastActive: map['lastActive'] != null 
      //     ? (map['lastActive'] as Timestamp).toDate() 
      //     : null,
      lastActive: map['lastActive'] is DateTime 
          ? map['lastActive'] 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'createdAt': createdAt,
      'isAnonymous': isAnonymous,
      'lastActive': lastActive,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    DateTime? createdAt,
    bool? isAnonymous,
    DateTime? lastActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
