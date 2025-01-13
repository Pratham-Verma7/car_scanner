import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class CameraService {
  CameraController? controller;
  bool get isInitialized => controller?.value.isInitialized ?? false;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller?.initialize();
  }

  Future<File?> captureAndCrop() async {
    if (!isInitialized) return null;

    final image = await controller!.takePicture();
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Business Card',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Business Card',
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }

  void dispose() {
    controller?.dispose();
  }
}
