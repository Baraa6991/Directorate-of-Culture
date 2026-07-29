import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                color: ColorManager.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              CustomText(
                'سيتم حفظ تقدمك لزياراتك القادمة.',
                color: ColorManager.gray,
                fontSize: 13,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: ColorManager.rejectedRed,
                  foregroundColor: ColorManager.titleWhite,
                  radius: 26,
                  fixedSize: const Size(double.infinity, 50),
                  child: CustomText(
                    'موافق',
                    color: ColorManager.titleWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
