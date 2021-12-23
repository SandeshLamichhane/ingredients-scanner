import 'package:scanner/data/crud.dart';
import 'package:scanner/data/firestore_database.dart';

class InitialService{
///

 loadchemicalsAndsync()async{
 var xyz=await fireApp().retrievechemical();
 if(xyz ==null){
   
 }else{
   //insert json into the local database
   ChemicalDao().deleteAlljson();
   xyz.forEach((element) {
     ChemicalDao().insert(element);
   });
 
 }
 
 }



}