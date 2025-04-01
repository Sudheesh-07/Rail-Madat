import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rail_madat/addcomplaint.dart';
import 'package:rail_madat/widgets/complaint_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Complaint> complaints = [
    Complaint(title: "Complaint 1", description: "This is a complaint."),
    Complaint(title: "Complaint 2", description: "This is another complaint."),
    Complaint(
      title: "Complaint 3",
      description: "This is yet another complaint.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddComplaint());
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Color(0xff6A8DFF),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0xff6A8DFF),
        title: Text(
          "Rail Madat",
          style: GoogleFonts.poppins(color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Text(
                "Complaints",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(color: Colors.black, thickness: 1),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  return ComplaintCard(complainttitle: complaints[index].title);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Complaint {
  final String title;
  final String description;

  const Complaint({required this.title, required this.description});
}
