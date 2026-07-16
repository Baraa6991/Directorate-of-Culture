import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.titleWhite,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              "Enter your phone number to accesscultural experiences.",
              fontSize: 16,
              color: ColorManager.black,
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                "Phone Number",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorManager.black,
              ),
            ),
            SizedBox(height: 5),
            IntlPhoneField(
              decoration: InputDecoration(
                hintText: '09xxxxxxxx',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              initialCountryCode: 'SY',
              onChanged: (phone) {
                print(phone.completeNumber);
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
                    "Send Code",
                    color: ColorManager.titleWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
