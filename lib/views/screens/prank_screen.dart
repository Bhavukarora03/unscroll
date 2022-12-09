import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unscroll/constants.dart';
import 'package:unscroll/views/widgets/sharedprefs.dart';


class PrankScreen extends StatefulWidget {
  const PrankScreen({Key? key}) : super(key: key);

  @override
  State<PrankScreen> createState() => _PrankScreenState();
}

class _PrankScreenState extends State<PrankScreen> {
  @override
  void initState() {
    authController.checkIfTwentyFourHrsIsDone();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prank'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            ElevatedButton(
              onPressed: () async {
                TextPreferences.setTime(1800);
                SystemNavigator.pop();
              },
              child: const Text('Exit the App'),
            ),
          ],
        ),
      ),
    );
  }
}
