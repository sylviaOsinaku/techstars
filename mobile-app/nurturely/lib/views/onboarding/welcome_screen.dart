import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:techstars_hackathon/common/colors.dart';
import 'package:techstars_hackathon/views/onboarding/who_are_you.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData themeData = Theme.of(context);
    final bool isDarkMode = themeData.brightness == Brightness.dark;
    final double width = mediaQuery.size.width;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDarkMode ? themeData.scaffoldBackgroundColor : TechStarsColors.lightestPink,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      ),

      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(

            gradient: isDarkMode ? null : LinearGradient(
              colors: [TechStarsColors.lightestPink, themeData.scaffoldBackgroundColor],
              stops: [0.1, 0.4],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight),
                  Center(child: Image.asset("assets/images/three_pink_dots.png", height: 24)),

                  const SizedBox(height: 48),

                  SizedBox(width: width, child: CustomText("Welcome to", fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(width: width, child: CustomText("Nurturely", fontSize: 32, fontWeight: FontWeight.bold,
                    shadows: [
                    BoxShadow(color: Colors.yellow, spreadRadius: 5, offset: Offset.zero)
                  ],)),

                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: SvgPicture.asset("assets/svgs/nurturely_logo.svg", width: width * 0.5, height: width * 0.5),
                          ),
                        ),
                        CustomText(
                          "Nurturing you and your little one with expert care, guidance, and community...",
                          fontStyle: FontStyle.italic,
                          color: isDarkMode ? Colors.white : Colors.black,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(-0.5, -0.5),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(themeData.primaryColorDark)),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: WhoAreYou(),
                              duration: Durations.extralong1,
                              curve: CustomCurves.defaultIosSpring,
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
