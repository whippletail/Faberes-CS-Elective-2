import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width < 600 ? 390 : 470,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.heroOverlayTop, AppColors.heroOverlayMiddle, AppColors.heroOverlayBottom],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.waves_rounded, color: AppColors.onHero, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Ride Your Wave',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.onHero,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -2,
                          shadows: const [Shadow(blurRadius: 16, color: AppColors.heroShadow)],
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tropical style. Shoreline speed.\nFind the skimboard made for your next adventure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onHero,
                      fontSize: 17,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => Scrollable.ensureVisible(
                      context,
                      duration: const Duration(milliseconds: 550),
                    ),
                    icon: const Icon(Icons.arrow_downward_rounded),
                    label: const Text('EXPLORE THE COLLECTION'),
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
