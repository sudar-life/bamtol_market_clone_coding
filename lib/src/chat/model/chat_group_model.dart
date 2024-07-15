import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_group_model.g.dart';

@JsonSerializable()
class ChatGroupModel extends Equatable {
  final List<String>? chatters;
  final String? owner;
  final String? productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatGroupModel({
    this.updatedAt,
    this.createdAt,
    this.productId,
    this.owner,
    this.chatters,
  });

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupModelFromJson(json);

  Map<String, dynamic> toMap() => _$ChatGroupModelToJson(this);

  int get chatCount {
    return chatters?.where((uid) => uid != owner).toList().length ?? 0;
  }

  ChatGroupModel copyWith({
    DateTime? updatedAt,
    DateTime? createdAt,
    String? productId,
    String? owner,
    List<String>? chatters,
  }) {
    return ChatGroupModel(
      chatters: chatters ?? this.chatters,
      owner: owner ?? this.owner,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        chatters,
        owner,
        productId,
        createdAt,
        updatedAt,
      ];
}
