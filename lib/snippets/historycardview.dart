import 'package:code_text_field/code_text_field.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class HistoryCardView extends StatelessWidget {
  const HistoryCardView({super.key, required this.snippet});
  final Map<String, dynamic> snippet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History view"),
        actions: [
          IconButton(
              onPressed: () {
                Share.share(
                    "*Input:*\n${snippet["code"]}\n\n*Output: ${snippet["type"]}*\n${snippet["answer"]}");
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: SafeArea(
        child: BackgroundDecoration(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Input:",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 23,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: snippet["code"],
                                ),
                              ).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Copied input to Clipboard"),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              color: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CodeField(
                        controller: CodeController(
                          text: snippet["code"],
                        ),
                        readOnly: true,
                        textStyle: Theme.of(context).textTheme.displayMedium,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${snippet["type"].toString() == "convert" ? snippet["language"] : snippet["type"]}:",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 23,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: snippet["answer"],
                                ),
                              ).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Copied ${snippet["type"]} to Clipboard"),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              color: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        snippet["answer"],
                        style: Theme.of(context).textTheme.displayMedium!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
