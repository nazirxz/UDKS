import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimationTop; // Untuk teks atas
  late Animation<Offset> _slideAnimationBottom; // Untuk teks bawah
  late Animation<double> _fadeAnimation; // Untuk logo

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800), // Durasi sedikit lebih panjang
      vsync: this,
    );

    // Animasi geser dari atas ke posisi tengah
    _slideAnimationTop = Tween<Offset>(
      begin: const Offset(0, -0.5), // Mulai dari atas
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // Kurva yang mulus dan cepat
    ));

    // Animasi geser dari bawah ke posisi tengah
    _slideAnimationBottom = Tween<Offset>(
      begin: const Offset(0, 0.5), // Mulai dari bawah
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Animasi fade in untuk logo
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn), // Muncul setelah slide dimulai
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () { // Total durasi tetap 4 detik
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00809D), // Teal/Biru Kehijauan Tua
              Color(0xFFF3A26D), // Oranye Peach/Salmon
            ],
            stops: [0.1, 0.9],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Teks "Usaha Distributor" dengan Slide dan Fade
              SlideTransition(
                position: _slideAnimationTop,
                child: FadeTransition(
                  opacity: _fadeAnimation, // Menggunakan fade yang sama untuk kemunculan
                  child: const Text(
                    'Usaha Distributor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Logo "KS" dengan Fade (tanpa scale untuk tampilan lebih minimalis)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7601).withOpacity(0.8), // Oranye Cerah agak transparan
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'KS',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Teks "KELUARGA SEHATI" dengan Slide dan Fade
              SlideTransition(
                position: _slideAnimationBottom,
                child: FadeTransition(
                  opacity: _fadeAnimation, // Menggunakan fade yang sama untuk kemunculan
                  child: const Text(
                    'KELUARGA SEHATI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: const Color(0xFFFCECDD).withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}