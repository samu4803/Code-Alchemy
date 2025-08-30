// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:codealchemy/essentials/sendprompt.dart';
import 'package:codealchemy/popup/authenticationerror.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

class InitialData {
  InitialData._();
  String? code;
  String? to;
  bool? isDarkMode;
  int? credits;
  SharedPreferences? localData;
  Function? updateApp;
  User? userData;
  bool? widgetsBuit;
  Map<String, dynamic>? userInfo;
  bool? feedbackGiven;
  bool? justInstalled;
  bool? justProcessed;
  BuildContext? introductionStartContext;
  CodeController? controller;
  FocusNode? codeEditorFocusNode;
  updateJustInstalled() async {
    await instance.localData!.setBool("justInstalled", false);
    instance.justInstalled = false;
  }

  updateJustProcessed() async {
    await instance.localData!.setBool("justProcessed", false);
    instance.justProcessed = false;
  }

  updateCredits() async {
    await instance.localData!.setInt("credits", instance.credits! - 1);
    instance.credits = instance.localData!.getInt("credits");
  }

  updateUserData() async {
    if (instance.userData != null) {
      instance.userInfo = await getProfile() as Map<String, dynamic>;
    }
  }

  updateFeedback({
    required String feedback,
    required int rating,
  }) async {
    await instance.localData!.setBool("feedback", true);
    sendFeedback(
      feedback: feedback,
      rating: rating,
    );
  }

  static final InitialData instance = InitialData._();
  static initialize() async {
    instance.code = null;
    instance.to = null;
    instance.userData = null;
    instance.userInfo = null;
    instance.updateApp = null;
    instance.widgetsBuit = false;
    instance.controller = CodeController();
    instance.codeEditorFocusNode = FocusNode();
    instance.localData = await SharedPreferences.getInstance();
    if (instance.localData!.getBool("isDarkMode") == null) {
      var brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.light) {
        instance.isDarkMode = false;
      } else {
        instance.isDarkMode = true;
      }
    } else {
      instance.isDarkMode = instance.localData!.getBool("isDarkMode");
    }
    if (instance.localData!.getInt("credits") == null) {
      instance.credits = 10;
    } else {
      instance.credits = instance.localData!.getInt("credits");
    }
    if (instance.localData!.getBool("feedback") == null) {
      await instance.localData!.setBool("feedback", false);
      instance.feedbackGiven = false;
    } else {
      instance.feedbackGiven = instance.localData!.getBool("feedback");
    }
    if (instance.localData!.getBool("justInstalled") == null) {
      await instance.localData!.setBool("justInstalled", true);
      instance.justInstalled = true;
    } else {
      instance.justInstalled = instance.localData!.getBool("justInstalled");
    }
    if (instance.localData!.getBool("justProcessed") == null) {
      await instance.localData!.setBool("justProcessed", true);
      instance.justProcessed = true;
    } else {
      instance.justProcessed = instance.localData!.getBool("justProcessed");
    }
  }
}

Future<void> firebaseSignUp({
  required BuildContext context,
  required String email,
  required String password,
  required String name,
  required bool mounted,
  required File profile,
}) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "name": name,
      "id": FirebaseAuth.instance.currentUser!.uid,
      "email": email,
    });
    await FirebaseStorage.instance
        .ref("profile")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("profile.png")
        .putFile(profile);
    final link = await FirebaseStorage.instance
        .ref("profile")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("profile.png")
        .getDownloadURL();

    if (mounted) {
      InitialData.instance.userInfo = {
        "profile": link,
        "userData": {
          "name": name,
          "id": FirebaseAuth.instance.currentUser!.uid,
          "email": email,
        },
      };
      Navigator.of(context).pop();
    }
  } on FirebaseException catch (error) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AuthenticationError(
          message: error.message!,
        ),
      );
    }
  }
}

Future<void> firebaseLogin({
  required BuildContext context,
  required String email,
  required String password,
  required bool mounted,
}) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (mounted) {
      Navigator.of(context).pop();
    }
  } on FirebaseAuthException catch (error) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                title: Text(
                  "Error",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                ),
                content: Text(
                  error.message!,
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Ok"))
                ],
              ));
    }
  }
}

Future<void> bugReport({
  required String bugTitle,
  required String bugDescription,
  required String name,
}) async {
  await FirebaseFirestore.instance.collection("bugs").doc().set({
    "bugTitle": bugTitle,
    "bugDescription": bugDescription,
    "reporterId": FirebaseAuth.instance.currentUser!.uid,
    "reporterName": name
  });
}

Future<void> editProfile(
    {required File? profile, required String? name}) async {
  if (name != null) {
    final temp = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userData = temp.data()!;
    userData["name"] = name;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userData);
    InitialData.instance.userInfo!["userData"]["name"] = name;
  }
  if (profile != null) {
    await FirebaseStorage.instance
        .ref("profile")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("profile.png")
        .putFile(profile);

    InitialData.instance.userInfo!["profile"] = await FirebaseStorage.instance
        .ref("profile")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("profile.png")
        .getDownloadURL();
  }
}

Future<Map> getProfile() async {
  final String profile = await FirebaseStorage.instance
      .ref("profile")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child("profile.png")
      .getDownloadURL();
  final temp = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  final userData = temp.data();
  return {
    "profile": profile,
    "userData": userData,
  } as Map<String, dynamic>;
}

Future<void> saveHistory({
  required String code,
  required PromptType type,
  required String answer,
  String language = "",
}) async {
  if (InitialData.instance.userData != null) {
    final ref = FirebaseFirestore.instance
        .collection("history")
        .doc(InitialData.instance.userData!.uid);
    try {
      final userHistory = await ref.get();
      await ref.update(
        {
          "${1 + (userHistory.data()?.length ?? 0)}": {
            "type": type.name,
            "language": language,
            "code": code,
            "answer": answer,
          }
        },
      );
    } catch (error) {
      ref.set(
        {
          "1": {
            "type": type.name,
            "language": language,
            "code": code,
            "answer": answer,
          }
        },
      );
    }
  }
}

Future<Map<String, dynamic>?> getHistory() async {
  if (InitialData.instance.userData != null) {
    final ref = FirebaseFirestore.instance
        .collection("history")
        .doc(InitialData.instance.userData!.uid);
    try {
      final userHistory = await ref.get();
      return userHistory.data();
    } catch (error) {
      return null;
    }
  }
  return null;
}

Future<void> sendFeedback({
  required String feedback,
  required int rating,
}) async {
  final id = const UuidV4().generate();
  FirebaseFirestore.instance.collection("feedback").doc(id).set({
    "feedback": feedback,
    "rating": rating,
  });
}

Future<void> removeSessionHistory(Map<String, dynamic> newHistory) async {
  await FirebaseFirestore.instance
      .collection("history")
      .doc(InitialData.instance.userData!.uid)
      .set(newHistory);
}
