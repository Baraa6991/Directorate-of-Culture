import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit()
    : super(
        EditProfileState(
          selectedGender: 'ذكر',
          selectedBirthdate: DateTime(1985, 5, 15),
        ),
      );

  void selectGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void selectBirthdate(DateTime date) {
    emit(state.copyWith(selectedBirthdate: date));
  }
}
