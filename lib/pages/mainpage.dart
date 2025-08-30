import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/backend/globalvariables.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/customintro.dart';
import 'package:codealchemy/maindrawer.dart';
import 'package:codealchemy/snippets/codeeditor.dart';
import 'package:codealchemy/snippets/userrequests.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 2,
        child: MainDrawer(),
      ),
      onDrawerChanged: (isOpened) {
        InitialData.instance.codeEditorFocusNode!.unfocus();
      },
      appBar: AppBar(
        leading: Builder(
          builder: (context) => CustomIntro(
            order: 5,
            text: "signup/login in here to access more perks",
            last: true,
            onCalled: InitialData.instance.updateJustInstalled,
            builder: (context, key) {
              return IconButton(
                key: key,
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              logoAssetImage,
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              appName,
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size(10, 40),
          child: UserRequestType(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (InitialData.instance.controller != null) {
            InitialData.instance.controller!.clear();
          }
        },
        child: const BackgroundDecoration(
          child: Center(
            child: CodeEditor(),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
