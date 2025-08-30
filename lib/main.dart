import 'package:codealchemy/authenticateuser.dart';
import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/colors/themedark.dart';
import 'package:codealchemy/colors/themelight.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/checkconnectivity.dart';
import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:codealchemy/firebase_options.dart';
import 'package:codealchemy/pages/mainpage.dart';
import 'package:codealchemy/popup/expirecredit.dart';
import 'package:codealchemy/popup/trialcount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intro/flutter_intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await InitialData.initialize();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(const CodeAlchemy());
}

class CodeAlchemy extends StatefulWidget {
  const CodeAlchemy({super.key});

  @override
  State<CodeAlchemy> createState() => _TestState();
}

class _TestState extends State<CodeAlchemy> {
  @override
  Widget build(BuildContext context) {
    //initializes the initial data
    InitialData.instance.updateApp = () => setState(() {});

    return MaterialApp(
      //light and dark theme of the app
      themeMode:
          InitialData.instance.isDarkMode! ? ThemeMode.dark : ThemeMode.light,
      //dark theme
      darkTheme: ThemeData().copyWith(
        scaffoldBackgroundColor: ThemeDark.seedColor,
        iconButtonTheme: ThemeDark.iconButtonTheme,
        textTheme: ThemeDark.textTheme,
        primaryColor: ThemeDark.primaryColor,
        colorScheme: ThemeDark.colorScheme,
        appBarTheme: ThemeDark.appbarTheme,
        elevatedButtonTheme: ThemeDark.elevatedButtonTheme,
      ),
      //light theme
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: ThemeLight.seedColor,
        iconButtonTheme: ThemeLight.iconButtonTheme,
        textTheme: ThemeLight.textTheme,
        primaryColor: ThemeLight.primaryColor,
        colorScheme: ThemeLight.colorScheme,
        appBarTheme: ThemeLight.appbarTheme,
        elevatedButtonTheme: ThemeDark.elevatedButtonTheme,
      ),
      //starting app widgets
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: CheckConnectivity(
          refresh: () {
            setState(() {});
          },
          child: StreamBuilder(
            //getting info from firebase if user is logged in or not
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              InitialData.instance.userData = snapshot.data;
              return FutureBuilder(
                future: InitialData.instance.updateUserData(),
                builder: (context, snapshot) {
                  // show loading spinner when getting data from firebase
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const BackgroundDecoration(
                      child: Center(
                        child: LoadingAnimation(),
                      ),
                    );
                  } else
                  //after fetching the data from the firebase
                  {
                    if (!InitialData.instance.widgetsBuit! &&
                        InitialData.instance.userData == null) {
                      // if user is not logged in is true
                      InitialData.instance.widgetsBuit = true;
                      if (InitialData.instance.credits! <= 0) {
                        //user credit expired is true
                        Future.microtask(
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const ExpireCredit(),
                            ),
                          ),
                        );
                        //authentication page
                        return const AuthenticateUser();
                      } else {
                        Future.microtask(
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const TrialCount(),
                            ),
                          ),
                        );
                      }
                    }
                    return Intro(
                      padding: const EdgeInsets.all(5),
                      maskColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.85),
                      child: const MainPage(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
