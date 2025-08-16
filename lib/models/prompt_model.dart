// import 'package:cloud_firestore/cloud_firestore.dart';

class PromptModel {
  final String id;
  final String text;
  final DateTime date;
  final bool isActive;
  final int responseCount;
  final DateTime createdAt;

  PromptModel({
    required this.id,
    required this.text,
    required this.date,
    required this.isActive,
    this.responseCount = 0,
    required this.createdAt,
  });

  factory PromptModel.fromMap(Map<String, dynamic> map) {
    return PromptModel(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      // TODO: Re-enable Firebase Timestamp handling after fixing initialization issues
      // date: (map['date'] as Timestamp).toDate(),
      date: map['date'] is DateTime 
          ? map['date'] 
          : DateTime.now(),
      isActive: map['isActive'] ?? false,
      responseCount: map['responseCount'] ?? 0,
      // createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdAt: map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'isActive': isActive,
      'responseCount': responseCount,
      'createdAt': createdAt,
    };
  }

  PromptModel copyWith({
    String? id,
    String? text,
    DateTime? date,
    bool? isActive,
    int? responseCount,
    DateTime? createdAt,
  }) {
    return PromptModel(
      id: id ?? this.id,
      text: text ?? this.text,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
      responseCount: responseCount ?? this.responseCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
