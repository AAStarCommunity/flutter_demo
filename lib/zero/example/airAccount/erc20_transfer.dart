import 'dart:convert';
import 'dart:io';

import 'package:HexagonWarrior/config/tx_configs.dart';
import 'package:HexagonWarrior/main.dart';
import 'package:HexagonWarrior/pages/account/account_controller.dart';
import 'package:HexagonWarrior/utils/validate_util.dart';
import 'package:HexagonWarrior/zero/userop/src/preset/builder/air_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/v4.dart';
import 'package:web3dart/crypto.dart';

import '../../userop/userop.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:web3dart/crypto.dart';assets/contracts/TetherToken.json

Future<String?> getBalance(String tokenAbiPath, String aaAddress) async{
  final contractName = tokenAbiPath.substring(tokenAbiPath.lastIndexOf("/") + 1, tokenAbiPath.lastIndexOf("."));
  String abiStr = await rootBundle.loadString(tokenAbiPath);
  final abiObj = jsonDecode(abiStr);
  final contractAddress = op_sepolia.contracts.usdt;
  final web3Client = Web3Client.custom(BundlerJsonRpcProvider(op_sepolia.rpc, http.Client()));
  final response = await ContractsHelper.readFromContract(web3Client, contractName, contractAddress, "balanceOf", [EthereumAddress.fromHex(aaAddress)], jsonInterface: jsonEncode(abiObj['abi']));
  logger.i("余额：${response}" );
  return response.firstOrNull?.toString();
}

Future<String?> mint(String aaAddress, String functionName, String tokenAbiPath, String initCode, String origin, {String? amountStr, String? receiver}) async {
  final contractName = tokenAbiPath.substring(tokenAbiPath.lastIndexOf("/") + 1, tokenAbiPath.lastIndexOf("."));
  final tokenAddress = EthereumAddress.fromHex(op_sepolia.contracts.usdt);
  final targetAddress = EthereumAddress.fromHex(receiver ?? aaAddress);
  final amount = isNotNull(amountStr) ? BigInt.parse(amountStr!) : BigInt.zero;

  final bundlerRPC = op_sepolia.bundler.first.url;
  final rpcUrl = op_sepolia.rpc;

  final paymasterMiddleware = verifyingPaymaster(
     op_sepolia.paymaster.first.url,
     op_sepolia.paymaster.first.option!.toJson(),
  );

  final IPresetBuilderOpts opts = IPresetBuilderOpts()
  //..nonceKey = BigInt.from(hexToDartInt(UuidV4().generate().replaceAll("-", "").substring(0, 6)))
  ..paymasterMiddleware = paymasterMiddleware;
  //..overrideBundlerRpc = bundlerRPC;

  final airAccount = await AirAccount.init(
    aaAddress,
    initCode,
    rpcUrl,
    origin,
    tokenAddress,
    opts: opts,
  );

  final client = await Client.init(bundlerRPC);

  final sendOpts = ISendUserOperationOpts()
    ..dryRun = false
    ..onBuild = (IUserOperation ctx) async {
      logger.i("Signed UserOperation：" + ctx.toJson().toString());
    };

  String abiStr = await rootBundle.loadString(tokenAbiPath);
  final abiObj = jsonDecode(abiStr);

  final call = Call(
    to: tokenAddress,
    value: BigInt.zero,
    data: ContractsHelper.encodedDataForContractCall(
      contractName,
      tokenAddress.toString(),
      functionName,//_mint, mint
      [
        targetAddress,
        amount,
      ],
      include0x: true,
      jsonInterface: jsonEncode(abiObj['abi'])
    ),
  );
  final userOp = await airAccount.execute(call);

  final res = await client.sendUserOperation(
    userOp,
    opts: sendOpts,
  );
  debugPrint('UserOpHash: ${res.userOpHash}');

  debugPrint('Waiting for transaction...');
  final ev = await res.wait();
  debugPrint('Transaction hash: ${ev?.transactionHash}');
  return await getBalance(tokenAbiPath, aaAddress);
}