import 'package:codealchemy/authenticateuser.dart';
import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/about.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/pages/bugreport.dart';
import 'package:codealchemy/pages/historypage.dart';
import 'package:codealchemy/popup/signout.dart';
import 'package:codealchemy/snippets/editprofile.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({
    super.key,
  });
  final bool isDarkMode = InitialData.instance.isDarkMode!;
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  userProfile() async {
    userProfileMap = await getProfile() as Map<String, dynamic>;
  }

  Map<String, dynamic> userProfileMap = {
    "profile": null,
    "userData": null,
  };
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    isDarkMode = widget.isDarkMode;
    return BackgroundDecoration(
      child: Container(
        padding: const EdgeInsets.only(
          top: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InitialData.instance.userData == null
                ? const SizedBox()
                : SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const EditProfile(),
                              ),
                            );
                            setState(() {});
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage: InitialData.instance.userInfo ==
                                    null
                                ? null
                                : FadeInImage(
                                    placeholder: const AssetImage(
                                        "assets/defaultProfile.png"),
                                    image: NetworkImage(
                                      InitialData.instance.userInfo!["profile"],
                                    ),
                                  ).image,
                          ),
                        ),
                        Text(
                          InitialData.instance.userInfo?["userData"]["name"] ??
                              "Name",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 17,
                                  ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
            SwitchListTile.adaptive(
              value: isDarkMode,
              onChanged: (value) async {
                InitialData.instance.isDarkMode = value;
                await InitialData.instance.localData!
                    .setBool("isDarkMode", value);
                InitialData.instance.updateApp!();
              },
              title: Row(
                children: [
                  Text(
                    "Dark\nMode",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const About(),
                  ),
                );
              },
              child: Text(
                "About",
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ),
            InitialData.instance.userData == null
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const HistoryPage(),
                        ),
                      );
                    },
                    child: Text(
                      "History",
                      style: Theme.of(context).textTheme.titleMedium!,
                    )),
            InitialData.instance.userData == null
                ? ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AuthenticateUser(),
                        ),
                      );
                    },
                    child: Text(
                      "Signup/Login",
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                  )
                : ElevatedButton(
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BugReport(),
                        ),
                      );
                    },
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SignOutPopUp(),
                      );
                    },
                    child: Text(
                      "Sign Out",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
            InitialData.instance.userData == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.61,
                  )
                : const SizedBox(),
            InitialData.instance.userData == null
                ? Text(
                    "credits:${InitialData.instance.credits!}",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 20,
                        ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
