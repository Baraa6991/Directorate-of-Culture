import 'package:directorateofculture/presentation/pages/AI/recommendation_model.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'for_you_state.dart';
class ForYouCubit extends Cubit<ForYouState> {
  final MiscRepository repository;

  ForYouCubit({required this.repository}) : super(ForYouState());

  Future<void> load({bool refresh = false}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final recommendations = await repository.getForYou(refresh: refresh);
      emit(state.copyWith(recommendations: recommendations, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'تعذر تحميل التوصيات الآن',
      ));
    }
  }
}
