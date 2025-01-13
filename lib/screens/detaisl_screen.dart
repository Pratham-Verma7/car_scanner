import 'dart:io';

import 'package:flutter/material.dart';

import '../models/card.dart';


class DetailsScreen extends StatelessWidget {
  final BusinessCard businessCard;
  final File imageFile;

  const DetailsScreen({
    Key? key,
    required this.businessCard,
    required this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            _buildDetailCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Name', businessCard.name),
            _buildDetailItem('Company', businessCard.company),
            _buildDetailItem('Email', businessCard.email),
            _buildDetailItem('Phone', businessCard.phone),
            if (businessCard.address.isNotEmpty)
              _buildDetailItem('Address', businessCard.address),
            if (businessCard.website.isNotEmpty)
              _buildDetailItem('Website', businessCard.website),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not Found' : value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}