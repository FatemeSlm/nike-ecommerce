import 'package:flutter/material.dart';
import 'package:nike_ecommerce/data/repo/auth_repository.dart';
import 'package:nike_ecommerce/data/favorite_manager.dart';
import 'package:nike_ecommerce/theme.dart';
import 'package:nike_ecommerce/ui/root.dart';

void main() async{
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        fontFamily: 'IranYekan', color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        hintColor: LightThemeColors.secondryTextColor,
        inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        LightThemeColors.primaryTextColor.withOpacity(0.1)))),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: LightThemeColors.primaryTextColor,
            elevation: 0),
        textTheme: TextTheme(
            button: defaultTextStyle,
            subtitle1: defaultTextStyle.apply(
                color: LightThemeColors.secondryTextColor),
            bodyText2: defaultTextStyle,
            caption: defaultTextStyle.apply(
                color: LightThemeColors.secondryTextColor),
            headline6: defaultTextStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 17)),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondryColor,
            onSecondary: Colors.white,
            surfaceVariant: Color(0xfff5f5f5)),
        snackBarTheme: SnackBarThemeData(
            contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
