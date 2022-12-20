import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber,
          onPressed: () async {
            final Uri _url =
                Uri.parse('https://www.buymeacoffee.com/bhavukarora');

            if (!await launchUrl(_url)) {
              throw 'Could not launch $_url';
            }
          },
          icon: const Icon(Icons.coffee),
          label: const Text('Buy me coffee!'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50),
              child: RichText(
                text: TextSpan(
                  text: 'About\n',
                  style: TextStyle(
                    color: authController.isLightTheme.value
                        ? Colors.black87
                        : Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Unscroll..\n',
                      style: GoogleFonts.cedarvilleCursive(
                          color: Colors.blueAccent,
                          fontSize: 50,
                          height: 1.5,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            height10,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Doomscrolling is a term used to describe the practice of continuously scrolling through social media or news feeds, "
                "often in an attempt to consume as much information as possible. "
                "This term is often used to describe the feeling of being overwhelmed by the constant flow of information and can be a source of stress and anxiety."
                "It is important to be mindful of the amount of time you spend doomscrolling, as it can have negative effects on your mental health and well-being. "
                "If you find that you are doomscrolling frequently, it may be helpful to set limits on your screen time and take breaks from social media and news feeds. "
                "Engaging in activities that help you relax and recharge can also be beneficial. "
                "It is also important to remember to take breaks and take care of your physical and mental health.\n\n\n\n"
                "If you find that doomscrolling is causing you to feel overwhelmed or anxious, there are a few steps you can take to try to control it:\n\n"
                "1. Set limits on your screen time: Consider setting limits on the amount of time you spend on social media and news feeds each day."
                " You can use a digital timer or app to help you stay on track.\n\n\n"
                "2. Take breaks from social media and news feeds: It can be helpful to take breaks from social media and news feeds. "
                "Consider setting aside a certain amount of time each day to check your social media and news feeds, and try to avoid checking them outside of that time.\n\n\n"
                "3. Engage in activities that help you relax and recharge: Engaging in activities that help you relax and recharge can be beneficial. "
                "Consider taking a walk, reading a book, or spending time with friends and family.\n\n\n"
                "4. Take care of your physical and mental health: It is important to take care of your physical and mental health. ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        )));
  }
}
