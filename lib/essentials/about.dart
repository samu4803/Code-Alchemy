import 'package:codealchemy/essentials/aboutcontent.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "About Us",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BackgroundDecoration(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Image.asset(
              "assets/logoV2.png",
              height: 125,
              width: 125,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "CodeAlchemy",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                    ),
                children: const [
                  TextSpan(
                    text: "\nVersion:1.1.3",
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const AboutContent(),
          ],
        ),
      ),
    );
  }
}
