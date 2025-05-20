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
  bool _isSubmitting = false;

  Future<void> _uploadFile(String fieldName) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        if (result.files.single.size > 5 * 1024 * 1024) { // 5MB limit
          if (!mounted) return;
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text('File size must be less than 5MB')),
          );
          return;
        }

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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('File picker error: ${e.toString()}')),
      );
    }
  }

  Future<String?> _uploadToStorage(File? file) async {
    if (file == null) return null;

    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
      Reference ref = FirebaseStorage.instance.ref().child('donor_documents/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: ${e.toString()}');
    }
  }

  Future<void> _submitForm() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    if (_characterCertificate == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Character certificate is required')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    FocusScope.of(context as BuildContext).unfocus();

    try {
      // PARALLEL FILE UPLOADS
      final uploadResults = await Future.wait([
        _uploadToStorage(_characterCertificate),
        _uploadToStorage(_disabilityCard),
        _uploadToStorage(_studentCard),
      ]);

      // Save to Firestore
      await FirebaseFirestore.instance.collection('donor_verifications').add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'address': _addressController.text.trim(),
        'character_certificate': uploadResults[0], // Required
        'disability_card': uploadResults[1],       // Optional
        'student_card': uploadResults[2],          // Optional
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      // Clear form
      if (mounted) {
        _formKey.currentState!.reset();
        setState(() {
          _characterCertificate = null;
          _disabilityCard = null;
          _studentCard = null;
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Submission successful!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Verification'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name*',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number*',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.length < 10 ? 'Invalid number' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cnicController,
                  decoration: const InputDecoration(
                    labelText: 'CNIC*',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  validator: (value) => value!.length < 13 ? 'Invalid CNIC' : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address*',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                _buildFileUpload('Character Certificate*', _characterCertificate, 'character'),
                const SizedBox(height: 16),
                _buildFileUpload('Disability Card (optional)', _disabilityCard, 'disability'),
                const SizedBox(height: 16),
                _buildFileUpload('Student Card (if applicable)', _studentCard, 'student'),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: _isSubmitting
                      ? const SizedBox.shrink()
                      : const Icon(Icons.upload_file, color: Colors.white),
                  label: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Verification'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _isSubmitting ? null : _submitForm,
                ),
              ],
            ),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => _uploadFile(fieldName),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                file == null ? 'Choose File' : 'File Selected',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              basename(file.path),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
      ],
    );
  }
}