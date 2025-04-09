import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildUI() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
        child: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("session study goal",
                  style: GoogleFonts.arimo(
                    color: Colors.white,
                    fontSize: 14,
                  )),
              Text("Statistics and Probability",
                  style: GoogleFonts.arimo(
                    color: Colors.white,
                    fontSize: 20,
                  )),
            ],
          ),
          Spacer(),
          Text("Probing for life...",
              style: GoogleFonts.brunoAce(
                color: Colors.white,
                fontSize: 14,
              )),
          Text("Take a picture for this study session!",
              style: GoogleFonts.brunoAce(
                color: Colors.white,
                fontSize: 14,
              )),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          SizedBox.square(
            dimension: MediaQuery.sizeOf(context).width * 0.8,
            child: CameraPreview(cameraController!),
          ),
          IconButton(
              onPressed: () async {
                XFile picture = await cameraController!.takePicture();
                Gal.putImage(picture.path);
              },
              iconSize: 100,
              icon: const Icon(
                Icons.camera,
                color: Colors.deepPurple,
                size: 100,
              )),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text("Can't take a photo now. Skip",
                      style: GoogleFonts.brunoAce(
                          color: Colors.white,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white))),
              Text("This will damage astronaut's health",
                  style: GoogleFonts.brunoAce(
                    color: Colors.white,
                    fontSize: 14,
                  ))
            ],
          ),
          Spacer()
        ],
      ),
    ));
  }

  Future<void> _SetupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameras = cameras;
        cameraController =
            CameraController(cameras.first, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }
}
