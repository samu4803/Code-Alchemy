import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/snippets/userrequests.dart';
import 'package:flutter/material.dart';

class ListOfLanguages extends StatefulWidget {
  const ListOfLanguages({
    super.key,
  });
  @override
  State<ListOfLanguages> createState() => _ListOfLanguagesState();
}

class _ListOfLanguagesState extends State<ListOfLanguages> {
  final languages = [
    "c",
    "c++",
    "c#",
    "python",
    "php",
    "java",
    "r",
    "go",
    "javaScript",
    "html",
    "css",
    "kotlin",
    "pascal",
    "dart",
    "swift",
    "rust",
    "react",
    "assembly",
    "perl",
    "ruby",
    "react Js",
    "node Js",
    "typescript",
    "scala",
    "lua",
  ];
  String searchedValue = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Convert To",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 25,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              onChanged: (value) {
                searchedValue = value;
                setState(() {});
              },
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.surfaceVariant,
              ),
              textStyle: MaterialStatePropertyAll(
                Theme.of(context).textTheme.displayMedium!,
              ),
              hintStyle: MaterialStatePropertyAll(
                Theme.of(context).textTheme.displayMedium!,
              ),
              hintText: "search",
              leading: const Icon(Icons.search),
            ),
          ),
          SizedBox(
            height: 550,
            child: GridView(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 50,
              ),
              children: [
                for (var ele in languages.where(
                  (element) => element.contains(searchedValue),
                ))
                  CustomButton(
                    name: ele,
                    onTap: () {
                      InitialData.instance.to = ele;
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
