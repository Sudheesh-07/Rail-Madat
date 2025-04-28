import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rail_madat/pages/addcomplaint.dart';
import 'package:rail_madat/widgets/complaint_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetStorage _storage = GetStorage();
  List<Complaint> complaints = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final String? userId = _storage.read('user_id');
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await http.get(
        Uri.parse(
          'https://rail-madad-otq2.onrender.com/complaint/get-user-complaints/?user_id=$userId',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          complaints =
              responseData.map((json) => Complaint.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load complaints: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading complaints: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddComplaint());
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xff6A8DFF),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(0xff6A8DFF),
        title: Text(
          "Rail Madat",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchComplaints,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Complaints",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(color: Colors.black, thickness: 1),
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (errorMessage.isNotEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (complaints.isEmpty)
                const Expanded(
                  child: Center(child: Text("No complaints found")),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ComplaintCard(complaint: complaints[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this to your imports: import 'dart:convert';
class Complaint {
  final String id, type, description, status;
  final String? timestamp;

  Complaint({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    this.timestamp,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    id: json['complaint_id'] ?? 'N/A',
    type: json['complaint_type'] ?? 'Unknown',
    description: json['complaint_description'] ?? 'No description',
    status: json['status'] ?? 'Pending',
    timestamp: json['timestamp']?.toString(),
  );
}
