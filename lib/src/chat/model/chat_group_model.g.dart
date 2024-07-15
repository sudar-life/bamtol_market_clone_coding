// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGroupModel _$ChatGroupModelFromJson(Map<String, dynamic> json) =>
    ChatGroupModel(
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      productId: json['productId'] as String?,
      owner: json['owner'] as String?,
      chatters: (json['chatters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ChatGroupModelToJson(ChatGroupModel instance) =>
    <String, dynamic>{
      'chatters': instance.chatters,
      'owner': instance.owner,
      'productId': instance.productId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
