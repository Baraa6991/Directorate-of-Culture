import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:directorateofculture/presentation/pages/Volunteer/widget/volunteer_form_state.dart';
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

  void updateFirstName(String value) {
    emit(state.copyWith(firstName: value));
  }

  void updateLastName(String value) {
    emit(state.copyWith(lastName: value));
  }

  void updateEmail(String value) {
    emit(state.copyWith(email: value));
  }

  void updatePhone(String value) {
    emit(state.copyWith(phone: value));
  }

  void updateBirthPlace(String value) {
    emit(state.copyWith(birthPlace: value));
  }

  void updateResidence(String value) {
    emit(state.copyWith(residence: value));
  }

  void updateEducationLevel(String value) {
    emit(state.copyWith(educationLevel: value));
  }

  void updateHasPreviousExperience(bool value) {
    emit(state.copyWith(hasPreviousExperience: value));
  }

  void updateVolunteerMotivation(String value) {
    emit(state.copyWith(volunteerMotivation: value));
  }

  void updatePreviousExperience(String value) {
    emit(state.copyWith(previousExperience: value));
  }

  void toggleVolunteerField(String field) {
    final current = List<String>.from(state.selectedVolunteerFields);
    if (current.contains(field)) {
      current.remove(field);
    } else {
      current.add(field);
    }
    emit(state.copyWith(selectedVolunteerFields: current));
  }

  void updateOtherVolunteerFieldDetails(String value) {
    emit(state.copyWith(otherVolunteerFieldDetails: value));
  }

  void toggleTool(String tool) {
    final current = List<String>.from(state.selectedTools);
    if (current.contains(tool)) {
      current.remove(tool);
    } else {
      current.add(tool);
    }
    emit(state.copyWith(selectedTools: current));
  }

  void updateOtherToolDetails(String value) {
    emit(state.copyWith(otherToolDetails: value));
  }

  void toggleCenter(String centerId) {
    final current = List<String>.from(state.selectedCenterIds);
    if (current.contains(centerId)) {
      current.remove(centerId);
    } else {
      current.add(centerId);
    }
    emit(state.copyWith(selectedCenterIds: current));
  }

  void toggleTiming(String timing) {
    final current = List<String>.from(state.selectedTimings);
    if (current.contains(timing)) {
      current.remove(timing);
    } else {
      current.add(timing);
    }
    emit(state.copyWith(selectedTimings: current));
  }

  void updateOtherTimingDetails(String value) {
    emit(state.copyWith(otherTimingDetails: value));
  }

  void updateAdditionalInfo(String value) {
    emit(state.copyWith(additionalInfo: value));
  }

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

      final isSuccess = response['success'] == true ||
          response['success']?.toString() == 'true' ||
          response['status'] == 'success';

      if (isSuccess) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: null,
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