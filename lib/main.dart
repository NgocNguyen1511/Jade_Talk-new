import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/screens/login_screen.dart';
import 'package:jade_talk/firebase_options.dart';
import 'package:jade_talk/screens/home_screen.dart';
import 'package:jade_talk/screens/register_screen.dart';
import 'package:jade_talk/screens/splash_screen.dart';
import 'package:jade_talk/screens/user_infor_screen.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
          title: 'Jade Talk',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: Constants.splashScreen,
          routes: {
            Constants.splashScreen: (context) => const SplashScreen(),
            Constants.loginScreen: (context) => const LoginScreen(),
            Constants.registerScreen: (context) => const RegisterScreen(),
            Constants.userInformationScreen: (context) =>
                const UserInforScreen(),
            Constants.homeScreen: (context) => const HomeScreen(),
          }),
    );
  }
}
