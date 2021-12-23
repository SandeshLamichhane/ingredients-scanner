import 'dart:convert';

import 'package:meta/meta.dart';

class ChemicalModel {


   int? id;
   final String chemicalName;
   final bool isharmful;
   final String feature;
   String? alternative;
 //alternative
   ChemicalModel({
     this.id,
     required this.chemicalName,
     required this.isharmful,
     required this.feature,
     this.alternative
   });


   


  Map<String, dynamic> toMap(ChemicalModel model) {
    return {
      'id': model.id,
      'chemicalName': model.chemicalName,
      'isharmful': model.isharmful,
      'feature': model.feature,
      'alternative':model.alternative
    };
  }

 
  
 
 static ChemicalModel fromMap(Map<String, dynamic> map){
   return ChemicalModel(
     chemicalName: map['chemicalName'],
      isharmful: map['isharmful'],
       feature: map['feature'],
       alternative: map['alternative'],
       id: map['id']
   ) ;
 }

 static List<ChemicalModel> listofharmfulChemical =
 [




   ChemicalModel(
     chemicalName: "Geranol", isharmful: true, feature: "may disrupt our natural hormonal balance"),

  ChemicalModel(
     chemicalName: "Sodium chloride", isharmful: true, feature: "may disrupt our natural hormonal balance"),

   ChemicalModel(
     chemicalName: "DISODIUM EDTA", isharmful: true, feature: "may disrupt our natural hormonal balance"),

    ChemicalModel(
     chemicalName: "Sulfates", isharmful: true, feature: "may disrupt our natural hormonal balance"),
       ChemicalModel(
     chemicalName: "Petrochemicals", isharmful: true, feature: "may disrupt our natural hormonal balance"),
       ChemicalModel(
     chemicalName: "Propylene Glycol", isharmful: true, feature: "may disrupt our natural hormonal balance"),

       ChemicalModel(
     chemicalName: "SLS", isharmful: true, feature: "may disrupt our natural hormonal balance"),

       ChemicalModel(
     chemicalName: "Sodium Lauryl Sulfate", isharmful: true, feature: "may disrupt our natural hormonal balance"),

       ChemicalModel(
     chemicalName: "Parabens", isharmful: true, feature: "they kill both good and bad bacteria indiscriminately. "),

       ChemicalModel(
     chemicalName: "Triclosan", isharmful: true, feature: "may disrupt our natural hormonal balance"),

       ChemicalModel(
     chemicalName: "Fragrance", isharmful: true, feature: "may disrupt our natural hormonal balance"),

 ];
}
