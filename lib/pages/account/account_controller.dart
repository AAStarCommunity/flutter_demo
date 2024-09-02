import 'dart:async';
import 'package:HexagonWarrior/api/air_account_api_ext.dart';
import 'package:HexagonWarrior/api/api.dart';
import 'package:HexagonWarrior/api/generic_response.dart';
import 'package:HexagonWarrior/api/requests/reg_request.dart';
import 'package:HexagonWarrior/api/requests/sign_request.dart';
import 'package:HexagonWarrior/api/response/reg_response.dart';
import 'package:HexagonWarrior/extensions/extensions.dart';
import 'package:HexagonWarrior/main.dart';
import 'package:HexagonWarrior/pages/account/models/account_info.dart';
import 'package:HexagonWarrior/zero/example/airAccount/erc20_transfer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/requests/prepare_request.dart';
import '../../utils/validate_util.dart';

const _ORIGIN_DOMAIN = "https://demoweb.aastar.io";
const _network = "optimism-sepolia";

const ORIGIN_DOMAIN = _ORIGIN_DOMAIN;

class AccountController extends GetxController with StateMixin<AccountInfo> {

  final _tokenAbiPath = "assets/contracts/TetherToken.json";

  Future<AccountInfo?> getAccountInfo() async {
    final resp = await Api().getAccountInfo();
    if (resp.success) {
      final account = AccountInfo.fromJson(resp.data!.toJson());
      await runZonedGuarded(() async{
        final res = await getBalance(_tokenAbiPath, account.aa!);
        account.balance = res;
      }, (e, s) {
        logger.e(e.toString(), stackTrace: s);
      });
      change(account, status: RxStatus.success());
      update();
    }
    return null;
  }

  mintUsdt() async{
   final balance = await mint(state!.aa!, "_mint", "assets/contracts/TetherToken.json", state!.initCode!, ORIGIN_DOMAIN, amountStr: "5");
   change(state?..balance = balance, status: RxStatus.success());
  }

  sendUsdt() async{
    final balance = await mint(state!.aa!, "transfer", "assets/contracts/TetherToken.json", state!.initCode!, ORIGIN_DOMAIN, amountStr: "5", receiver: "0x046Bd46B76c6Bd648719C988Fa2a839126a68a0F");
    change(state?..balance = balance, status: RxStatus.success());
  }

  Future<GenericResponse> register(String email,
      {String? captcha, String? network = _network}) async {
    try {
      final api = Api();
      GenericResponse<RegResponse> res = await api.reg(
          RegRequest(captcha: captcha!, email: email, origin: _ORIGIN_DOMAIN));
      if (res.success) {
        final body = await api.createAttestationFromPublicKey(
            res.data!.toJson(),
            res.data?.authenticatorSelection?.authenticatorAttachment,
            _ORIGIN_DOMAIN);
        final resp = await api.regVerify(email, _ORIGIN_DOMAIN, network, body);
        if (isNotNull(resp.token)) {
          return GenericResponse.success("ok");
        }
      }
      return res;
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());
      final response = GenericResponse.errorWithDioException(e as DioException);
      if (response.data != null &&
          '${response.data}'.contains("User already exists")) {
        return await login(email, captcha);
      }
      return response;
    }
  }

  Future<GenericResponse> prepare(String email) async {
    var res = await Api().prepare(PrepareRequest(email: email));
    return res;
  }

  Future<GenericResponse> login(String email, String? captcha) async {
    try {
      final api = Api();
      var res = await api.sign(SignRequest(captcha: captcha, email: email, origin: _ORIGIN_DOMAIN));
      if (res.success) {
        final body = await api.createAssertionFromPublic(res.data!.toJson(), _ORIGIN_DOMAIN);
        final resp = await api.signVerify(email, _ORIGIN_DOMAIN, body);
        if (isNotNull(resp.token)) {
          return GenericResponse.success("ok");
        }
      }
      return res;
    } catch(e, s) {
      return GenericResponse.errorWithDioException(e as DioException);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<GenericResponse> logout() async {
    Get.find<SharedPreferences>().token = null;
    await Future.delayed(const Duration(seconds: 3));
    final res = GenericResponse.success("ok");
    return res;
  }
}
