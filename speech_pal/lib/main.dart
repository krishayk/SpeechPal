import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeechPal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const MyHomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'SpeechPal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isRecording = false;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? arduinoDevice;

  void _toggleRecording() async {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      await sendCommandToArduino('START_RECORDING');
    } else {
      await sendCommandToArduino('STOP_RECORDING');
    }
  }

  Future<void> sendCommandToArduino(String command) async {
    if (arduinoDevice != null) {
      List<BluetoothService> services = await arduinoDevice!.discoverServices();
      services.forEach((service) {
        if (service.uuid.toString() == 'YOUR_SERVICE_UUID') { // Replace with your Arduino service UUID
          service.characteristics.forEach((characteristic) async {
            if (characteristic.uuid.toString() == 'YOUR_CHARACTERISTIC_UUID') { // Replace with your Arduino characteristic UUID
              await characteristic.write(utf8.encode(command));
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpeechPal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _toggleRecording,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isRecording ? 'Recording...' : 'Tap to start recording',
              style: const TextStyle(fontSize: 20),
            ),
            if (!_isRecording) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const PresentationTypeScreen(),
                    ),
                  );
                },
                child: const Text('Continue'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PresentationTypeScreen extends StatelessWidget {
  const PresentationTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What type of presentation are you looking for?'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _navigateToResultScreen(context, 'Casual');
              },
              child: const Text('Casual'),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToResultScreen(context, 'Formal');
              },
              child: const Text('Formal'),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToResultScreen(context, 'Debate');
              },
              child: const Text('Debate'),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToResultScreen(context, 'Etc.');
              },
              child: const Text('Etc.'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToResultScreen(BuildContext context, String presentationType) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Are you sure you want a $presentationType presentation?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoadingScreen(),
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const ResultScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Here is the result of your presentation. This is just filler text for now.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
