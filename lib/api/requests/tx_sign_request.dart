import 'package:json_annotation/json_annotation.dart';

part 'tx_sign_request.g.dart';

@JsonSerializable()
class TxSignRequest {
  String? ticket;
  String? origin;
  String? txdata;
  String? network;
  String? networkAlias;

  TxSignRequest({
    this.ticket,
    this.origin,
    this.txdata,
    required this.network,
    this.networkAlias,
  });

  factory TxSignRequest.fromJson(Map<String, dynamic> json) => _$TxSignRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TxSignRequestToJson(this);

}