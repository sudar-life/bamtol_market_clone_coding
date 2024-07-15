import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel extends Equatable {
  final String? text;
  final DateTime? createdAt;
  final String? uid;

  const ChatModel({
    this.text,
    this.uid,
    this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toMap() => _$ChatModelToJson(this);

  @override
  List<Object?> get props => [
        text,
        createdAt,
        uid,
      ];
}
