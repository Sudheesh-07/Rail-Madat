import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UsingAIPage extends StatefulWidget {
  const UsingAIPage({super.key});

  @override
  State<UsingAIPage> createState() => _UsingAIPageState();
}

class _UsingAIPageState extends State<UsingAIPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pnrController = TextEditingController();
  File? _complaintImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _complaintImage = File(pickedFile.path);
      });
    }
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      if (_complaintImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload an image of your complaint'),
          ),
        );
        return;
      }

      // Here you would typically send the data to your backend
      print('PNR: ${_pnrController.text}');
      print('Image path: ${_complaintImage!.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
      );
    }
  }

  @override
  void dispose() {
    _pnrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: const Text('Raise Complaint')),
      body: SingleChildScrollView(
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
              const SizedBox(height: 30),
              const Text(
                'Upload Complaint Image:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      onPressed: () => setState(() => _complaintImage = null),
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
              const SizedBox(height: 40),
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
