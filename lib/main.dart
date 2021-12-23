import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner/Bloc/bloc/chemical_bloc.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scanner/Screen/intro.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChemicalBloc(),
      child: MaterialApp(
      theme: ThemeData(
        primaryColor:Colors.deepPurple
      ),
        debugShowCheckedModeBanner: false,
        home: intro(),
      ),
    );
  }
}
