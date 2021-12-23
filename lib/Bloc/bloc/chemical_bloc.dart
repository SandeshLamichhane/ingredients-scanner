import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:scanner/Model/chemical.dart';
import 'package:scanner/data/crud.dart';
import 'package:scanner/data/firestore_database.dart';
import 'package:scanner/data/recognizetext.dart';

part 'chemical_event.dart';
part 'chemical_state.dart';

class ChemicalBloc extends Bloc<ChemicalEvent, ChemicalState> {

  static int i=0;

  ChemicalBloc() : super(ChemicalInitial()) {

//on lading the chemical
    on<Loadchemical>((event, emit)async {
     emit(ChemicalLoading());
       await  Future.delayed(Duration(seconds: 3));
      final fruits= await ChemicalDao().getAllSortedByName();
      emit(ChemicalLoaded(fruits));
     
    });

///////////// initial chemical state 
 on<ChemicalInitialEvent>((event, emit)async {
     emit(ChemicalLoading());
     emit (ChemicalInitial());
    });

 
//add chemical to the firestore

on<AddChemicaltoFirestore>((event, state) async{
 emit(ChemicalLoading());
  Future.delayed(Duration(seconds: 3));
    var x=   ChemicalModel(
      chemicalName: "Oxybenzone ",
      isharmful: true,
      feature: "a hormone-disrupting UV filter.",
      alternative: ""
    );

  var y= await fireApp().insertchemical(x);

emit(ChemicalInitial());

}); 
 
 //////////////////////////////// add the chemical


 

on<Addchemical>((event, emit)async { 
         Future.delayed(Duration(seconds: 3));
        ChemicalModel model=ChemicalModel(chemicalName:  event._chemical, 
        feature: "This is harmfula and this is not harmfull", isharmful: true);
        await ChemicalDao().insert(model);
       final fruits= await ChemicalDao().getAllSortedByName();
        emit(ChemicalLoaded(fruits));
     
    });

// it will search chemical inside the flutter  sembast database
on<SearchChemical>((event, emit)async {
  emit (ChemicalLoading());
 await Future.delayed(Duration(seconds: 1));
 //final receiveModel= await ChemicalDao().search(event._chemical);  
 //emit loading
 final receiveModel=  await RegonizeText().CompareString(event._chemical);
 
 if(receiveModel ==null ){
   emit(NotAnyChemicalFound());
 }else if(receiveModel.length<1){
  emit(NotAnyChemicalFound());
 }else
 { 
   emit(ChemicalLoaded(receiveModel));

 }
 

});
  }
}
 

 