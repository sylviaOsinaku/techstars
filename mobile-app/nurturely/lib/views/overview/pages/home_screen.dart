import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:techstars_hackathon/common/colors.dart';
import 'package:techstars_hackathon/common/widgets/timestamped_chat_message.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData themeData = Theme.of(context);
    final double width = mediaQuery.size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight),
          buildTopBar(themeData),

          Container(
            width: width,
            height: 160,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            margin: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              border: Border.fromBorderSide(BorderSide(color: TechStarsColors.lighterPink)),
              color: TechStarsColors.lightestPink,
              borderRadius: BorderRadius.circular(24),
            ),

            child: Column(
              spacing: 12,
              children: [
                SizedBox(
                  width: width * 0.8,
                  child: CustomText("Good evening, User", fontSize: 22, fontWeight: FontWeight.bold, color: TechStarsColors.primary),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SizedBox(
                    height: 60,
                    child: TimestampedChatMessage(
                      expandWidth: true,
                      textSpan: TextSpan(
                        text:
                            "It's been 6 weeks, your body is starting to change! "
                            "You might feel more tired."
                            "Remember to Drink plenty of water and eat well.",

                        style: CustomText(
                          "",
                          fontSize: 15,
                          color: Color(0x80363636),
                          fontStyle: FontStyle.italic,
                        ).effectiveStyle(context),
                      ),
                      sentAt: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: IconButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(CircleBorder()),
                            side: WidgetStatePropertyAll(BorderSide(color: TechStarsColors.lightGray)),
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                          icon: SvgPicture.asset("assets/svgs/ai_sparkle.svg", width: 32, height: 32),
                          onPressed: () {},
                        ),
                      ),
                      sentAtWidth: 36,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("Quick Access"),
                Container(
                  width: width,
                  height: 140,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: TechStarsColors.lightGray,
                    border: Border.fromBorderSide(BorderSide(color: TechStarsColors.primaryDark.withAlpha(40))),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildQuickAccessIcon("Basic info.", Iconsax.personalcard_copy),
                      buildQuickAccessIcon("Appointments", Iconsax.calendar_copy),
                      buildQuickAccessIcon("Reminders", Iconsax.clock_copy),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("Health Tips"),
                Container(
                  width: width,
                  height: 140,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: TechStarsColors.lightGray,
                    border: Border.fromBorderSide(BorderSide(color: TechStarsColors.primaryDark.withAlpha(40))),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildQuickAccessIcon("Check out some quick health tips", Iconsax.health),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopBar(ThemeData themeData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(TechStarsColors.lightGray)),
            icon: Icon(Iconsax.profile_circle, size: 48, color: themeData.primaryColorDark,),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(onPressed: () {}, icon: Icon(Iconsax.notification, size: 28, color: themeData.brightness == Brightness.dark ? Colors.white : themeData.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

buildQuickAccessIcon(String title, IconData icon) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 8.0,
    children: [
      IconButton(
        onPressed: () {},
        icon: Icon(icon, size: 30, color: TechStarsColors.primary),
        padding: EdgeInsets.all(14),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),

          shape: WidgetStatePropertyAll(CircleBorder(side: BorderSide(color: TechStarsColors.primaryDark.withAlpha(40)))),
        ),
      ),
      CustomText(title, fontSize: 12, color: Colors.black),
    ],
  );
}

class GradientStrokeText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Gradient fillGradient;
  final Gradient strokeGradient;
  final double strokeWidth;

  const GradientStrokeText({
    super.key,
    required this.text,
    required this.textStyle,
    required this.fillGradient,
    required this.strokeGradient,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();

    final Rect textBounds = Offset.zero & textPainter.size;
    final Rect shaderRect = textBounds.inflate(strokeWidth);

    return Stack(
      children: [
        // Stroke Text
        Text(
          text,
          style: textStyle.copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth
                  ..shader = strokeGradient.createShader(shaderRect),
          ),
        ),
        // Fill Text
        Text(text, style: textStyle.copyWith(foreground: Paint()..shader = fillGradient.createShader(shaderRect))),
      ],
    );
  }
}






