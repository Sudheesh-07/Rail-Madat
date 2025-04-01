import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddComplaint extends StatefulWidget {
  const AddComplaint({super.key});

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Register Complaint", style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600),),
        centerTitle: true,
        backgroundColor: Color(0xff6A8DFF),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        )
      ),
    );
  }
}