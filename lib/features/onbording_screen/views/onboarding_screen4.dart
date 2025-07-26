import 'package:barbell/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/features/auth/view/login_screen.dart';

import '../controller/onboarding_controller.dart';
import '../widgets/continue_button.dart';

class OnboardingScreen4 extends StatefulWidget {
  OnboardingScreen4({super.key});

  @override
  _OnboardingScreen4State createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4>
    with TickerProviderStateMixin {
  final OnboardingController controller = Get.put(OnboardingController());

  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late List<Animation<double>> _floatingAnimations;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1600),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1400),
      vsync: this,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.7, curve: Curves.easeOutQuart),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating animation controller
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    // Create staggered animations for floating elements
    _floatingAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 15.0).animate(
        CurvedAnimation(
          parent: _floatingController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeInOut),
        ),
      );
    });

    // Staggered fade-in animations for floating elements
    _staggeredAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.4 + (index * 0.05),
            (0.8 + (index * 0.05)).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // Start animations with better timing and error handling
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted && !_animationController.isAnimating) {
        _animationController.forward();
      }
    });

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted && !_scaleController.isAnimating) {
        _scaleController.forward();
      }
    });

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted && !_floatingController.isAnimating) {
        _floatingController.repeat(reverse: true);
      }
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted && !_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    /// Dispose animation controllers safely
    /// This prevents memory leaks and ensures proper cleanup
    try {
      _animationController.dispose();
      _floatingController.dispose();
      _pulseController.dispose();
      _scaleController.dispose();
    } catch (e) {
      // Handle any disposal errors gracefully
      debugPrint('Error disposing animation controllers: $e');
    }
    super.dispose();
  }

  /// Navigate to login screen with proper error handling
  /// This method provides safe navigation and prevents potential issues
  void _navigateToLogin() {
    try {
      Get.to(() => LoginScreen());
    } catch (e) {
      // Handle navigation errors gracefully
      debugPrint('Navigation error: $e');
      // Fallback navigation if Get.to fails
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
            colors: [
              AppColors.backgroundDark,
              AppColors.primary.withValues(alpha: 0.8),
              AppColors.primary,
              AppColors.backgroundDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern overlay
            _buildBackgroundPattern(),

            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Skip button
                    _buildSkipButton(),

                    // Main illustration section
                    Expanded(flex: 3, child: _buildIllustrationSection()),

                    // Title and description section
                    _buildTitleSection(),

                    SizedBox(height: Sizer.hp(40)),

                    // Get Started button
                    _buildActionButton(),

                    SizedBox(height: Sizer.hp(50)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomPaint(painter: BackgroundPatternPainter()),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () => _navigateToLogin(),
            child: Text(
              controller.onboarding4.value.skipText,
              style: getTextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildMainIllustration(),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Column(
          children: [
            // Main title with gradient text effect
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [
                      AppColors.textWhite,
                      AppColors.secondary,
                      AppColors.textWhite,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(bounds),
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  children: [
                    const TextSpan(text: 'Your path to '),
                    const TextSpan(
                      text: 'success',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                    const TextSpan(text: '\nstarts with daily tracking'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 16),

            // Subtitle
            Text(
              'Track your progress, achieve your goals, and transform your lifestyle with our comprehensive fitness companion.',
              style: AppTextStyle.f16W400().copyWith(
                color: AppColors.textWhite.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.6, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: ContinueButton(
                onPressed: () {
                  _navigateToLogin();
                },
                buttonText: "Get Started",
                showLeftIcon: true,
                showRightArrow: true,
                enableSwipe: true,
                useExternalSwipe: true,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainIllustration() {
    return Container(
      width: 380,
      height: 380,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background glow effect
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.3),
                  AppColors.secondary.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Main central card
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: AppColors.secondary.withValues(alpha:0.2),
              //     blurRadius: 30,
              //     spreadRadius: 5,
              //   ),
              // ],
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.6),
                    AppColors.secondary.withValues(alpha: 0.8),
                  ],
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: AppColors.secondary.withValues(alpha:0.25),
                //     blurRadius: 20,
                //     spreadRadius: 2,
                //   ),
                // ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Image.asset(
                  IconPath.onboarding_4,
                  width: 10,
                  height: 10,
                ),
              ),
            ),
          ),

          // Floating achievement cards
          ...List.generate(4, (index) {
            return AnimatedBuilder(
              animation: Listenable.merge([
                _floatingAnimations[index],
                _staggeredAnimations[index],
              ]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_floatingAnimations[index].value),
                  child: FadeTransition(
                    opacity: _staggeredAnimations[index],
                    child: _buildFloatingAchievementCard(index),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFloatingAchievementCard(int index) {
    final achievements = [
      {
        'icon': Icons.psychology_outlined,
        'title': 'AI Insights',
        'value': '24/7',
        'unit': 'active',
        'color': Color(0xFF4CAF50),
        'position': Offset(-120, -120),
      },
      {
        'icon': Icons.local_fire_department_outlined,
        'title': 'Calories',
        'value': '420',
        'unit': 'kcal',
        'color': Color(0xFFFF5722),
        'position': Offset(120, -120),
      },
      {
        'icon': Icons.fitness_center_outlined,
        'title': 'Workout',
        'value': '30',
        'unit': 'min',
        'color': Color(0xFF9C27B0),
        'position': Offset(-120, 120),
      },
      {
        'icon': Icons.water_drop_outlined,
        'title': 'Water',
        'value': '6/8',
        'unit': 'glasses',
        'color': Color(0xFF2196F3),
        'position': Offset(120, 120),
      },
    ];

    final achievement = achievements[index];
    final position = achievement['position'] as Offset;
    final color = achievement['color'] as Color;

    return Transform.translate(
      offset: position,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                achievement['icon'] as IconData,
                color: color,
                size: 16,
              ),
            ),
            SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['value'] as String,
                  style: AppTextStyle.f14W600().copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  achievement['unit'] as String,
                  style: AppTextStyle.f14W400().copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.02)
          ..style = PaintingStyle.fill;

    // Draw subtle geometric patterns
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        final x = (size.width / 20) * i;
        final y = (size.height / 20) * j;

        if ((i + j) % 4 == 0) {
          canvas.drawCircle(Offset(x, y), 2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
