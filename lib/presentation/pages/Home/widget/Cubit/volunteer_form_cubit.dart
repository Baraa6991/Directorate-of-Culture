import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:directorateofculture/presentation/pages/Home/widget/Cubit/volunteer_form_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VolunteerFormCubit extends Cubit<VolunteerFormState> {
  final MiscRepository repository;

  VolunteerFormCubit({MiscRepository? repository})
      : repository = repository ?? MiscRepository(),
        super(const VolunteerFormState());

  static const Map<String, String> centersMap = {
    '1': 'التطوع مع فريق مديرية الثقافة',
    '2': 'مركز برزة',
    '3': 'مركز العدوي',
    '4': 'مركز الميدان',
    '5': 'مركز المزة',
    '6': 'مركز أبو رمانة',
    '7': 'مركز كفر سوسة',
  };

  void updateFirstName(String value) => emit(state.copyWith(firstName: value));
  void updateLastName(String value) => emit(state.copyWith(lastName: value));
  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateBirthPlace(String value) => emit(state.copyWith(birthPlace: value));
  void updateResidence(String value) => emit(state.copyWith(residence: value));

  void updateEducationLevel(String value) =>
      emit(state.copyWith(educationLevel: value));

  void updateHasPreviousExperience(bool value) =>
      emit(state.copyWith(hasPreviousExperience: value));
  void updateVolunteerMotivation(String value) =>
      emit(state.copyWith(volunteerMotivation: value));
  void updatePreviousExperience(String value) =>
      emit(state.copyWith(previousExperience: value));

  void toggleVolunteerField(String field) {
    final updated = List<String>.from(state.selectedVolunteerFields);
    updated.contains(field) ? updated.remove(field) : updated.add(field);
    emit(state.copyWith(selectedVolunteerFields: updated));
  }

  void updateOtherVolunteerFieldDetails(String value) =>
      emit(state.copyWith(otherVolunteerFieldDetails: value));

  void toggleTool(String tool) {
    final updated = List<String>.from(state.selectedTools);
    updated.contains(tool) ? updated.remove(tool) : updated.add(tool);
    emit(state.copyWith(selectedTools: updated));
  }

  void updateOtherToolDetails(String value) =>
      emit(state.copyWith(otherToolDetails: value));

  void toggleCenter(String centerId) {
    final updated = List<String>.from(state.selectedCenterIds);
    updated.contains(centerId) ? updated.remove(centerId) : updated.add(centerId);
    emit(state.copyWith(selectedCenterIds: updated));
  }

  void toggleTiming(String timing) {
    final updated = List<String>.from(state.selectedTimings);
    updated.contains(timing) ? updated.remove(timing) : updated.add(timing);
    emit(state.copyWith(selectedTimings: updated));
  }

  void updateOtherTimingDetails(String value) =>
      emit(state.copyWith(otherTimingDetails: value));

  void updateAdditionalInfo(String value) =>
      emit(state.copyWith(additionalInfo: value));

  Future<void> submit() async {
    if (state.firstName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال الاسم'));
      return;
    }
    if (state.lastName.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال الكنية'));
      return;
    }
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال البريد الإلكتروني'));
      return;
    }
    if (state.phone.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال رقم الهاتف'));
      return;
    }
    if (state.birthPlace.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال تاريخ الميلاد'));
      return;
    }
    if (state.residence.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء إدخال مكان الإقامة'));
      return;
    }
    if (state.educationLevel == null || state.educationLevel!.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء اختيار المستوى التعليمي'));
      return;
    }
    if (state.volunteerMotivation.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء كتابة سبب رغبتك بالتطوع'));
      return;
    }
    if (state.selectedVolunteerFields.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'الرجاء اختيار مجال تطوع واحد على الأقل',
      ));
      return;
    }
    if (state.selectedTools.isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء تحديد المعدات المتوفرة لديك'));
      return;
    }
    if (state.selectedCenterIds.isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء اختيار مركز واحد على الأقل'));
      return;
    }
    if (state.selectedTimings.isEmpty) {
      emit(state.copyWith(errorMessage: 'الرجاء تحديد الأوقات المتاحة لديك'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    debugPrint('🔹 Submitting volunteer form...');

    try {
      final volunteeringInterest = _joinWithOther(
        state.selectedVolunteerFields,
        state.otherVolunteerFieldDetails,
      );
      final toolsText = _joinWithOther(
        state.selectedTools,
        state.otherToolDetails,
      );
      final centersText = state.selectedCenterIds
          .map((id) => centersMap[id] ?? id)
          .join('، ');
      final availableTimesText = _joinWithOther(
        state.selectedTimings,
        state.otherTimingDetails,
      );

      final data = <String, dynamic>{
        'first_name': state.firstName.trim(),
        'last_name': state.lastName.trim(),
        'email': state.email.trim(),
        'whatsapp_number': state.phone.trim(),
        'birthday_date': state.birthPlace.trim(),
        'address': state.residence.trim(),
        'education_level': state.educationLevel!.trim(),
        'has_volunteered_before': state.hasPreviousExperience.toString(),
        'previous_experiences': state.previousExperience.trim(),
        'why_volunteer': state.volunteerMotivation.trim(),
        'volunteering_interest': volunteeringInterest,
        'tools': toolsText,
        'center': centersText,
        'available_times': availableTimesText,
        'notes': state.additionalInfo.trim(),
      };

      final response = await repository.submitVolunteerForm(data: data);
      debugPrint('📨 Response: $response');

      if (response['status'] == 'success') {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage: response['message'] ?? 'تم إرسال طلبك بنجاح',
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: response['message'] ?? 'تعذّر إرسال الطلب',
        ));
      }
    } catch (e) {
      debugPrint('💥 Volunteer submit error: $e');
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  String _joinWithOther(List<String> selected, String otherDetails) {
    final items = selected.where((e) => e != 'أخرى').toList();
    if (selected.contains('أخرى') && otherDetails.trim().isNotEmpty) {
      items.add(otherDetails.trim());
    }
    return items.join('، ');
  }
}