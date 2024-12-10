import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/base/base.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:network/network.dart';

abstract base class BaseCubit<State> extends Cubit<State> with StreamSubscriptionMixin, ApiMixin, ListMixin {
  BaseCubit(this.context, super.initialState) {
    Timer.run(onCreate);
  }

  @override
  final BuildContext context;

  @protected
  @mustCallSuper
  void onCreate() {}

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

  Future<void> onRefresh() async {}
}

abstract base class DataCubit<State extends DataState> extends BaseCubit<State> {
  DataCubit(super.context, super.initialState);

  @override
  @mustCallSuper
  Future<void> onRefresh() async {
    if (state.loading) return;
    return fetchData();
  }

  Future<void> fetchData();
}

abstract base class ListCubit<State extends ListState> extends BaseCubit<State> {
  ListCubit(super.context, super.initialState);

  @override
  @mustCallSuper
  Future<void> onRefresh() async {
    if (state.loading) return;
    return fetchList();
  }

  Future<void> fetchList();
}

abstract base class PaginatedListCubit<State extends PaginatedListState<T>, T extends Object> extends ListCubit<State> {
  PaginatedListCubit(super.context, super.initialState);

  @mustCallSuper
  bool onScrollNotification(UserScrollNotification notification) {
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) onScrollToEnd();
    return false;
  }

  @mustCallSuper
  Future<void> onScrollToEnd() async {
    if (state.loading || state.reachAtEnd) return;
    emit(state.copyWith(loading: true) as State);
    return fetchList();
  }

  @override
  @mustCallSuper
  Future<void> onRefresh() async {
    if (state.loading) return;
    emit(state.copyWith(reachAtEnd: false, list: <T>[]) as State);
    return super.onRefresh();
  }
}
