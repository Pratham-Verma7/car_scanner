import 'dart:convert';
import 'dart:io';

import 'package:card_scanner/screens/SavedDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card.dart';

class DetailsScreen extends StatefulWidget {
  final BusinessCard businessCard;
  final File imageFile;

  const DetailsScreen({
    Key? key,
    required this.businessCard,
    required this.imageFile,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController positionController;
  late TextEditingController companyController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController websiteController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.businessCard.name);
    positionController =
        TextEditingController(text: widget.businessCard.position);
    companyController =
        TextEditingController(text: widget.businessCard.company);
    emailController = TextEditingController(text: widget.businessCard.email);
    phoneController = TextEditingController(text: widget.businessCard.phone);
    websiteController =
        TextEditingController(text: widget.businessCard.website);
    addressController =
        TextEditingController(text: widget.businessCard.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    positionController.dispose();
    companyController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    final prefs = await SharedPreferences.getInstance();

    // Create a map to store the current details and image path
    Map<String, String> cardDetails = {
      'name': nameController.text,
      'position': positionController.text,
      'company': companyController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'website': websiteController.text,
      'address': addressController.text,
      'imagePath': widget.imageFile.path,
    };

    // Retrieve the existing history from SharedPreferences
    List<String> history = prefs.getStringList('businessCardHistory') ?? [];

    // Add the current card details to the history
    history.add(jsonEncode(cardDetails));

    // Save the updated history back to SharedPreferences
    await prefs.setStringList('businessCardHistory', history);

    // Navigate to the history page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavedDetailsScreen()),
    );
  }

  Widget _buildEditableCard(String label, TextEditingController controller) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: controller,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              minLines: 1,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Card Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEditableCard('Name', nameController),
                  _buildEditableCard('Position', positionController),
                  _buildEditableCard('Company', companyController),
                  _buildEditableCard('Email', emailController),
                  _buildEditableCard('Phone', phoneController),
                  _buildEditableCard('Website', websiteController),
                  _buildEditableCard('Address', addressController),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveDetails,
        label: Text('Save'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
