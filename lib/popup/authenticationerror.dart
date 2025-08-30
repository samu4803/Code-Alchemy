import 'package:flutter/material.dart';

class AuthenticationError extends StatelessWidget {
  const AuthenticationError({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      title: Text(
        "Error",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Ok",
          ),
        ),
      ],
    );
  }
}
