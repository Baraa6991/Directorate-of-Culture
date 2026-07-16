import 'package:directorateofculture/presentation/pages/Volunteer/widget/volunteer_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VolunteerFormCubit extends Cubit<VolunteerFormState> {
  VolunteerFormCubit() : super(VolunteerFormState());

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

  void submit() {
    // سيتم ربطه بالـ API لاحقًا
  }
} 