import 'package:directorateofculture/presentation/pages/Auth/widget/personal_Info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(PersonalInfoState());

  void selectGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void selectBirthdate(DateTime date) {
    emit(state.copyWith(selectedBirthdate: date));
  }
}