import 'package:bmi_calculator/bmiCalculator/cubit/bmi_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget genderContainer(String gender, IconData iconOfGender,Color color,
    {required double widthOfContainer, required double heightOfContainer}) {
  return BlocBuilder<BmiCubit, BmiState>(
    builder: (context, state) {
      final cubit2 = context.read<BmiCubit>();
      return Container(

        width: widthOfContainer,
        height: heightOfContainer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconOfGender, size: 60,),
            Text(gender, style: const TextStyle(fontSize: 25),)
          ],
        ),
      );
    },
  );
}
