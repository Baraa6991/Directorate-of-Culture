import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

/// Confirmation dialog shown after "Save Ticket" on the Booking Success
/// screen. Text is kept in Arabic even though the rest of the app is in
/// English — an explicit choice, not an oversight. The app has no
/// localization/i18n setup, so this is plain hardcoded text, not a
/// translated string resource.
class SavedTicketDialog extends StatelessWidget {
  const SavedTicketDialog({super.key});

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
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: ColorManager.lightBackground,
                    backgroundImage: AssetImage(AssetsManager.logo),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: ColorManager.titleWhite,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: ColorManager.deepGreen,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: ColorManager.titleWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CustomText(
                'تم حفظ التذكرة بنجاح',
                color: ColorManager.deepGreen,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CustomText(
                'يمكنك الآن العثور على تذكرتك في قسم التذاكر الخاص بملفك الشخصي.',
                color: ColorManager.gray,
                fontSize: 13,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: ColorManager.deepGreen,
                  foregroundColor: ColorManager.titleWhite,
                  radius: 26,
                  fixedSize: const Size(double.infinity, 50),
                  child: CustomText(
                    'تم',
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
