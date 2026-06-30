import 'package:flutter/material.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../driver/presentation/screens/main/driver_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const route = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────
  late final AnimationController _bikeCtrl;   // bike slide-in
  late final AnimationController _pulseCtrl;  // glow pulse (repeating)
  late final AnimationController _textCtrl;   // text fade-up
  late final AnimationController _roadCtrl;   // road line expand

  // ── Animations ─────────────────────────────────────────────────────────────
  late final Animation<double> _bikeX;
  late final Animation<double> _bikeScale;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;
  late final Animation<double> _textFade;
  late final Animation<double> _textY;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _roadProgress;

  @override
  void initState() {
    super.initState();

    _bikeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _roadCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Bike slides in from the left, bounces slightly
    _bikeX = Tween<double>(begin: -1.6, end: 0).animate(
      CurvedAnimation(parent: _bikeCtrl, curve: Curves.easeOutCubic),
    );
    _bikeScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _bikeCtrl, curve: Curves.easeOutBack),
    );

    // Glow ring behind the icon
    _pulseScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Title + subtitle cascade
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );
    _textY = Tween<double>(begin: 28, end: 0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    // Teal road line that widens out from center
    _roadProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _roadCtrl, curve: Curves.easeOut),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 350));
    _roadCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 180));
    await _bikeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    await _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const DriverMainScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _bikeCtrl.dispose();
    _pulseCtrl.dispose();
    _textCtrl.dispose();
    _roadCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // ── Radial background glow ────────────────────────────────────────
          Center(
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.bgDeep.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // ── Road / track line ─────────────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _roadCtrl,
              builder: (_, _) => Container(
                width: w * 0.65 * _roadProgress.value,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0),
                      AppColors.primary.withValues(alpha: 0.6),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),

          // ── Centre content ────────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bike icon
                AnimatedBuilder(
                  animation: Listenable.merge([_bikeCtrl, _pulseCtrl]),
                  builder: (_, _) => FractionalTranslation(
                    translation: Offset(_bikeX.value, 0),
                    child: Transform.scale(
                      scale: _bikeScale.value,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring pulse
                          Transform.scale(
                            scale: _pulseScale.value * 1.45,
                            child: Opacity(
                              opacity: _pulseOpacity.value * 0.35,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Inner glow
                          Transform.scale(
                            scale: _pulseScale.value,
                            child: Opacity(
                              opacity: _pulseOpacity.value,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary
                                      .withValues(alpha: 0.14),
                                ),
                              ),
                            ),
                          ),
                          // Icon circle
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.18),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.delivery_dining,
                              size: 46,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 44),

                // Text block
                AnimatedBuilder(
                  animation: _textCtrl,
                  builder: (_, _) => Transform.translate(
                    offset: Offset(0, _textY.value),
                    child: Opacity(
                      opacity: _textFade.value,
                      child: Column(
                        children: [
                          // App / mall name
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.storefront_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'شام سيتي سنتر',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Tagline
                          Opacity(
                            opacity: _subtitleFade.value,
                            child: const Text(
                              'خدمة توصيل سريعة وموثوقة',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),

                          const SizedBox(height: 52),

                          // Loading dots
                          Opacity(
                            opacity: _subtitleFade.value,
                            child: const _LoadingDots(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading dots ───────────────────────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Each dot has a phase offset of 1/3
            final phase = ((_ctrl.value - i / 3) % 1.0);
            final t = (phase < 0.5 ? phase * 2 : (1 - phase) * 2)
                .clamp(0.0, 1.0);
            final opacity = 0.25 + t * 0.75;
            final scale = 0.6 + t * 0.4;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: opacity),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
