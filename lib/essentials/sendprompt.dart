import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/customintro.dart';
import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:codealchemy/popup/expirecredit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SendPrompt extends StatefulWidget {
  SendPrompt({
    super.key,
    required this.promptType,
  });
  final PromptType promptType;
  final GenerativeModel model = GenerativeModel(
    model: "gemini-2.5-pro",
    apiKey: "AIzaSyCcP6OeGQlNcZr20nppFUDb4raWGEmkzjk",
  );

  @override
  State<SendPrompt> createState() => _SendPromptState();
}

class _SendPromptState extends State<SendPrompt> {
  var answer = "";
  bool saved = false;
  @override
  Widget build(BuildContext context) {
    if (InitialData.instance.userData == null &&
        InitialData.instance.credits! <= 0) {
      return const BackgroundDecoration(
        child: ExpireCredit(),
      );
    }
    return FutureBuilder(
      future: askPrompt(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!saved) {
            saved = true;
            saveHistory(
              code: InitialData.instance.code!,
              type: widget.promptType,
              answer: answer,
              language: widget.promptType == PromptType.convert
                  ? InitialData.instance.to!
                  : "",
            );
          }
          if (InitialData.instance.justProcessed!) {
            Future.microtask(
              () => Intro.of(context).start(),
            );
            InitialData.instance.updateJustProcessed();
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Procressed",
              ),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: answer,
                      ),
                    ).then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Copied to Clipboard"),
                        ),
                      ),
                    );
                  },
                  icon: CustomIntro(
                    order: 2,
                    last: true,
                    text: "Click here to copy the result",
                    builder: (context, key) => Icon(
                      key: key,
                      Icons.copy,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            body: BackgroundDecoration(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "cross verify the generated result before using",
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 7,
                                ),
                      ),
                      CustomIntro(
                        order: 1,
                        text: "the processed result will be shown here",
                        builder: (context, key) => Container(
                          key: key,
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary,
                                blurRadius: 15,
                                blurStyle: BlurStyle.outer,
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.8),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              answer,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Material(
            child: BackgroundDecoration(
              child: Center(
                child: LoadingAnimation(),
              ),
            ),
          );
        }
      },
    );
  }

  askPrompt() async {
    if (answer == "" &&
        InitialData.instance.code != null &&
        InitialData.instance.code != "") {
      switch (widget.promptType) {
        case PromptType.convert:
          if (InitialData.instance.to != null) {
            final temp = await widget.model.generateContent([
              Content.text(
                  "Convert the program \"${InitialData.instance.code}\" into ${InitialData.instance.to} having necessory import files, without any comments, in the format of declaring every required variables first")
            ]);
            answer = temp.text!;
            answer = answer
                .split("\n")
                .getRange(1, answer.split("\n").length - 1)
                .join("\n");
            answer = answer.split("`").join();
          }
          if (InitialData.instance.userData == null) {
            await InitialData.instance.updateCredits();
          }
          break;

        case PromptType.explain:
          final temp = await widget.model.generateContent([
            Content.text(
                "Explain what this program does \"${InitialData.instance.code}\" ")
          ]);
          answer = temp.text!;
          if (InitialData.instance.userData == null) {
            await InitialData.instance.updateCredits();
          }
          break;

        case PromptType.debug:
          final temp = await widget.model.generateContent([
            Content.text(
                "Check if the program is correct or not \"${InitialData.instance.code}\" in the form of bullet")
          ]);
          answer = temp.text!;
          var splitAnswer = answer.split("\n");
          splitAnswer.removeWhere((element) => element == "\n");
          answer = splitAnswer.join();
          if (InitialData.instance.userData == null) {
            await InitialData.instance.updateCredits();
          }
          break;
      }
    }
  }
}

enum PromptType { convert, explain, debug }
