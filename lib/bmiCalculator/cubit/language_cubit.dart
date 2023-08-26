
import 'dart:ui';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  var local = Locale(Platform.localeName);

  void changeLanguage(){
    if(local==Locale("ar")){
      local = Locale("en");
    }
    else{
      local=Locale("ar");
    }
    emit(LanguageChange());
  }
}
