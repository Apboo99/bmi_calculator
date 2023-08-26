import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bmi_state.dart';

class BmiCubit extends Cubit<BmiState> {
  BmiCubit() : super(BmiInitial());

  Gender selected = Gender.male;
  double valueOfWeight = 70;
  double valueOfHeight = 180;
  void changeGender(Gender gender ){
    if(gender == Gender.male){
      selected = Gender.male;
    }
    else{
      selected = Gender.female;
    }
    emit(BmiChangeGender());
  }

  void changeWeightToUp(){
    valueOfWeight++;
    emit(BmiChangeWeightUp());
  }

  void changeWeightToDown(){
  valueOfWeight--;
  emit(BmiChangeWeightDown());
  }

  void changeHeight(double newHeight){
    valueOfHeight = newHeight;
    emit(BmiChangeHeight());
  }
  calculateBmi(valueOfWeight, valueOfHeight){
  return valueOfWeight / ((valueOfHeight/100)*(valueOfHeight/100)) ;

  }
}



enum Gender{
  male,female
}

