// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_sign_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxSignRequest _$TxSignRequestFromJson(Map<String, dynamic> json) =>
    TxSignRequest(
      ticket: json['ticket'] as String?,
      origin: json['origin'] as String?,
      txdata: json['txdata'] as String?,
      network: json['network'] as String?,
      networkAlias: json['network_alias'] as String?
    );

Map<String, dynamic> _$TxSignRequestToJson(TxSignRequest instance) =>
    <String, dynamic>{
      'ticket': instance.ticket,
      'origin': instance.origin,
      'txdata': instance.txdata,
      'network': instance.network,
      'network_alias': instance.networkAlias
    };
