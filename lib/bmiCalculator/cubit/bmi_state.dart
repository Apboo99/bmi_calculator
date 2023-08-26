part of 'bmi_cubit.dart';

@immutable
abstract class BmiState {}

class BmiInitial extends BmiState {}

class BmiChangeGender extends BmiState {}

class BmiChangeWeightUp extends BmiState {}

class BmiChangeWeightDown extends BmiState {}

class BmiChangeHeight extends BmiState {}

class BmiCalculateBmi extends BmiState {}