import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:flutter/material.dart';

class BugReport extends StatefulWidget {
  const BugReport({super.key});

  @override
  State<BugReport> createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  String bugTitle = "";
  String bugDescription = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Bug Report",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: BackgroundDecoration(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: Theme.of(context).textTheme.displayMedium!,
                  decoration: InputDecoration(
                    labelText: "Bug Title",
                    labelStyle:
                        Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 17,
                            ),
                  ),
                  onChanged: (value) => bugTitle = value,
                ),
                TextField(
                  style: Theme.of(context).textTheme.displayMedium!,
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle:
                        Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 17,
                            ),
                  ),
                  onChanged: (value) => bugDescription = value,
                  minLines: 1,
                  maxLines: 6,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await bugReport(
                        bugTitle: bugTitle,
                        bugDescription: bugDescription,
                        name: InitialData.instance.userInfo!["userData"]
                            ["name"],
                      );
                    },
                    child: Text(
                      "Submit",
                      style: Theme.of(context).textTheme.displayMedium!,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
