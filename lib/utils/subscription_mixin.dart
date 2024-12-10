import 'dart:async';

import 'package:bloc/bloc.dart';

mixin StreamSubscriptionMixin<S extends Object?> on BlocBase<S> {
  final List<StreamSubscription> _listSubscription = [];

  List<StreamSubscription> get listSubscription => _listSubscription;

  @override
  Future<void> close() {
    return Future.wait([
      ..._listSubscription.map((subscription) => subscription.cancel()),
      super.close(),
    ]);
  }
}
