part of 'comparison_cubit.dart';

abstract class ComparisonState {}

class ComparisonInitial extends ComparisonState {}

class ComparisonLoading extends ComparisonState {}

class ComparisonLoaded extends ComparisonState {
  final ComparisonResultModel result;
  ComparisonLoaded(this.result);
}

class ComparisonError extends ComparisonState {
  final String message;
  ComparisonError(this.message);
}
