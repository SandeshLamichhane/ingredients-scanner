import 'package:scanner/Model/chemical.dart';
import 'package:scanner/data/app_database.dart';
import 'package:sembast/sembast.dart';

class ChemicalDao{

  static const String NAME='chemicals';

   final _fruitStore= intMapStoreFactory.store(NAME);
   
   Future<Database> get _db async=> await AppDatabase.instance.database;


  Future insert(ChemicalModel fruit) async{
  await _fruitStore.add(await _db, fruit.toMap(fruit));
 
 
   }

   Future update(ChemicalModel model) async{
  final finder= Finder(filter: Filter.byKey(model.chemicalName));
  await _fruitStore.update(
    await _db, 
    model.toMap(model),
    finder: finder
    
    );

   }


   Future delete(ChemicalModel model) async{
    final finder= Finder(filter: Filter.byKey(model.chemicalName));
       
 

   await _fruitStore.delete(
    await _db, 
    finder: finder
    ); 
   }

   //delete all json 
   deleteAlljson() async{
       await _fruitStore.delete(await _db);
  
   }


 Future<List<ChemicalModel?>>? getalljson() async {
     
int i=0;
     print("shas..........................................");
     final  recordsnp=  await _fruitStore.find( await _db);
    final map=    recordsnp.map((e)  {
        final abc=  ChemicalModel.fromMap(e.value);
        abc.id=e.key;
        print('///////////||||||||||\\\\'+ (i++).toString() +'  '+abc.chemicalName.toString());

        return abc;

      }).toList();

  return map;
   }


   Future<List<ChemicalModel>> getAllSortedByName() async{
     final finder= Finder(
       //filter: Filter.equals("chemicalName", "value"),
       sortOrders: [
       SortOrder('chemicalName')
     ]);

     final  recordsnp=await _fruitStore.find(
       await _db,
       finder: finder
     );

     return recordsnp.map((e) {
       final fruit= ChemicalModel.fromMap(e.value);
       fruit.id= e.key;
       return fruit;
     }).toList();
   }

  

  Future<List<ChemicalModel>>? search(String chemical)async {

    
  chemical. replaceAll(RegExp("."), "");
  chemical.replaceAll("'", "");



    final finder= Finder(
      
      filter: Filter.equals("chemicalName", chemical.trim().toLowerCase()),
      sortOrders: [SortOrder('chemicalName')]
    );
   final  recordsnp=await _fruitStore.find(
       await _db,
       finder: finder
     );
     
     return recordsnp.map((e) {
        final fruit= ChemicalModel.fromMap(e.value);
       fruit.id= e.key;
       return fruit;
     }).toList();
  }


   }
   
   
 