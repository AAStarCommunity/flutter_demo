import 'package:json_annotation/json_annotation.dart';

part 'PrepareRequest.g.dart';

@JsonSerializable()
class PrepareRequest {
  final String email;

  PrepareRequest({required this.email});

  factory PrepareRequest.fromJson(Map<String, dynamic> json) => _$PrepareRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PrepareRequestToJson(this);
}