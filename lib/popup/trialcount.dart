import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class TrialCount extends StatelessWidget {
  const TrialCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundDecoration(
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          "Free trial",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Text(
          "you have not signed in to codealchemy.\n you have ${InitialData.instance.credits} left. Sign up to get unlimited credits",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.surfaceVariant),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (InitialData.instance.justInstalled!) {
                Intro.of(InitialData.instance.introductionStartContext!)
                    .start();
              }
            },
            child: Text(
              "Okay",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
