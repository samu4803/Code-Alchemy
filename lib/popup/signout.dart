import 'package:codealchemy/backend/backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutPopUp extends StatelessWidget {
  const SignOutPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      title: Text(
        "Confirm Sign out",
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 23,
            ),
      ),
      content: Text(
        "Do you really want to sign out",
        style: Theme.of(context).textTheme.displayMedium!,
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.displayMedium!,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            InitialData.instance.userData = null;
            InitialData.instance.controller!.clear();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
          child: Text(
            "Confirm",
            style: Theme.of(context).textTheme.displayMedium!,
          ),
        ),
      ],
    );
  }
}
