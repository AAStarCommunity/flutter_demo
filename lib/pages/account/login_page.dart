import 'dart:async';

import 'package:HexagonWarrior/extensions/extensions.dart';
import 'package:HexagonWarrior/pages/account/account_controller.dart';
import 'package:HexagonWarrior/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  static const String routeName = "/login";

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }

}

class _LoginPageState extends State<LoginPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailCtrl = TextEditingController();
  StreamController<ErrorAnimationType> _errorCtrl = StreamController<ErrorAnimationType>();
  TextEditingController _pinCodeCtrl = TextEditingController();


  String? _validatePinCode(String? v) {
    if (v == null || v.length < 6) {
      return "complete_pin_code".tr;
    } else {
      return null;
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'mailHintError'.tr;
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'mailHintError'.tr;
    }
    return null;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pinCodeCtrl.dispose();
    _errorCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final decoration = InputDecoration(
      hintText: "mailHint".tr,
      border: OutlineInputBorder()
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("login".tr, style: Theme.of(context).textTheme.titleMedium)),
      body: Column(children: [
        Form(key: _formKey, child: Column(children: [
          TextFormField(controller: _emailCtrl, decoration: decoration, validator: (value) {
            return _validateEmail(value);
          }).marginOnly(top: 80),
          PinCodeTextField(
            appContext: context,
            // pastedTextStyle: TextStyle(
            //   color: Colors.green.shade600,
            //   fontWeight: FontWeight.bold,
            // ),
            length: 6,
            obscureText: true,
            obscuringCharacter: '*',
            obscuringWidget: const FlutterLogo(
              size: 24,
            ),
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            validator: _validatePinCode,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
            ),
            // cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            errorAnimationController: _errorCtrl,
            controller: _pinCodeCtrl,
            keyboardType: TextInputType.number,
            // boxShadows: const [
            //   BoxShadow(
            //     offset: Offset(0, 1),
            //     color: Colors.black12,
            //     blurRadius: 10,
            //   )
            // ],
            // onCompleted: (v) {
            //   debugPrint("Completed");
            // },
            // onTap: () {
            //   print("Pressed");
            // },
            // onChanged: (value) {
            //
            // },
            // beforeTextPaste: (text) {
            //   debugPrint("Allowing to paste $text");
            //   return true;
            // },
          ).marginOnly(top: 24),
          CupertinoButton.filled(onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _login();
          }, child: Text("login".tr)).marginOnly(top: 50)
        ]).paddingSymmetric(horizontal: 24))
      ]),
    );
  }

  _login() async{
    final controller = Get.find<AccountController>();
    if (_formKey.currentState!.validate()) {
      final res = await controller.login(_emailCtrl.text, captcha: _pinCodeCtrl.text);
      if(res.success) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Login successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Get.find<SharedPreferences>().token = "token_${_emailCtrl.text}";
        Get.offAllNamed(MainPage.routeName);
      } else {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Error:'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}