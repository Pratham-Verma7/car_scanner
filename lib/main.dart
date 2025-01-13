import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:cropper/cropper.dart';
import 'dart:io';

void main() => runApp(BusinessCardScannerApp());

class BusinessCardScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FullScreenCamera(),
    );
  }
}

class FullScreenCamera extends StatefulWidget {
  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  File? _capturedImage;
  Map<String, String> _recognizedDetails = {};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
      showErrorDialog('Camera initialization failed. Please try again.');
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      showErrorDialog('Camera is not ready.');
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _capturedImage = File(croppedFile.path);
        });
        _recognizeText(File(croppedFile.path));
      }
    } catch (e) {
      print('Error capturing image: $e');
      showErrorDialog('Failed to capture image.');
    }
  }

  Future<void> _recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    try {
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      // Parse details from text
      final details = _parseText(recognizedText.text);
      setState(() {
        _recognizedDetails = details;
      });
    } catch (e) {
      print('Error recognizing text: $e');
      showErrorDialog('Failed to recognize text.');
    } finally {
      textRecognizer.close();
    }
  }

  Map<String, String> _parseText(String text) {
    Map<String, String> details = {};

    final nameRegEx = RegExp(r'Name:\s*([A-Za-z ]+)', caseSensitive: false);
    final phoneRegEx = RegExp(r'(?:Phone|Mobile):\s*(\+?\d+)', caseSensitive: false);
    final emailRegEx = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b');
    final companyRegEx = RegExp(r'Company:\s*([A-Za-z ]+)', caseSensitive: false);

    details['Name'] = nameRegEx.firstMatch(text)?.group(1) ?? 'Not Found';
    details['Phone'] = phoneRegEx.firstMatch(text)?.group(1) ?? 'Not Found';
    details['Email'] = emailRegEx.firstMatch(text)?.group(0) ?? 'Not Found';
    details['Company'] = companyRegEx.firstMatch(text)?.group(1) ?? 'Not Found';

    return details;
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isCameraInitialized && _cameraController != null)
            CameraPreview(_cameraController!)
          else
            Center(
              child: CircularProgressIndicator(),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _captureImage,
                child: Text('Capture Card'),
              ),
            ),
          ),
          if (_capturedImage != null)
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white.withOpacity(0.9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(
                      _capturedImage!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Text('Extracted Details:', style: TextStyle(fontSize: 18)),
                    ..._recognizedDetails.entries.map((entry) => ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                    )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
