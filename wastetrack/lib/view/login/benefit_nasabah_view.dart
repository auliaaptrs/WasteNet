import 'package:flutter/material.dart';
import 'package:wastetrack/view/login/benefit_banksampah_view.dart';

class BenefitNasabahView extends StatefulWidget {
  const BenefitNasabahView({super.key});

  @override
  State<BenefitNasabahView> createState() => _BenefitNasabahViewState();
}

class _BenefitNasabahViewState extends State<BenefitNasabahView> {
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
              'assets/img/Campaign Nasabah.png',
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
            bottom: 87,
            left: 80,
            right: 80,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BenefitBanksampahView(),
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
