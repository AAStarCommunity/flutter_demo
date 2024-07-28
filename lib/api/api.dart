import 'package:HexagonWarrior/api/requests/BeginRequest.dart';
import 'package:HexagonWarrior/api/response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'local_http_client.dart';
import 'requests/PrepareRequest.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'https://anotherairaccountcommunitynode.onrender.com')
abstract class Api{
  factory Api({Dio? dio, String? baseUrl}) {
    LocalHttpClient().init(baseUrl: baseUrl);
    return _Api(dio ?? LocalHttpClient.dio, baseUrl: baseUrl);
  }

  @POST("/api/passkey/v1/reg/prepare")
  Future<VoidModel> prepare(@Body() PrepareRequest req);

  @POST('/api/passkey/v1/reg')
  Future<VoidModel> reg(@Body() BeginRequest req);
}