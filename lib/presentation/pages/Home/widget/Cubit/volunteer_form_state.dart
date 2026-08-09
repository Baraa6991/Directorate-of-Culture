class VolunteerFormState {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthPlace;
  final String residence;
  final String? educationLevel;
  final bool hasPreviousExperience;
  final String volunteerMotivation;
  final String previousExperience;
  final List<String> selectedVolunteerFields;
  final String otherVolunteerFieldDetails;
  final List<String> selectedTools;
  final String otherToolDetails;
  final List<String> selectedCenterIds;
  final List<String> selectedTimings;
  final String otherTimingDetails;
  final String additionalInfo;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;

  const VolunteerFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.birthPlace = '',
    this.residence = '',
    this.educationLevel,
    this.hasPreviousExperience = true,
    this.volunteerMotivation = '',
    this.previousExperience = '',
    this.selectedVolunteerFields = const [],
    this.otherVolunteerFieldDetails = '',
    this.selectedTools = const [],
    this.otherToolDetails = '',
    this.selectedCenterIds = const [],
    this.selectedTimings = const [],
    this.otherTimingDetails = '',
    this.additionalInfo = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
  });

  VolunteerFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? birthPlace,
    String? residence,
    String? educationLevel,
    bool? hasPreviousExperience,
    String? volunteerMotivation,
    String? previousExperience,
    List<String>? selectedVolunteerFields,
    String? otherVolunteerFieldDetails,
    List<String>? selectedTools,
    String? otherToolDetails,
    List<String>? selectedCenterIds,
    List<String>? selectedTimings,
    String? otherTimingDetails,
    String? additionalInfo,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) {
    return VolunteerFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthPlace: birthPlace ?? this.birthPlace,
      residence: residence ?? this.residence,
      educationLevel: educationLevel ?? this.educationLevel,
      hasPreviousExperience:
          hasPreviousExperience ?? this.hasPreviousExperience,
      volunteerMotivation: volunteerMotivation ?? this.volunteerMotivation,
      previousExperience: previousExperience ?? this.previousExperience,
      selectedVolunteerFields:
          selectedVolunteerFields ?? this.selectedVolunteerFields,
      otherVolunteerFieldDetails:
          otherVolunteerFieldDetails ?? this.otherVolunteerFieldDetails,
      selectedTools: selectedTools ?? this.selectedTools,
      otherToolDetails: otherToolDetails ?? this.otherToolDetails,
      selectedCenterIds: selectedCenterIds ?? this.selectedCenterIds,
      selectedTimings: selectedTimings ?? this.selectedTimings,
      otherTimingDetails: otherTimingDetails ?? this.otherTimingDetails,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}