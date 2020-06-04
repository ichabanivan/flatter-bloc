import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutterapp/services/api.dart';
import 'package:meta/meta.dart';

import './auth.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
    final AuthRepository authRepository;

    AuthenticationBloc({ @required this.authRepository }) : assert(authRepository != null);

    @override
    AuthenticationState get initialState => AuthenticationInitial();

    @override
    Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
        if (event is AuthenticationStarted) {
            final bool hasToken = await authRepository.hasToken();

            if (hasToken) {
                yield AuthenticationSuccess();
            } else {
                yield AuthenticationFailure();
            }
            print(1);
            await authRepository.authenticate(username: 'zanusilker@gmail.com', password: 'Asdf1234');
            print(2);
            yield AuthenticationSuccess();
            print('AuthenticationSuccess');
        }

        if (event is AuthenticationLoggedIn) {
            yield AuthenticationInProgress();
            await authRepository.persistToken(event.token);
            yield AuthenticationSuccess();
            print('AuthenticationSuccess');
        }

        if (event is AuthenticationLoggedOut) {
            yield AuthenticationInProgress();
            await authRepository.deleteToken();
            yield AuthenticationFailure();
            print('AuthenticationFailure');
        }
    }
}