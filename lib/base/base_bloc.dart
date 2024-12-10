import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:network/network.dart';

abstract base class BaseBloc<Event, State> extends Bloc<Event, State>
    with StreamSubscriptionMixin, ApiMixin, ListMixin {
  BaseBloc(this.context, super.initialState);

  @override
  final BuildContext context;

  @override
  StreamSubscription<DataEvent<T>> processData<T>(
    Stream<DataEvent<T>> stream, {
    bool handleLoading = true,
    bool ignoreCache = false,
    required ResultCallback<T>? onSuccess,
    LoadingCallback? onLoading,
    ApiExceptionCallback? onFailure,
  }) {
    final subscription = super.processData(
      stream,
      handleLoading: handleLoading,
      ignoreCache: ignoreCache,
      onLoading: onLoading,
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
    listSubscription.add(subscription);
    return subscription;
  }
}
