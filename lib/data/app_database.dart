import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase{

 static final AppDatabase _singleton= AppDatabase._();
   AppDatabase._();
   static AppDatabase get instance => _singleton;
   Completer<Database>? _dbOpenCompleter;


 Future<Database> get database async{
   if(_dbOpenCompleter==null){
     _dbOpenCompleter=Completer();
     _openDatabase();
   }

   return _dbOpenCompleter!.future;
 }


  Future _openDatabase()async {
    final appDocuentDir= await getApplicationDocumentsDirectory();
    
    final dbpath=  appDocuentDir.path+'/'+'chemical.db' ;

    final database= await databaseFactoryIo.openDatabase(dbpath);

    _dbOpenCompleter?.complete(database);
    await _dbOpenCompleter?.future;

  }

 }