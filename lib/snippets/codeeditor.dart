import 'package:code_text_field/code_text_field.dart';
import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/customintro.dart';
import 'package:flutter/material.dart';

class CodeEditor extends StatefulWidget {
  const CodeEditor({
    super.key,
  });
  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  bool enableEditor = false;
  @override
  Widget build(BuildContext context) {
    if (InitialData.instance.justInstalled!) {
      InitialData.instance.introductionStartContext = context;
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
        top: MediaQuery.of(context).size.height * 0.03,
        bottom: MediaQuery.of(context).size.height * 0.06,
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: CustomIntro(
            order: 1,
            text: "write your code here",
            builder: (context, key) => CodeField(
              key: key,
              focusNode: InitialData.instance.codeEditorFocusNode,
              controller: InitialData.instance.controller ?? CodeController(),
              cursorColor: Theme.of(context).colorScheme.secondary,
              minLines: 30,
              maxLines: 1000,
              onChanged: (value) => InitialData.instance.code = value,
              background: Colors.transparent,
              textStyle: Theme.of(context).textTheme.displayMedium,
              lineNumberStyle: LineNumberStyle(
                textStyle: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
