import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/repo/auth_repository.dart';
import 'package:nike_ecommerce/data/repo/cart_repository.dart';
import 'package:nike_ecommerce/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  StreamSubscription<AuthState>? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  final TextEditingController emailController =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const onbackground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
          colorScheme: themeData.colorScheme.copyWith(onSurface: onbackground),
          snackBarTheme: SnackBarThemeData(
              backgroundColor: themeData.colorScheme.primary,
              contentTextStyle: const TextStyle(fontFamily: 'IranYekan')),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(onbackground),
                  foregroundColor: MaterialStateProperty.all(
                      themeData.colorScheme.secondary),
                  minimumSize:
                      MaterialStateProperty.all(const Size.fromHeight(47)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )))),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(color: onbackground),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final bloc = AuthBloc(authRepository, cartRepository);
              bloc.add(AuthStarted());
              streamSubscription = bloc.stream.listen((state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.exception.message)));
                }
              });
              return bloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: ((previous, current) =>
                    current is AuthLoading ||
                    current is AuthInitial ||
                    current is AuthError),
                builder: ((context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/nike_logo.png',
                        color: onbackground,
                        width: 80,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(state.isLogin ? 'خوش آمدید' : 'ثبت نام',
                          style: const TextStyle(
                              color: onbackground, fontSize: 18)),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        state.isLogin
                            ? 'لطفا به حساب کاربری خود وارد شوید'
                            : 'ایمیل و رمز عبور خود را تعیین کنید',
                        style: const TextStyle(color: onbackground),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 54,
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              label: Text(
                            'آدرس ایمیل',
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 54,
                        child: _PasswordTextField(
                          onbackground: onbackground,
                          controller: passwordController,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                                AuthButtonClicked(emailController.text,
                                    passwordController.text));
                          },
                          child: state is AuthLoading
                              ? CupertinoActivityIndicator(
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                )
                              : Text(state.isLogin ? 'ورود' : 'ثبت نام')),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthModeChangedClicked());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLogin
                                  ? 'حساب کاربری ندارید؟'
                                  : 'حساب کاربری دارید؟',
                              style: TextStyle(
                                  color: onbackground.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              state.isLogin ? 'ثبت نام' : 'ورود',
                              style: TextStyle(
                                  color: themeData.colorScheme.primary,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    Key? key,
    required this.onbackground,
    required this.controller,
  }) : super(key: key);

  final Color onbackground;
  final TextEditingController controller;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  var obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obsecureText = !obsecureText;
              });
            },
            icon: Icon(
              obsecureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onbackground.withOpacity(0.6),
            ),
          ),
          label: const Text('رمز عبور')),
    );
  }
}
