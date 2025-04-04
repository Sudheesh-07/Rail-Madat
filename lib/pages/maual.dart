import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rail_madat/pages/confirmation_page.dart';

class ManualComplaintPage extends StatefulWidget {
  const ManualComplaintPage({super.key});

  @override
  State<ManualComplaintPage> createState() => _ManualComplaintPageState();
}

class _ManualComplaintPageState extends State<ManualComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pnrController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GetStorage _storage = GetStorage();
  String? _selectedComplaintType;
  File? _complaintImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  final List<String> _complaintTypes = [
    'Medical assistance',
    'Security',
    'Divyang facilities',
    'Facility for women with Special needs',
    'Electrical equipments',
    'Cleanliness',
    'Staff complaint',
    'Water availability',
    'Corruption',
    'Miscellaneous',
  ];

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final String email =
            _storage.read('email') ?? 'nadarharish03@gmail.com';
        if (email.isEmpty) {
          throw Exception('User email not found');
        }

        // Create the complaint data
        final Map<String, dynamic> complaintData = {
          "pnr": _pnrController.text.trim(),
          "email": email,
          "complaint_type": _selectedComplaintType,
          "complaint_description": _descriptionController.text.trim(),
        };

        // Create the multipart request
        final Uri uri = Uri.parse('http://192.168.0.108:8000/user/complaint/');
        final http.MultipartRequest request = http.MultipartRequest(
          'POST',
          uri,
        );

        // Add fields
        request.fields.addAll({'data': json.encode(complaintData)});

        // Add image if available
        // if (_complaintImage != null) {
        //   request.files.add(
        //     await http.MultipartFile.fromPath('image', _complaintImage!.path),
        //   );
        // }

        // Send the request
        final response = await http.post(
          Uri.parse('http://192.168.0.108:8000/user/complaint/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(complaintData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.to(() => ConfrimationPage());
          // Clear the form after successful submission
          _formKey.currentState!.reset();
          setState(() {
            _complaintImage = null;
            _selectedComplaintType = null;
          });
        } else {
          throw Exception('Failed to submit complaint: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _complaintImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _pnrController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Manual Complaint'),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _pnrController,
                        decoration: const InputDecoration(
                          labelText: 'PNR Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.confirmation_number),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your PNR number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Type of Complaint',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedComplaintType,
                            isExpanded: true,
                            hint: const Text('Select complaint type'),
                            items:
                                _complaintTypes.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedComplaintType = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your complaint';
                          }
                          if (value.length > 200) {
                            return 'Description should be brief (max 200 characters)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Upload Complaint Image (Optional):',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_complaintImage != null)
                        Column(
                          children: [
                            Image.file(
                              _complaintImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed:
                                  () => setState(() => _complaintImage = null),
                              child: const Text('Remove Image'),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _getImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Take Photo'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _getImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('From Gallery'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _submitComplaint,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Complaint',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
