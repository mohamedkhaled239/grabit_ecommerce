import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/model/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController extends Cubit<HomeState> {
  final HomeModel _model;

  HomeController(this._model) : super(HomeInitial()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    emit(HomeLoading());
    try {
      await _model.getLatestProducts().first;
      emit(HomeLoaded('default-custom-id'));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Stream<List<Product>> getLatestProducts() {
    return _model.getLatestProducts();
  }
}
