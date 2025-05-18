import 'package:flutter/material.dart';
import 'package:wastetrack/view/login/welcome_view.dart';

class BenefitWebsiteView extends StatefulWidget {
  const BenefitWebsiteView({super.key});

  @override
  State<BenefitWebsiteView> createState() => _BenefitWebsiteViewState();
}

class _BenefitWebsiteViewState extends State<BenefitWebsiteView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: media.width,
            height: media.height,
            child: Image.asset(
              'assets/img/Benefit Website.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.6),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          Positioned(
            bottom: 150,
            left: media.width / 2 - 30, 
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () { },
                icon: Image.asset(
                  'assets/img/app_logo.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 87,
            left: 80,
            right: 80,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000000),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Selanjutnya",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
