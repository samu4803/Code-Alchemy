// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:codealchemy/essentials/nativecamera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticateUser extends StatefulWidget {
  const AuthenticateUser({super.key});

  @override
  State<AuthenticateUser> createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {
  var authenticationTypeLogin = true;
  var authenticationName = "";
  bool loading = false;
  String email = "";
  String password = "";
  String? name;
  File? profile;
  final formKey = GlobalKey<FormState>();
  Widget signUpScreen() {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.width / 8,
        left: MediaQuery.of(context).size.width * 0.07,
        right: MediaQuery.of(context).size.width * 0.07,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                authenticationName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.transparent,
                backgroundImage: profile == null
                    ? Image.asset("assets/defaultProfile.png").image
                    : Image.file(profile!).image,
              ),
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final XFile? photo = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const SafeArea(
                              child: NativeCamera(),
                            ),
                          ),
                        );
                        if (photo != null) {
                          profile = File(photo.path);
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final temp = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: [
                            "jpg",
                          ],
                        );
                        if (temp != null) {
                          profile = File(temp.xFiles.first.path);
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.add_photo_alternate,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                initialValue: "",
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontFamily: "Roboto_Mono",
                    color: Theme.of(context).colorScheme.secondary),
                decoration: InputDecoration(
                  label: Text(
                    "Name:",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  hintText: "Enter Name",
                  hintStyle: TextStyle(
                    fontFamily: "Roboto_Mono",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                validator: (value) {
                  if (value != null &&
                      value.length > 4 &&
                      (value.toUpperCase().contains(RegExp(r'[A-Z]')) ||
                          value.contains("_"))) {
                    return null;
                  }
                  return "Enter a valid name";
                },
                onSaved: (newValue) {
                  name = newValue!;
                },
              ),
              emailPassword(),
              TextFormField(
                initialValue: "",
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(
                    fontFamily: "Roboto_Mono",
                    color: Theme.of(context).colorScheme.secondary),
                decoration: InputDecoration(
                  label: Text(
                    "Confirm Password:",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  hintText: "Confirm Password",
                  hintStyle: TextStyle(
                    fontFamily: "Roboto_Mono",
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                validator: (value) {
                  if (value != null && value.length > 7 && value == password) {
                    return null;
                  }
                  return "Enter an valid password";
                },
                onSaved: (newValue) {
                  password = newValue!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              loading == true
                  ? const LoadingAnimation(size: 70)
                  : ElevatedButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(10),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          {
                            if (profile == null) {
                              final byteData = await rootBundle
                                  .load('assets/defaultProfile.png');
                              final file = File(
                                  '${(await getTemporaryDirectory()).path}/defaultProfile.png');
                              await file.create(recursive: true);
                              await file.writeAsBytes(byteData.buffer
                                  .asUint8List(byteData.offsetInBytes,
                                      byteData.lengthInBytes));
                              profile = file;
                            }
                            await firebaseSignUp(
                              context: context,
                              email: email,
                              password: password,
                              profile: profile!,
                              mounted: mounted,
                              name: name!,
                            );
                          }
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Text(
                        authenticationName,
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                ),
                      ),
                    ),
              changeScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginScreen() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.07,
          right: MediaQuery.of(context).size.width * 0.07,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary,
                blurRadius: 5,
                blurStyle: BlurStyle.outer,
              )
            ]),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                authenticationName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              emailPassword(),
              loading == true
                  ? const LoadingAnimation(size: 70)
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (authenticationTypeLogin) {
                            await firebaseLogin(
                              context: context,
                              email: email,
                              password: password,
                              mounted: mounted,
                            );
                          }
                        }
                        setState(
                          () {
                            loading = false;
                          },
                        );
                      },
                      child: Text(
                        "Login",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 20,
                                ),
                      ),
                    ),
              changeScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget changeScreen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          authenticationTypeLogin == true ? "New User " : "aldready an User ",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        TextButton(
          onPressed: () {
            profile = null;
            setState(() {
              if (authenticationTypeLogin) {
                authenticationTypeLogin = false;
              } else {
                authenticationTypeLogin = true;
              }
            });
          },
          child: Text(
            authenticationTypeLogin == true ? "SignUp" : "Login",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontFamily: "Roboto_Mono",
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget emailPassword() {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: "",
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Roboto_Mono",
                color: Theme.of(context).colorScheme.secondary),
            decoration: InputDecoration(
              label: Text(
                "Email:",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              hintText: "Enter Email",
              hintStyle: TextStyle(
                fontFamily: "Roboto_Mono",
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            validator: (value) {
              if (value != null &&
                  value.contains("@") &&
                  value.contains(".com")) {
                return null;
              }
              return "Enter an email";
            },
            onSaved: (newValue) {
              email = newValue!;
            },
          ),
          TextFormField(
            initialValue: "",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            style: TextStyle(
              fontFamily: "Roboto_Mono",
              color: Theme.of(context).colorScheme.secondary,
            ),
            decoration: InputDecoration(
              label: Text(
                "Password:",
                style: TextStyle(
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              hintText: "Enter Password",
              hintStyle: TextStyle(
                fontFamily: "Roboto_Mono",
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onChanged: (value) => password = value,
            validator: (value) {
              if (value != null && value.length > 7) {
                return null;
              }
              return "Enter an valid password";
            },
            onSaved: (newValue) {
              password = newValue!;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (authenticationTypeLogin) {
      authenticationName = "Login";
    } else {
      authenticationName = "Sign Up";
    }
    return BackgroundDecoration(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: authenticationTypeLogin == true ? loginScreen() : signUpScreen(),
      ),
    );
  }
}
