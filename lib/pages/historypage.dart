import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:codealchemy/snippets/historycardview.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: BackgroundDecoration(
        child: FutureBuilder(
          future: getHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(),
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "You dont have any history",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView(
                  children: [
                    for (var i in snapshot.data!.keys)
                      Dismissible(
                        key: Key(
                          i.toString(),
                        ),
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              title: Text(
                                "Confirm Delete",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontSize: 23,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    "Cancel",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    "Confirm",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (direction) {
                          snapshot.data!.remove(i);
                          removeSessionHistory(
                            snapshot.data!,
                          );
                        },
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => HistoryCardView(
                                    snippet: snapshot.data![i],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Theme.of(context).colorScheme.tertiary,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: double.maxFinite,
                                    ),
                                    Text(
                                      snapshot.data![i]["type"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                      snapshot.data![i]["code"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
