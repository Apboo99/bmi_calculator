import 'package:bmi_calculator/bmiCalculator/cubit/bmi_cubit.dart';
import 'package:bmi_calculator/bmiCalculator/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'bmiWidgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BmiCalculator extends StatelessWidget {
   const BmiCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => BmiCubit(),
),
    BlocProvider(
      create: (context) => LanguageCubit(),
    ),
  ],
  child: BlocBuilder<LanguageCubit, LanguageState>(
  builder: (context, state) {
    return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: context.read<LanguageCubit>().local,
      debugShowCheckedModeBanner: false,
      home: const Directionality(textDirection:TextDirection.ltr, child: MyHomePage()),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        useMaterial3: true,
      ),
    );
  },
),
);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {


     String calc = AppLocalizations.of(context)!.calculateBmi;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xD8C3E5FD),
      appBar: AppBar(
        elevation: 7,
        title:  Text(AppLocalizations.of(context)!.bmiCalculator,
            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
        centerTitle: true,
        actions:  [

          Container(
              margin: const EdgeInsets.only(left: 10,right: 10),
              child: GestureDetector(
                  child: const Icon(Icons.language,size: 29,),
                onTap: (){
                  context.read<LanguageCubit>().changeLanguage();
                },
              ))
        ],
        backgroundColor: Colors.amber,

      ),

      body: BlocBuilder<BmiCubit, BmiState>(
  builder: (context, state) {
    final cubit = context.read<BmiCubit>();
    return BlocListener<BmiCubit, BmiState>(
  listener: (context, state) {
    if(state is BmiChangeHeight){
        Get.snackbar("Height changed","good");
    }
    if(state is BmiChangeGender){
      Get.snackbar("gender", "M or F");
    }
  },
  child: Container(
        padding: const EdgeInsets.only(top: 10),

        width: width,
        margin:const EdgeInsets.all(10),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    cubit.changeGender(Gender.male);
                  },
                    child: genderContainer((AppLocalizations.of(context)!.male).toString(),
                        Icons.male,
                        cubit.selected==Gender.male?Colors.blue:Colors.white,
                        widthOfContainer: width*.4,
                        heightOfContainer: height*.2,
                    ),
                ),

                GestureDetector(
                    onTap: () {
                      cubit.changeGender(Gender.female);
                    },
                    child: genderContainer((AppLocalizations.of(context)!.female).toString(),
                        Icons.female,
                        cubit.selected==Gender.female?Colors.blue:Colors.white,
                        widthOfContainer: width*.4,
                        heightOfContainer: height*.2,
                    ),),
              ],
            ),

            Container(
              margin: const EdgeInsets.all(15),
              width: width,
              height: height*.26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   Text((AppLocalizations.of(context)!.height).toString(),style:const TextStyle(fontSize: 28)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cubit.valueOfHeight.toStringAsFixed(0),style:const TextStyle(fontSize: 24)),
                      const SizedBox(width: 5,),
                       Text((AppLocalizations.of(context)!.cm).toString(),style:const TextStyle(fontSize: 25))
                    ],
                  ),
                  Slider(
                      value: cubit.valueOfHeight,
                      min: 0,
                      max: 200,
                    onChanged: (double newHeight){
                        cubit.changeHeight(newHeight);
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: width,
              height: height*.26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   Text((AppLocalizations.of(context)!.weight).toString(),style:const TextStyle(fontSize: 28)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cubit.valueOfWeight.toStringAsFixed(0),style:const TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5,),
                      Text((AppLocalizations.of(context)!.kg).toString(),style:const TextStyle(fontSize: 25))
                    ],
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: GestureDetector(
                            child: const Icon(Icons.remove,color: Colors.white,),
                            onTap: (){
                              cubit.changeWeightToDown();
                            },
                        ),
                      ),
                      const SizedBox(width: 20,),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: GestureDetector(
                            child: const Icon(Icons.add,color: Colors.white),
                          onTap: (){
                            cubit.changeWeightToUp();
                          },

                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
            Container(

              margin: const EdgeInsets.only(left: 15,right: 15),
              width: width,
              child: ElevatedButton(onPressed:(){

                showDialog(context: context,
                    builder: (context){
                  String message;
                    double result=  cubit.calculateBmi(cubit.valueOfWeight, cubit.valueOfHeight);
                  if(result<18.5){
                    message = AppLocalizations.of(context)!.under;
                  }
                  else if(result>18.5 && result <25){
                    message = AppLocalizations.of(context)!.normal;
                  }
                  else if(result >25 && result <30){
                    message = AppLocalizations.of(context)!.over;
                  }
                  else{
                    message = AppLocalizations.of(context)!.obese;
                  }
                  return  AlertDialog(
                    elevation: 0,
                    backgroundColor: Colors.blueAccent,
                    title:  Text(AppLocalizations.of(context)!.bmiResult,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                    icon: const Icon(Icons.calculate_outlined,size: 40,),
                    iconColor: Colors.black,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${AppLocalizations.of(context)!.your_bmi} ${result.toStringAsFixed(1)}. \n${AppLocalizations.of(context)!.you_are} $message.",style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    actions: [
                      Center(
                          child: GestureDetector(
                              child:  Text(AppLocalizations.of(context)!.ok,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 19)),
                            onTap: (){
                                Navigator.of(context).pop();
                            },
                          ))
                    ],
                  );
                    }) ;
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),

              ),

                  child: Text(calc,style: const TextStyle(fontSize: 22,color: Colors.black),),
              ),
            )

          ],

        ),
      ),
);
  },
)
    );
  }


}
