import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const WalletApp());
}

class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet UI',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF8F7F3),
      ),
      home: const WalletHomePage(),
    );
  }
}

class WalletHomePage extends StatelessWidget {
  const WalletHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFF8F7F3),
          child: Column(
            children: [
              // ==============================
              // TOP PROFILE / BALANCE SECTION
              // ==============================
              SizedBox(height: size.height * 0.49, child: const WalletHeader()),

              // ==============================
              // TRANSACTION SECTION
              // ==============================
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F7F3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: const OverviewSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Stack(
        children: [
          // Dark base
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF10151D)),
          ),

          // Blue glow - top left
          Positioned(
            left: -80,
            top: -100,
            child: _GlowCircle(
              size: 300,
              color: const Color(0xFF169FFF),
              opacity: 0.9,
            ),
          ),

          // Blue glow - top right
          Positioned(
            right: -100,
            top: 30,
            child: _GlowCircle(
              size: 250,
              color: const Color(0xFF00B8FF),
              opacity: 0.7,
            ),
          ),

          // Blue glow - bottom right
          Positioned(
            right: -80,
            bottom: -80,
            child: _GlowCircle(
              size: 230,
              color: const Color(0xFF158CFF),
              opacity: 0.7,
            ),
          ),

          // Dark overlay / blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withOpacity(0.12)),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.015),
              child: Column(
                children: [
                  // Dynamic Island style shape
                  Container(
                    width: 125,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),

                  // Avatar
                  const ProfileAvatar(),

                  SizedBox(height: size.height * 0.018),

                  // Name
                  const Text(
                    'Johnny Depp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Account ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rmcx_dn8v87d_jh8589',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.content_copy_rounded,
                        color: Colors.white.withOpacity(0.65),
                        size: 14,
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.038),

                  // Balance label
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Balance
                  const Text(
                    '\$98,325',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GLOW CIRCLE
// ============================================================

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE AVATAR
// ============================================================

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 105,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Image.asset(
              'memojiz/p1.png',
              width: 75,
              height: 75,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// OVERVIEW SECTION
// ============================================================

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview title
          const Text(
            'Overview',
            style: TextStyle(
              color: Color(0xFF272727),
              fontSize: 21,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 18),

          // Transaction 1
          TransactionTile(
            avatar: 'memojiz/p2.png',
            title: 'Received Money',
            date: 'November 02, 2023',
            amount: '+ \$213.00',
            time: '10:12 PM',
          ),

          const SizedBox(height: 15),

          // Transaction 2
          TransactionTile(
            avatar: 'memojiz/p3.png',
            title: 'Received Money',
            date: 'October 29, 2023',
            amount: '+ \$102.00',
            time: '10:12 PM',
          ),

          const SizedBox(height: 15),

          // Transaction 3
          TransactionTile(
            avatar: 'memojiz/p4.png',
            title: 'Received Money',
            date: 'October 16, 2023',
            amount: '+ \$300.00',
            time: '10:12 PM',
          ),

          const SizedBox(height: 15),

          // Transaction 4
          TransactionTile(
            avatar: 'memojiz/p5.png',
            title: 'Received Money',
            date: 'October 10, 2023',
            amount: '+ \$450.00',
            time: '9:42 PM',
          ),

          const SizedBox(height: 15),

          // Transaction 5
          TransactionTile(
            avatar: 'memojiz/p6.png',
            title: 'Received Money',
            date: 'October 04, 2023',
            amount: '+ \$125.00',
            time: '8:31 PM',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TRANSACTION TILE
// ============================================================

class TransactionTile extends StatelessWidget {
  final String avatar;
  final String title;
  final String date;
  final String amount;
  final String time;

  const TransactionTile({
    super.key,
    required this.avatar,
    required this.title,
    required this.date,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Row(
        children: [
          // Avatar background
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F0E9),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Image.asset(
                avatar,
                width: 45,
                height: 45,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 13),

          // Middle content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF202020),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Right content
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Color(0xFF202020),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF9A9A9A),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
