import 'package:dodo_clone/src/features/location/bloc/select_city_cubit/select_city_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCityCubit extends Cubit<SelectCityState>{
  late final ScrollController scrollController;


  SelectCityCubit() : super(SelectCityState());

  void _init() {

  }

}
