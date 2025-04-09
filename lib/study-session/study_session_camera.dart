import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class StudySessionCamera extends StatefulWidget {
  const StudySessionCamera({super.key});

  @override
  State<StudySessionCamera> createState() {
    return _StudySessionCameraState();
  }
}

class _StudySessionCameraState extends State<StudySessionCamera> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    _SetupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(child: SizedBox.expand());
  }

  Future<void> _SetupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController =
            CameraController(_cameras.first, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
        setState(() {

        });
      });
    }
  }
}
