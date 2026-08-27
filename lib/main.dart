import 'package:fasten_stitch_element_flutter/fasten_stitch_element.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const customerPublicId =
    'public_test_6f5j7qj54rlyajv6u8r36z0iu5v9qjf87f77tzl3k6ezu';

const tefcaMode = true;

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
  var _workflowStarted = !tefcaMode;
  var _checkingPermissions = tefcaMode;
  var _requestingPermissions = false;
  var _permissionsPermanentlyDenied = false;
  String? _permissionError;

  bool get _requiresNativePermissions =>
      tefcaMode &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();

    if (_requiresNativePermissions) {
      _checkExistingPermissions();
    } else {
      _checkingPermissions = false;
      _workflowStarted = true;
    }
  }

  Future<void> _checkExistingPermissions() async {
    final statuses = await Future.wait([
      Permission.camera.status,
      Permission.microphone.status,
    ]);
    if (!mounted) return;

    setState(() {
      _checkingPermissions = false;
      _workflowStarted = statuses.every((status) => status.isGranted);
      _permissionsPermanentlyDenied =
          statuses.any((status) => status.isPermanentlyDenied);
    });
  }

  Future<void> _startWorkflow() async {
    if (!_requiresNativePermissions) {
      setState(() => _workflowStarted = true);
      return;
    }

    setState(() {
      _requestingPermissions = true;
      _permissionError = null;
    });

    final statuses = await [Permission.camera, Permission.microphone].request();
    if (!mounted) return;

    final allGranted = statuses.values.every((status) => status.isGranted);
    final permanentlyDenied =
        statuses.values.any((status) => status.isPermanentlyDenied);

    setState(() {
      _requestingPermissions = false;
      _permissionsPermanentlyDenied = permanentlyDenied;
      _workflowStarted = allGranted;
      if (!allGranted) {
        _permissionError = permanentlyDenied
            ? 'Enable camera and microphone access in Settings to continue.'
            : 'Camera and microphone access are required to continue.';
      }
    });
  }

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
        child: _checkingPermissions
            ? const Center(child: CircularProgressIndicator())
            : _workflowStarted
                ? ColoredBox(
                    color: Colors.white,
                    child: FastenStitchElement(
                      key: ValueKey(_reloadCount),
                      publicId: customerPublicId,
                      tefcaMode: tefcaMode,
                      // tefcaCspPromptForce: true,
                      debugModeEnabled: true,
                      onEventBus: (event) {
                        debugPrint(
                          '[FastenStitchElement onEventBus] message $event',
                        );
                      },
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.video_camera_front, size: 56),
                          const SizedBox(height: 16),
                          const Text(
                            'Camera and microphone access are required for identity verification.',
                            textAlign: TextAlign.center,
                          ),
                          if (_permissionError case final error?) ...[
                            const SizedBox(height: 12),
                            Text(
                              error,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF4936E8),
                              foregroundColor: Colors.white,
                            ),
                            onPressed:
                                _requestingPermissions ? null : _startWorkflow,
                            child: Text(
                              _requestingPermissions
                                  ? 'Requesting access…'
                                  : 'Accept Permissions',
                            ),
                          ),
                          if (_permissionsPermanentlyDenied) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: openAppSettings,
                              child: const Text('Open Settings'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
