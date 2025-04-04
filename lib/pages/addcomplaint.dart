import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rail_madat/pages/maual.dart';
import 'package:rail_madat/pages/using_ai.dart';

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
        title: Text(
          "Register Complaint",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff6A8DFF),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ContainedTabBarView(
        tabs: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [Text("Using AI"), Icon(Icons.auto_awesome)]),
          Text("                 Manually                  "),
        ], 

        views: [UsingAIPage(), ManualComplaintPage()],

        tabBarProperties: TabBarProperties(
            
        ),
      ),
    );
  }
}
