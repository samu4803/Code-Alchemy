import 'dart:math';

import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CheckConnectivity extends StatelessWidget {
  CheckConnectivity({super.key, required this.child, required this.refresh});
  final Function() refresh;
  final Widget child;
  final connectivityStatus = Connectivity();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const BackgroundDecoration(
              child: LoadingAnimation(),
            );
          }
          if (snapshot.data != null &&
              (snapshot.data!.contains(ConnectivityResult.mobile) ||
                  snapshot.data!.contains(ConnectivityResult.wifi) ||
                  snapshot.data!.contains(ConnectivityResult.ethernet) ||
                  snapshot.data!.contains(ConnectivityResult.vpn))) {
            return child;
          } else {
            final List<String> messages = [
              "There is no internet",
              "Check Your Internet",
              "Error, somthing went wrong",
              "Cannot access right now",
              "Please try again later",
            ];
            final randomText = Random().nextInt(messages.length);
            return BackgroundDecoration(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      messages[randomText],
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: () => refresh(),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
                      child: Text(
                        "Refresh",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
        stream: connectivityStatus.checkConnectivity().asStream(),
      ),
    );
  }
}
