import 'package:scanner/Model/chemical.dart';
import 'package:scanner/data/crud.dart';

class RegonizeText{
 static List<ChemicalModel>? listofharmfullchemical;
 
///////////////////////// 
///
Future<List<ChemicalModel>?> CompareString(List<String>_listofString) async{
listofharmfullchemical=[];
int length= _listofString.length;
 
 var listofjson = await ChemicalDao().getalljson();

 
//count the string first
 for(int i=0; i<length;i++){
   String checkupString='';

   //two 2d array
  for (int j=i; j<i+4; j++){
    
 
   ChemicalModel ? _checkupModel;

   //it means if [ram prasad gautam]
    
   if(i==j){
    checkupString=checkupString+_listofString[i].trim()+' ';
      
   _checkupModel= await isharmfullCehmical(checkupString.trim().replaceAll(RegExp(","), ""), listofjson) ;
   //compare it to the database
     if( _checkupModel !=null){
   //store insude the list  and show to user
 
   listofharmfullchemical?.add(_checkupModel);
    // print('/////////////////////'+_checkupModel.chemicalName.toString()+'/////////////////////////');

     }

  }
  //it means
  else{
      
       if(j<length){ 
        
        checkupString =  checkupString+_listofString[j]+" ";
        //compare it to the database
       _checkupModel=  await isharmfullCehmical(checkupString.trim().replaceAll(RegExp(","), ""), listofjson);


        if( _checkupModel !=null){
        //store insude the list  and show to user
  
        listofharmfullchemical?.add(_checkupModel);
  
} 
}
}
 

  }
 
}
return listofharmfullchemical;
}


 Future<ChemicalModel?>? isharmfullCehmical(String mys, List<ChemicalModel?>? listofjson) async{
  mys. replaceAll(RegExp("."), "");
  mys.replaceAll("'", "");

   bool listcontain_chemical=false;
   ChemicalModel? _chemicalmodel;
    try{

    //List<ChemicalModel>? listofchemicalmodel= await ChemicalDao().search(mys);
    //if(listofchemicalmodel!=null){
    //  _chemicalmodel=listofchemicalmodel[0];
    //}

   
    if(listofjson !=null){
       listofjson.forEach((element) {
     if(element!.chemicalName.trim().toLowerCase().toString()==mys.trim().toString().toLowerCase()){
     _chemicalmodel=ChemicalModel(
        chemicalName: element.chemicalName, 
       isharmful:  element.isharmful,
      feature: element.feature);
   } 
   });

return _chemicalmodel;
    }
    }
    catch(e){
     return null;
    }
  }

}