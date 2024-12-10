import 'package:bloc/bloc.dart';
import 'package:core/base/base.dart';
import 'package:network/network.dart';

base mixin NetworkErrorMixin<S extends NetworkErrorState> on BaseCubit<S> {
  void handleApiNetworkFailure(ApiException exception) {
    switch (exception) {
      case InternetConnectionException():
        emit(state.copyWith(hasInternetError: true) as S);
        break;
      case ApiResponseException():
        emit(state.copyWith(hasServerError: true) as S);
        break;
    }
  }
}

base mixin NetworkErrorBlocMixin<E, S extends NetworkErrorState> on BaseBloc<E, S> {
  void handleApiNetworkFailure(ApiException exception, Emitter<S> emit) {
    switch (exception) {
      case InternetConnectionException():
        emit(state.copyWith(hasInternetError: true) as S);
        break;
      case ApiResponseException():
        emit(state.copyWith(hasServerError: true) as S);
        break;
    }
  }
}
