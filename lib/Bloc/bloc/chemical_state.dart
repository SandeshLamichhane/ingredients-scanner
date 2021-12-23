part of 'chemical_bloc.dart';

abstract class ChemicalState extends Equatable {
    ChemicalState():super();
  
  @override
  List<Object> get props => [];
}

class ChemicalInitial extends ChemicalState {}

class ChemicalLoading extends ChemicalState {}


class NotAnyChemicalFound extends ChemicalState{}


class ChemicalLoaded extends ChemicalState{
  
   final  List<ChemicalModel> _listofmodel;
    ChemicalLoaded(this._listofmodel);
    List<ChemicalModel>? get getListofchemical=>_listofmodel;
   
  @override
  // TODO: implement props

  List<Object> get props => [_listofmodel];
 
}
