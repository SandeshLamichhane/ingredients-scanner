import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scanner/Model/chemical.dart';


class fireApp{
  
 
 Future<bool> insertchemical(ChemicalModel model)async{
  bool mybool=false;
   try{
 
     await FirebaseFirestore.instance.collection("chemicals").doc(model.chemicalName).
     set(model.toMap(model));
    mybool=true;
    return mybool;
   }
   catch(e){
     print(e.toString());
     return mybool;
   }
 
  
 }



Future<List<ChemicalModel>?>? retrievechemical() async {
  List<ChemicalModel>? listofchemicalModel;
  try{
  var snapshot=  await FirebaseFirestore.instance.collection("chemicals").get();
  
  if(snapshot.docs.length>0){
    listofchemicalModel=[];
  snapshot.docs.forEach((element) {
    listofchemicalModel!.add(ChemicalModel.fromMap(element.data()));
  });
  }
  return listofchemicalModel;

  }
  catch(e){
    return listofchemicalModel;
  }
}




}