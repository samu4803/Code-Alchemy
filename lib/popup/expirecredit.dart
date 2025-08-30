import 'package:codealchemy/authenticateuser.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:flutter/material.dart';

class ExpireCredit extends StatelessWidget {
  const ExpireCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundDecoration(
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          "Free trial Expired",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 23),
        ),
        content: Text(
          "Your free trial has been epired. Please Login to continue",
          style: Theme.of(context).textTheme.displayMedium!,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel",
                style: Theme.of(context).textTheme.displayMedium!),
          ),
          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AuthenticateUser(),
                ),
              );
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: Text(
              "Login",
              style: Theme.of(context).textTheme.displayMedium!,
            ),
          ),
        ],
      ),
    );
  }
}
