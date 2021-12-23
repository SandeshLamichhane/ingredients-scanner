part of 'chemical_bloc.dart';

abstract class ChemicalEvent extends Equatable {
  const ChemicalEvent();

  @override
  List<Object> get props => [];

}

class ChemicalInitialEvent extends ChemicalEvent{}


class Loadchemical extends ChemicalEvent{}


class AddChemicaltoFirestore extends ChemicalEvent{
  

}
class Addchemical extends ChemicalEvent{
  String _chemical;
  Addchemical(this._chemical);
  @override
  // TODO: implement props
  List<Object> get props => [_chemical];

}

class  updateChemicla extends ChemicalEvent{
  late ChemicalModel chemicalModel;
  //updateChemicla(this.chemicalModel):super([chemicalModel])
}

class DeleteChemical extends ChemicalEvent{
late  final ChemicalModel chemicalModel;
DeleteChemical(this.chemicalModel):super();
}

class SearchChemical extends ChemicalEvent{
   List<String> _chemical;
  SearchChemical(this._chemical);
  @override
  // TODO: implement props
  List<Object> get props => [_chemical];
}