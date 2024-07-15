import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? uid;
  final String? nickname;
  final double? temperature;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    this.uid,
    this.nickname,
    this.createdAt,
    this.updatedAt,
    this.temperature,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.create(String name, String uid) {
    return UserModel(
      nickname: name,
      uid: uid,
      temperature: Random().nextInt(100) + 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        uid,
        nickname,
        temperature,
        createdAt,
        updatedAt,
      ];
}
