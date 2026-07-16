class PersonalInfoState {
  final String? selectedGender;
  final DateTime? selectedBirthdate;

  PersonalInfoState({
    this.selectedGender,
    this.selectedBirthdate,
  });

  PersonalInfoState copyWith({
    String? selectedGender,
    DateTime? selectedBirthdate,
  }) {
    return PersonalInfoState(
      selectedGender: selectedGender ?? this.selectedGender,
      selectedBirthdate: selectedBirthdate ?? this.selectedBirthdate,
    );
  }
}