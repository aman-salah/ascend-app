import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: Center(
          child: Text(
            'Goals 🎯',
            style: GoogleFonts.literata(
              fontSize: 24,
              color: const Color(0xFF2E3230),
            ),
          ),
        ),
      ),
    );
  }
}
