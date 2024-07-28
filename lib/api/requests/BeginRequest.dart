import 'package:json_annotation/json_annotation.dart';

part 'BeginRequest.g.dart';

@JsonSerializable()
class BeginRequest {
  final String captcha;
  final String email;
  final String origin;


  BeginRequest({required this.captcha, required this.email, required this.origin});

  factory BeginRequest.fromJson(Map<String, dynamic> json) => _$BeginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BeginRequestToJson(this);
}
