// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/altsnackbar.dart';
import 'package:codealchemy/essentials/customintro.dart';
import 'package:codealchemy/essentials/listoflanguage.dart';
import 'package:codealchemy/essentials/sendprompt.dart';
import 'package:codealchemy/popup/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class UserRequestType extends StatelessWidget {
  const UserRequestType({super.key});
  @override
  Widget build(BuildContext context) {
    Future<void> validate(PromptType type) async {
      InitialData.instance.codeEditorFocusNode!.unfocus();
      if (InitialData.instance.code == null ||
          InitialData.instance.code == "") {
        altSnackBar(
          context: context,
          contentType: ContentType.warning,
          message: "code not provided",
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => Intro(
              padding: const EdgeInsets.all(5),
              maskColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              child: SendPrompt(
                promptType: type,
              ),
            ),
          ),
        );
        if ((InitialData.instance.feedbackGiven!) == false) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const FeedBack()));
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomIntro(
          order: 2,
          text: "press this button to explain what code you have written",
          builder: (context, key) => CustomButton(
            key: key,
            type: PromptType.explain,
            onTap: () async => await validate(PromptType.explain),
          ),
        ),
        CustomIntro(
          order: 3,
          text: "press this button to convert the code to anather language",
          builder: (context, key) => CustomButton(
            key: key,
            type: PromptType.convert,
            onTap: () async => await showDialog(
              context: context,
              builder: (ctx) => Dialog(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                alignment: Alignment.center,
                child: const ListOfLanguages(),
              ),
              barrierColor: Colors.transparent,
            ).then(
              (value) {
                if (InitialData.instance.to == null) {
                  altSnackBar(
                    context: context,
                    contentType: ContentType.warning,
                    message: "Conversion language is not provided",
                  );
                } else {
                  validate(PromptType.convert);
                }
              },
            ),
          ),
        ),
        CustomIntro(
          order: 4,
          text: "press this button to debug the code",
          builder: (context, key) => CustomButton(
            key: key,
            type: PromptType.debug,
            onTap: () async => await validate(PromptType.debug),
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.type,
    this.name,
    required this.onTap,
  });
  final PromptType? type;
  final String? name;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          gradient: const LinearGradient(
            colors: [
              Colors.purple,
              Color.fromARGB(255, 103, 69, 189),
              Color.fromARGB(255, 67, 89, 197),
              Color.fromARGB(255, 103, 69, 189),
              Colors.purple,
            ],
          ),
        ),
        child: Center(
          child: Text(
            type == null ? name.toString() : type!.name,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
