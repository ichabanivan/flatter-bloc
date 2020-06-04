import 'dart:async';
import 'dart:convert';

import 'package:flutterapp/services/api.dart';
import 'package:flutterapp/services/database.dart';
import 'package:meta/meta.dart';
import '../services/api.dart';

class AuthRepository {
    Future<String> authenticate({
        @required String username,
        @required String password,
    }) async {

//        await Future.delayed(Duration(seconds: 1));
        final response = await dio.post('auth-service/auth/token', data: '{"password":"Asdf1234","username":"zanusilker@gmail.com",  "client": "patient_application"}');
//        print(json.decode(response));
        var b = await DatabaseService.instance.insertRecord(AuthInfo.fromMap(response));
        print(b);
        return 'token';
    }

    Future<void> deleteToken() async {
        /// delete from keystore/keychain
        await Future.delayed(Duration(seconds: 1));
        return;
    }

    Future<void> persistToken(String token) async {
        /// write to keystore/keychain
        await Future.delayed(Duration(seconds: 1));
        return;
    }

    Future<bool> hasToken() async {
        /// read from keystore/keychain
        List a = await DatabaseService.instance.getList();
        print(a);
        await Future.delayed(Duration(seconds: 1));
        return false;
    }
}