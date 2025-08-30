import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({super.key});
  @override
  Widget build(BuildContext context) {
    String feedback = "";
    int rating = 5;
    return BackgroundDecoration(
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Feedback",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: EmojiFeedback(
                elementSize: 40,
                showLabel: false,
                initialRating: rating,
                labelTextStyle: Theme.of(context).textTheme.displayMedium,
                onChanged: (value) {
                  rating = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: TextField(
                maxLength: 200,
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => feedback = value,
                decoration: InputDecoration(
                  hintText: "Feedback",
                  hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 15,
                      ),
                ),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if ((InitialData.instance.feedbackGiven!) == false) {
                        InitialData.instance.feedbackGiven = true;
                        InitialData.instance.updateFeedback(
                          feedback: feedback,
                          rating: rating,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Submit",
                      style: Theme.of(context).textTheme.displayMedium!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
