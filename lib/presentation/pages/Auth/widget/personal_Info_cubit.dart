import 'package:flutter/material.dart';
import 'package:directorateofculture/presentation/pages/Auth/widget/personal_Info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(PersonalInfoState());

  // الكونترولرز محفوظة هنا عشان ما تنعاد صناعتها مع كل rebuild للواجهة
  // ولأن الـ Cubit ينشأ مرة وحدة فقط عبر BlocProvider
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String phoneNumber = '';

  void selectGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void selectBirthdate(DateTime date) {
    emit(state.copyWith(selectedBirthdate: date));
  }

  void updatePhoneNumber(String phone) {
    phoneNumber = phone;
  }

  String get fullName =>
      '${firstNameController.text.trim()} ${lastNameController.text.trim()}'
          .trim();

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthdateController.dispose();
    return super.close();
  }
}