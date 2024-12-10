import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NetworkErrorState {
  const NetworkErrorState({
    required this.hasInternetError,
    required this.hasServerError,
  });

  final bool hasInternetError;
  final bool hasServerError;

  NetworkErrorState copyWith({
    bool? hasInternetError,
    bool? hasServerError,
  });
}

abstract base class BaseLoadingState extends Equatable implements NetworkErrorState {
  const BaseLoadingState({
    this.loading = false,
    this.hasServerError = false,
    this.hasInternetError = false,
  });

  final bool loading;

  @override
  final bool hasInternetError;

  @override
  final bool hasServerError;

  @mustCallSuper
  @override
  List<Object?> get props => [loading];

  bool get hasData;

  bool get showLoading;

  @override
  BaseLoadingState copyWith({bool? loading, bool? hasInternetError, bool? hasServerError});
}

base class LoadingState extends BaseLoadingState {
  const LoadingState({
    super.loading,
    super.hasServerError,
    super.hasInternetError,
  });

  @override
  LoadingState copyWith({
    bool? hasInternetError,
    bool? hasServerError,
    bool? loading,
  }) {
    return LoadingState(
      hasInternetError: hasInternetError ?? this.hasInternetError,
      hasServerError: hasServerError ?? this.hasServerError,
      loading: loading ?? this.loading,
    );
  }

  @override
  bool get hasData => false;

  @override
  bool get showLoading => loading;
}

base class DataState<T extends Object?> extends BaseLoadingState {
  const DataState({
    super.loading,
    this.data,
    super.hasServerError,
    super.hasInternetError,
  });

  final T? data;

  @override
  bool get hasData => data != null;

  @override
  bool get showLoading => data == null && loading;

  @override
  List<Object?> get props => super.props..add(data);

  @override
  DataState copyWith({
    bool? loading,
    T? data,
    bool? hasInternetError,
    bool? hasServerError,
  }) {
    return DataState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      hasInternetError: hasInternetError ?? this.hasInternetError,
      hasServerError: hasServerError ?? this.hasServerError,
    );
  }
}

base class ListState<T extends Object> extends BaseLoadingState {
  const ListState({
    super.loading,
    this.list = const [],
    super.hasServerError,
    super.hasInternetError,
  });

  final List<T> list;

  T operator [](int index) => list[index];

  @override
  bool get hasData => list.isNotEmpty;

  @override
  bool get showLoading => list.isEmpty && loading;

  @override
  List<Object?> get props => super.props..add(list);

  @override
  ListState<T> copyWith({
    bool? loading,
    List<T>? list,
    bool? hasInternetError,
    bool? hasServerError,
  }) {
    return ListState(
      list: list ?? this.list,
      loading: loading ?? this.loading,
      hasServerError: hasServerError ?? this.hasServerError,
      hasInternetError: hasInternetError ?? this.hasInternetError,
    );
  }
}

base class SelectionListState<T extends Object, S extends Object?> extends ListState<T> {
  const SelectionListState({
    super.loading,
    super.list,
    this.selected,
    super.hasServerError,
    super.hasInternetError,
  });

  final S? selected;

  @override
  List<Object?> get props => super.props..add(selected);

  @override
  SelectionListState<T, S> copyWith({
    bool? loading,
    List<T>? list,
    S? selected,
    bool? hasInternetError,
    bool? hasServerError,
  }) {
    return SelectionListState(
      loading: loading ?? this.loading,
      list: list ?? this.list,
      selected: selected ?? this.selected,
      hasServerError: hasServerError ?? this.hasServerError,
      hasInternetError: hasInternetError ?? this.hasInternetError,
    );
  }
}

base class PaginatedListState<T extends Object> extends ListState<T> {
  const PaginatedListState({
    super.loading,
    super.list,
    this.reachAtEnd = false,
    super.hasServerError,
    super.hasInternetError,
  });

  final bool reachAtEnd;

  @override
  List<Object?> get props => super.props..add(reachAtEnd);

  @override
  PaginatedListState<T> copyWith({
    bool? loading,
    List<T>? list,
    bool? reachAtEnd,
    bool? hasInternetError,
    bool? hasServerError,
  }) {
    return PaginatedListState(
      loading: loading ?? this.loading,
      list: list ?? this.list,
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
      hasServerError: hasServerError ?? this.hasServerError,
      hasInternetError: hasInternetError ?? this.hasInternetError,
    );
  }

  PaginatedListState<T> appendList({
    bool? loading,
    required List<T> list,
    bool? reachAtEnd,
    bool? hasInternetError,
    bool? hasServerError,
  }) {
    return PaginatedListState(
      loading: loading ?? this.loading,
      list: List.from(this.list)..addAll(list),
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
      hasServerError: hasServerError ?? this.hasServerError,
      hasInternetError: hasInternetError ?? this.hasInternetError,
    );
  }
}
