import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F0),
      body: SafeArea(
        child: Center(
          child: Text(
            'Library 📚',
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
