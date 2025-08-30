import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class CustomIntro extends StatelessWidget {
  const CustomIntro({
    super.key,
    required this.order,
    required this.text,
    required this.builder,
    this.last = false,
    this.onCalled,
  });
  final Widget Function(
      BuildContext context, GlobalKey<State<StatefulWidget>> key) builder;
  final int order;
  final String text;
  final bool last;
  final Function? onCalled;
  @override
  Widget build(BuildContext context) {
    return IntroStepBuilder(
      order: order,
      builder: builder,
      overlayBuilder: (params) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.all(1),
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (last) {
                    params.onFinish();
                  } else {
                    params.onNext!();
                  }
                  if (onCalled != null) {
                    onCalled!();
                  }
                },
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                  ),
                  shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.secondary),
                  maximumSize: const MaterialStatePropertyAll(Size(70, 29)),
                  minimumSize: const MaterialStatePropertyAll(Size(70, 29)),
                ),
                child: Text(
                  last == false ? "Next" : "Finish",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
