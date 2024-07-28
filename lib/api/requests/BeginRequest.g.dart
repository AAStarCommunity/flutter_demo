// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BeginRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeginRequest _$BeginRequestFromJson(Map<String, dynamic> json) => BeginRequest(
      captcha: json['captcha'] as String,
      email: json['email'] as String,
      origin: json['origin'] as String,
    );

Map<String, dynamic> _$BeginRequestToJson(BeginRequest instance) =>
    <String, dynamic>{
      'captcha': instance.captcha,
      'email': instance.email,
      'origin': instance.origin,
    };
