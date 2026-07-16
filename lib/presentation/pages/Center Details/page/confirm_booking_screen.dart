import 'package:directorateofculture/presentation/pages/Center%20Details/widget/FacilityModel.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/booking_info_row.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/hall_feature_item.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';

class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = const [
      FacilityModel(iconKey: 'stage_lighting', label: 'Stage & Lighting'),
      FacilityModel(iconKey: 'ac', label: 'Air Conditioning'),
      FacilityModel(iconKey: 'sound_system', label: 'Sound System'),
      FacilityModel(iconKey: 'seating', label: 'Seating (120)'),
      FacilityModel(iconKey: 'projector', label: 'Projector & Screen'),
      FacilityModel(iconKey: 'microphone', label: 'Microphones'),
      FacilityModel(iconKey: 'wifi', label: 'Wi-Fi'),
      FacilityModel(iconKey: 'parking', label: 'Parking Available'),
    ];

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.titleWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: ColorManager.darkForestGreen),
        ),
        title: CustomText(
          'Confirm Your Booking',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorManager.darkForestGreen,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 20,
                paddingAll: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Al Ain Cultural Center',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      'Theater Hall',
                      fontSize: 13,
                      color: ColorManager.gray,
                    ),
                    const SizedBox(height: 8),
                    BookingInfoRow(
                      icon: Icons.apartment,
                      label: 'Center',
                      value: 'Al Ain Cultural Center',
                    ),
                    BookingInfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Hall',
                      value: 'Theater Hall',
                    ),
                    BookingInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: 'October 20, 2024',
                    ),
                    BookingInfoRow(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: '19:00 - 22:00',
                    ),
                    BookingInfoRow(
                      icon: Icons.groups_outlined,
                      label: 'Capacity',
                      value: '120 Seats',
                    ),
                    BookingInfoRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Booking ID',
                      value: 'ACC-2024-1020-TH-01',
                      showDivider: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 20,
                paddingAll: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Hall Features & Amenities',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            childAspectRatio: 3.2,
                          ),
                      itemBuilder: (context, index) {
                        return HallFeatureItem(feature: features[index]);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              CustomContainer(
                width: double.infinity,
                color: ColorManager.titleWhite,
                radius: 20,
                paddingAll: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Your Information',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkForestGreen,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      'Please enter your details to confirm the booking',
                      fontSize: 12,
                      color: ColorManager.gray,
                    ),
                    const SizedBox(height: 18),

                    CustomText(
                      'Full Name',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                    const SizedBox(height: 8),
                    CustomTextfield(
                      hint: 'Enter your full name',
                      hintColor: ColorManager.lightGray,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ColorManager.lightGray.withOpacity(0.5),
                        ),
                      ),
                      focusColor: ColorManager.deepGreen,
                    ),

                    const SizedBox(height: 16),
                    CustomText(
                      'Phone Number',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                    const SizedBox(height: 8),
                    CustomTextfield(
                      hint: '05X XXX XXXX',
                      hintColor: ColorManager.lightGray,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ColorManager.lightGray.withOpacity(0.5),
                        ),
                      ),
                      focusColor: ColorManager.deepGreen,
                    ),

                    const SizedBox(height: 16),
                    CustomText(
                      'National ID',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                    const SizedBox(height: 8),
                    CustomTextfield(
                      hint: '784-XXXX-XXXXXXX-X',
                      hintColor: ColorManager.lightGray,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: ColorManager.gray,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ColorManager.lightGray.withOpacity(0.5),
                        ),
                      ),
                      focusColor: ColorManager.deepGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {},
                  backgroundColor: ColorManager.darkForestGreen,
                  radius: 28,
                  fixedSize: const Size(double.infinity, 58),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        'Confirm Booking',
                        color: ColorManager.titleWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: ColorManager.gray,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      'Your information is secure and encrypted',
                      fontSize: 11,
                      color: ColorManager.gray,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
