import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';

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
        title: Text('Business Card Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSection(),
            _buildDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
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
          imageFile,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailItem(
            context,
            'Name',
            businessCard.name,
            Icons.person,
            canCopy: true,
          ),
          if (businessCard.position.isNotEmpty)
            _buildDetailItem(
              context,
              'Position',
              businessCard.position,
              Icons.work,
              canCopy: true,
            ),
          _buildDetailItem(
            context,
            'Company',
            businessCard.company,
            Icons.business,
            canCopy: true,
          ),
          _buildDetailItem(
            context,
            'Email',
            businessCard.email,
            Icons.email,
            canCopy: true,
            isEmail: true,
            additionalItems: businessCard.additionalEmails,
          ),
          _buildDetailItem(
            context,
            'Phone',
            businessCard.phone,
            Icons.phone,
            canCopy: true,
            isPhone: true,
            additionalItems: businessCard.additionalPhones,
          ),
          if (businessCard.website.isNotEmpty)
            _buildDetailItem(
              context,
              'Website',
              businessCard.website,
              Icons.language,
              canCopy: true,
              isWebsite: true,
            ),
          if (businessCard.address.isNotEmpty)
            _buildDetailItem(
              context,
              'Address',
              businessCard.address,
              Icons.location_on,
              canCopy: true,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context,
      String label,
      String value,
      IconData icon, {
        bool canCopy = false,
        bool isEmail = false,
        bool isPhone = false,
        bool isWebsite = false,
        List<String> additionalItems = const [],
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          _buildValueWidget(
            context,
            value,
            canCopy: canCopy,
            isEmail: isEmail,
            isPhone: isPhone,
            isWebsite: isWebsite,
          ),
          ...additionalItems.map((item) => Padding(
            padding: EdgeInsets.only(top: 4),
            child: _buildValueWidget(
              context,
              item,
              canCopy: canCopy,
              isEmail: isEmail,
              isPhone: isPhone,
              isWebsite: isWebsite,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildValueWidget(
      BuildContext context,
      String value, {
        bool canCopy = false,
        bool isEmail = false,
        bool isPhone = false,
        bool isWebsite = false,
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value.isEmpty ? 'Not available' : value,
            style: TextStyle(
              fontSize: 16,
              color: value.isEmpty ? Colors.grey : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (value.isNotEmpty && (isEmail || isPhone || isWebsite))
          IconButton(
            icon: Icon(
              isEmail ? Icons.email_outlined :
              isPhone ? Icons.phone_outlined :
              Icons.open_in_new,
              size: 20,
              color: Colors.blue,
            ),
            onPressed: () {
              if (isEmail) {
                _launchURL('mailto:$value');
              } else if (isPhone) {
                _launchURL('tel:$value');
              } else if (isWebsite) {
                _launchURL(value);
              }
            },
          ),
        if (value.isNotEmpty && canCopy)
          IconButton(
            icon: Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
      ],
    );
  }

  void _launchURL(String url) async {
    // Implement URL launching using url_launcher package
    // For this example, we'll just print the URL
    print('Launching URL: $url');
  }
}