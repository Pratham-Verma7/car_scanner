import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import '../models/card.dart';

class TextRecognitionService {
  Future<BusinessCard> processImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    try {
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      return BusinessCard.fromText(recognizedText.text);
    } finally {
      textRecognizer.close();
    }
  }
}