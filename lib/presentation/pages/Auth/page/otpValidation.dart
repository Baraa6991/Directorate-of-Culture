import 'package:directorateofculture/presentation/util/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Otpvalidation extends StatelessWidget {
  const Otpvalidation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 100),
            Align(alignment: Alignment.centerLeft, child: Icon(Icons.arrow_back)),
            SizedBox(height: 150,),
            CustomText(
              'Verify Your Number',
              fontWeight: FontWeight.w600,
              fontSize: 24,
              textAlign: TextAlign.center,
              color: ColorManager.black,
            ),
            SizedBox(height: 15),
            CustomText(
              'Enter the 4-digit verification code \nsent to your phone.',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              textAlign: TextAlign.center,
              color: ColorManager.black,
            ),
            SizedBox(height: 40),
            Pinput(
              length: 4,
              defaultPinTheme: PinTheme(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.deepGreen,width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onCompleted: (pin) {
                print(pin);
              },
            ),
            SizedBox(height: 40),
            CustomElevatedButton(
              onPressed: () {},
              backgroundColor: ColorManager.deepGreen,
              foregroundColor: ColorManager.titleWhite,
              radius: 30,
              fixedSize: const Size(double.infinity, 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Check Code",
                    color: ColorManager.titleWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh),
                SizedBox(width: 8),
                CustomText(
                  "Resend Code",
                  color: ColorManager.deepGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
