import 'package:codealchemy/essentials/webpage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    ExpansionTile section({
      required String title,
      required List<InlineSpan> content,
      IconData icon = Icons.group,
    }) {
      return ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 19,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w100,
              ),
        ),
        shape: const Border(),
        collapsedIconColor: Theme.of(context).colorScheme.secondary,
        leading: Icon(
          icon,
        ),
        enableFeedback: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            child: Text.rich(
              TextSpan(
                children: content,
                style: Theme.of(context).textTheme.displayMedium!,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        section(
          title: "Website",
          content: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const WebPage(),
                    ),
                  );
                },
                onLongPress: () async {
                  await launchUrl(
                    Uri(
                      host: "aicode-ff349.web.app",
                      scheme: "https",
                    ),
                  );
                },
                child: Text(
                  "https://aicode-ff349.web.app/",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ),
          ],
          icon: Icons.language,
        ),
        section(
          title: "Mission",
          content: [
            const TextSpan(
              text:
                  "     At CodeAlchemy AI, our mission is to break down coding language barriers and empower developers of all levels to write and understand code across multiple programming languages seamlessly.",
            ),
          ],
          icon: Icons.trending_up,
        ),
        section(
          title: "Services",
          content: [
            const TextSpan(text: "*"),
            TextSpan(
              text: "Code Translation:\n",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
              text:
                  "\n     Effortlessly translate your code between 51 different programming languages, ensuring you can work in the language that best suits your needs or project requirements.\n",
            ),
            const TextSpan(text: "\n*"),
            TextSpan(
              text: "Code Debugging:\n",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
              text:
                  "\n     Identify and fix errors in your code with our advanced debugging tools, making the process smoother and more efficient.\n",
            ),
            const TextSpan(text: "\n*"),
            TextSpan(
              text: "Code Explanation:\n",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const TextSpan(
              text:
                  "\n     Gain a deeper understanding of complex code through detailed explanations provided by our AI.\n",
            ),
          ],
          icon: Icons.local_offer_outlined,
        ),
        section(
          title: "Story",
          content: [
            const TextSpan(
              text:
                  "     Developed as a final year project by Pratham P M, Pavan, and Sameerana S Bhat at Yuvaraja's College Mysuru, CodeAlchemy AI represents our dedication to making coding accessible to everyone.\n\n     The mobile app is developed with flutter while the website is built using react js and tailwind.\n\n     Both platforms are supported by a robust backend on firebase, ensuring scalability and reliability.",
            ),
          ],
          icon: Icons.history_edu,
        ),
        section(
            title: "Advantage",
            content: [
              const TextSpan(
                text:
                    "* CodeAlchemy AI is here to help you navigate these challenges, making coding an enjoyable and rewarding experience.\n",
              ),
              const TextSpan(
                text: "\n* Explore the world of coding without limits.\n",
              ),
              const TextSpan(
                text:
                    "\n* Whether you are a student, a beginner programmer, or someone looking to expand your coding skills, CodeAlchemy AI is here to support your journey.",
              ),
            ],
            icon: Icons.verified_user_outlined),
        section(
          title: "Our Team",
          content: [
            const TextSpan(
              text: "* Pratham P M\n* Pavan\n* Sameerana S Bhat",
            ),
          ],
        ),
      ],
    );
  }
}
