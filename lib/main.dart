import 'package:fasten_stitch_element_flutter/fasten_stitch_element.dart';
import 'package:flutter/material.dart';

const customerPublicId = 'public_test_6f5j7qj54rlyajv6u8r36z0iu5v9qjf87f77tzl3k6ezu';

void main() {
  runApp(const FastenPlaygroundApp());
}

class FastenPlaygroundApp extends StatelessWidget {
  const FastenPlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fasten Flutter Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E7A78)),
        useMaterial3: true,
      ),
      home: const FastenPlaygroundScreen(),
    );
  }
}

class FastenPlaygroundScreen extends StatefulWidget {
  const FastenPlaygroundScreen({super.key});

  @override
  State<FastenPlaygroundScreen> createState() => _FastenPlaygroundScreenState();
}

class _FastenPlaygroundScreenState extends State<FastenPlaygroundScreen> {
  var _reloadCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fasten Connect'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _reloadCount += 1;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ColoredBox(
          color: Colors.white,
          child: FastenStitchElement(
            key: ValueKey(_reloadCount),
            publicId: customerPublicId,
            // tefcaMode: true,
            // tefcaCspPromptForce: true,
            debugModeEnabled: true,
            onEventBus: (event) {
              debugPrint('[FastenStitchElement onEventBus] message $event');
            },
          ),
        ),
      ),
    );
  }
}
