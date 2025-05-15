import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class DonorVerificationScreen extends StatefulWidget {
  const DonorVerificationScreen({super.key});

  @override
  State<DonorVerificationScreen> createState() => _DonorVerificationScreenState();
}

class _DonorVerificationScreenState extends State<DonorVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _characterCertificate;
  File? _disabilityCard;
  File? _studentCard;

  Future<void> _uploadFile(String fieldName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        switch (fieldName) {
          case 'character':
            _characterCertificate = file;
            break;
          case 'disability':
            _disabilityCard = file;
            break;
          case 'student':
            _studentCard = file;
            break;
        }
      });
    }
  }

  Future<String> _uploadToStorage(File file) async {
    String fileName = basename(file.path);
    Reference ref = FirebaseStorage.instance.ref().child('donor_documents/$fileName');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_characterCertificate == null) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Character certificate is required')),
        );
        return;
      }

      try {
        // Upload files
        String characterUrl = await _uploadToStorage(_characterCertificate!);
        String? disabilityUrl = _disabilityCard != null
            ? await _uploadToStorage(_disabilityCard!) : null;
        String? studentUrl = _studentCard != null
            ? await _uploadToStorage(_studentCard!) : null;

        // Save to Firestore
        await FirebaseFirestore.instance.collection('donor_verifications').add({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'cnic': _cnicController.text,
          'address': _addressController.text,
          'character_certificate': characterUrl,
          'disability_card': disabilityUrl,
          'student_card': studentUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
        });

        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Verification submitted successfully')),
        );
        Navigator.pop(context as BuildContext);
      } catch (e) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Error submitting form: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Verification'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnicController,
                decoration: const InputDecoration(
                  labelText: 'CNIC',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CNIC';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildFileUpload('Character Certificate', _characterCertificate, 'character'),
              const SizedBox(height: 16),
              _buildFileUpload('Disability Card (optional)', _disabilityCard, 'disability'),
              const SizedBox(height: 16),
              _buildFileUpload('Student Card (if applicable)', _studentCard, 'student'),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Submit Verification',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileUpload(String title, File? file, String fieldName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _uploadFile(fieldName),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_file),
              const SizedBox(width: 8),
              Text(file == null ? 'Upload File' : 'File Uploaded'),
            ],
          ),
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              basename(file.path),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}