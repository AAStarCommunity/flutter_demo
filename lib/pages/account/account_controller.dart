import 'dart:async';
import 'dart:typed_data';
import 'package:HexagonWarrior/api/air_account_api_ext.dart';
import 'package:HexagonWarrior/api/api.dart';
import 'package:HexagonWarrior/api/generic_response.dart';
import 'package:HexagonWarrior/api/requests/reg_request.dart';
import 'package:HexagonWarrior/api/requests/sign_request.dart';
import 'package:HexagonWarrior/api/response/reg_response.dart';
import 'package:HexagonWarrior/config/tx_configs.dart';
import 'package:HexagonWarrior/extensions/extensions.dart';
import 'package:HexagonWarrior/pages/account/models/account_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/requests/prepare_request.dart';
import '../../config/tx_network.dart';
import '../../utils/validate_util.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../../zero/userop/userop.dart';

const _ORIGIN_DOMAIN = "https://demoweb.aastar.io";
const _network = "optimism-sepolia";

class AccountController extends GetxController with StateMixin<AccountInfo> {
  Future<AccountInfo?> getAccountInfo() async {
    final resp = await Api().getAccountInfo();
    if (resp.success) {
      final account = AccountInfo.fromJson(resp.data!.toJson());
      change(account, status: RxStatus.success());
      update();
    }
    return null;
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

  Future<void> txSign(String aa) async {
    final bundlerConfig = op_sepolia.bundler[0];
    final paymasterConfig = op_sepolia.paymaster[0];
    final rpc = op_sepolia.rpc;

    final bundlerRPC = bundlerConfig.url;
    final aa = "0xdd";

    final client = Web3Client("", http.Client());

    final contractAddress = EthereumAddress.fromHex(op_sepolia.contracts.usdt);
    final credentials = EthPrivateKey.fromHex('YOUR_PRIVATE_KEY');

    String abiCode =
        await rootBundle.loadString("assets/contracts/TetherToken.json");
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, op_sepolia.name),
      contractAddress,
    );

    final func = contract.function("_mint");
    final callData = await client.call(
        contract: contract,
        function: func,
        params: [aa, EtherAmount.fromInt(EtherUnit.ether, 10)]);

    final payMasterConfig = paymasterConfig.option;

    // final provider = BundlerJsonRpcProvider(0)
    final opts = IPresetBuilderOpts()
      ..entryPoint = EthereumAddress.fromHex(entryPointAddress)
      ..factoryAddress = EthereumAddress.fromHex(factoryAddress)
      ..paymasterMiddleware = verifyingPaymaster(paymasterConfig.url, {})
      ..overrideBundlerRpc = bundlerRPC;

    final simpleAccount = await SimpleAccount.init(
      credentials,
      bundlerRPC,
      opts: opts,
    );
    final sender = simpleAccount.getSender();

    IUserOperationBuilder uop = await simpleAccount.execute(Call(
        to: EthereumAddress.fromHex(sender),
        value: BigInt.zero,
        data: Uint8List.fromList(
            callData.map<int>((e) => int.parse('$e')).toList())));

    final IClientOpts iClientOpts = IClientOpts()
      ..overrideBundlerRpc = bundlerRPC;

    final opClient = await Client.init(rpc, opts: iClientOpts);

    final sendOpts = ISendUserOperationOpts()
      ..dryRun = false
      ..onBuild = (IUserOperation ctx) {
        print("Signed UserOperation: ${ctx.sender}");
      };
    final res = await opClient.sendUserOperation(uop, opts: sendOpts);
    final ev = await res.wait();
    final transactionHash = ev?.transactionHash;

    // final publicKey = await Api().txSign(TxSignRequest());
    // CredentialRequestOptions.fromJson({
    //   "publicKey" : {}
    // });
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
