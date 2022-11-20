import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:unscroll/constants.dart';

class PrankScreen extends StatefulWidget {
   PrankScreen({Key? key}) : super(key: key);

  @override
  State<PrankScreen> createState() => _PrankScreenState();
}

class _PrankScreenState extends State<PrankScreen> with WidgetsBindingObserver {

  bool active = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromHour(24),
    onEnded: () async{
      await firebaseFirestore.collection('users').doc(firebaseAuth.currentUser!.uid).update(
          {
            'thirtyMinDone': false,

          });

    },
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      active = true;
      _stopWatchTimer.onStartTimer();

    } else if (state == AppLifecycleState.inactive) {
      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.paused) {
      active = false;
      _stopWatchTimer.onStopTimer();
    } else if (state == AppLifecycleState.detached) {
      active = false;
      _stopWatchTimer.onStopTimer();
    }

  }

  _checkthirtyMins()async{
    await firebaseFirestore.collection('users').doc(firebaseAuth.currentUser!.uid).get().then((value) {
      if(value.data()!['thirtyMinDone'] == true){
        if(active){
          setState(() {
            _stopWatchTimer.onStartTimer();
          });
        }
      }
    });
  }

  @override
  void initState() {
   _checkthirtyMins();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
           const  Text(
              'Wait for next 24 to get access to your account',
            ),
            timer()
          ],
        ),
      ),
    );
  }

   Widget timer(){
     return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
         StreamBuilder<int>(
           stream: _stopWatchTimer.rawTime,
           initialData: _stopWatchTimer.rawTime.value,
           builder: (context, snap) {
             final value = snap.data!;
             final displayTime = StopWatchTimer.getDisplayTime(value,
                 milliSecond: false);
             return Column(
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.lock_clock),
                     Padding(
                       padding: const EdgeInsets.all(8),
                       child: Text(
                         displayTime,
                         style: const TextStyle(
                             fontSize: 25,
                             fontWeight: FontWeight.bold),
                       ),
                     ),
                   ],
                 ),
               ],
             );
           },
         ),
       ],
     );
   }
}
