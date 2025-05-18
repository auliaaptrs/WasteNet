import 'package:flutter/material.dart';
import 'package:wastetrack/view/login/benefit_nasabah_view.dart';

class PerkenalanView extends StatefulWidget {
  const PerkenalanView({super.key});

  @override
  State<PerkenalanView> createState() => _PerkenalanViewState();
}

class _PerkenalanViewState extends State<PerkenalanView> {
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
              'assets/img/Perkenalan.png',
              fit: BoxFit.cover,
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
                    builder: (context) => const BenefitNasabahView(),
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
