import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rail_madat/pages/home_page.dart';

class ConfrimationPage extends StatefulWidget {
  const ConfrimationPage({super.key});

  @override
  State<ConfrimationPage> createState() => _ConfrimationPageState();
}

class _ConfrimationPageState extends State<ConfrimationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: DotLottieLoader.fromAsset(
                "assets/animations/confirmation.lottie",
                frameBuilder: (ctx, dotlottie) {
                  if (dotlottie != null) {
                    return Lottie.memory(dotlottie.animations.values.single);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50,right: 20),
            child: Text("Your complaint has been submitted successfully",style: GoogleFonts.poppins(fontSize: 20,)),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){Get.offAll(() => const HomePage());}, child: Text("Done"))
        ],
      ),
    );
  }
}
