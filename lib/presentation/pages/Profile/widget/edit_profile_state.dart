class EditProfileState {
  final String? selectedGender;
  final DateTime? selectedBirthdate;

  EditProfileState({this.selectedGender, this.selectedBirthdate});

  EditProfileState copyWith({
    String? selectedGender,
    DateTime? selectedBirthdate,
  }) {
    return EditProfileState(
      selectedGender: selectedGender ?? this.selectedGender,
      selectedBirthdate: selectedBirthdate ?? this.selectedBirthdate,
    );
  }
}
