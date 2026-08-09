import 'package:bloc/bloc.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:directorateofculture/presentation/pages/AI/comparison_result_model.dart';


part 'comparison_state.dart';

class ComparisonCubit extends Cubit<ComparisonState> {
  final MiscRepository repository;

  ComparisonCubit({required this.repository}) : super(ComparisonInitial());

  Future<void> compare({
    required String type,
    required int id1,
    required int id2,
  }) async {
    emit(ComparisonLoading());
    try {
      final result = await repository.compare(type: type, id1: id1, id2: id2);
      emit(ComparisonLoaded(result));
    } catch (e) {
      emit(ComparisonError('تعذر إجراء المقارنة الآن، حاول مرة أخرى.'));
    }
  }
}
