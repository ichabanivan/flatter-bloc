import 'package:flutter/material.dart';
import './auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = AuthRepository();
  runApp(
    // BlocProvider - это виджет Flutter, который предоставляет блок
    // своим дочерним элементам через BlocProvider.of<T>(context).
    // Он используется как виджет внедрения зависимостей (DI),
    // так что один экземпляр блока может быть предоставлен нескольким виджетам в поддереве.
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(authRepository: authRepository)
          ..add(AuthenticationStarted());
      },
      child: App(authRepository: authRepository),
    ),
  );
}

class App extends StatelessWidget {
  final AuthRepository authRepository;

  App({Key key, @required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // BlocBuilder - это виджет Flutter, который требует функции Bloc и builder.
      // BlocBuilder обрабатывает создание виджета в ответ на новые состояния.
      // BlocBuilder очень похож на StreamBuilder, но имеет более простой API
      // для уменьшения необходимого количества стандартного кода.
      // Функция builder потенциально может быть вызвана много раз
      // и должна быть чистой функцией, которая возвращает виджет в ответ на состояние.
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
            return Text("Hello");
//          if (state is AuthenticationSuccess) {
//            return HomePage();
//          }
//          if (state is AuthenticationFailure) {
//            return LoginPage(authRepository: authRepository);
//          }
//          if (state is AuthenticationInProgress) {
//            return LoadingIndicator();
//          }
//          return SplashPage();
        },
      ),
    );
  }
}