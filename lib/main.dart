import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'NextPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'タイマー'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _second = 0;
  int _msecond = 0;
  int _minute = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  // ignore: non_constant_identifier_names
  String _formatNumber(int number) {
    return NumberFormat('00').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_formatNumber(_minute)}:${_formatNumber(_second)}.${_formatNumber(_msecond)}',
              style: const TextStyle(fontSize: 80),
            ),
            ElevatedButton(
              onPressed: () {
                toggleTimer();
              },
              child: Text(_isRunning ? 'ストップ' : 'スタート',
                  style: TextStyle(
                      color: _isRunning ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                resetTimer();
              },
              child: const Text('リセット',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(
        const Duration(milliseconds: 10),
        (timer) {
          setState(() {
            _msecond++;
            if (_msecond >= 100) {
              _second++;
              _msecond = 0;
            }
            if (_second >= 60) {
              _minute++;
              _second = 0;
            }
          });

          if (_second == 10000000) {
            resetTimer();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NextPage()),
            );
          }
        },
      );
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _msecond = 0;
      _second = 0;
      _minute = 0;
      _isRunning = false;
    });
  }
}
