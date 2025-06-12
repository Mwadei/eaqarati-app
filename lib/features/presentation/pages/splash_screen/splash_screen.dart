import 'dart:async';
import 'package:eaqarati_app/config/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme.setSystemUIOverlayStyle(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn),
      ),
    );

    final scaleAnimation = useAnimation(
      Tween<double>(begin: 0.5, end: 1.5).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
      ),
    );

    useEffect(() {
      animationController.forward();

      // Navigate After Delay
      final timer = Timer(const Duration(seconds: 4), () {
        if (context.mounted) {
          context.go('/home');
        }
      });

      return () {
        timer.cancel();
      };
    }, [animationController]);

    // Responsive layout
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoContainerSize = screenWidth * 0.2;
    final logoIconSize = logoContainerSize * 0.55;
    final verticalSpacing = screenHeight * 0.02;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Opacity(
          opacity: fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: scaleAnimation,
                child: Container(
                  width: logoContainerSize,
                  height: logoContainerSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    size: logoIconSize,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing * 1.5),
              Text(
                'app.name'.tr(),
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              Text(
                'app.splash'.tr(),
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: verticalSpacing * 2.5),
              SizedBox(
                width: double.infinity,
                child: SpinKitThreeBounce(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
