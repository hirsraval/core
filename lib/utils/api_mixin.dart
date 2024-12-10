import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:network/network.dart';

typedef ResultCallback<T> = void Function(T data);
typedef LoadingCallback = void Function(bool isLoading);
typedef ApiExceptionCallback = void Function(ApiException exception);

mixin ApiMixin<S extends Object?> on BlocBase<S> {
  int _loaderCount = 0;
  late final _navigator = Navigator.of(context);
  Route? _dialogRoute;

  BuildContext get context;

  @override
  Future<void> close() {
    if (_loaderCount > 0) handleLoading(false);
    return super.close();
  }

  @mustCallSuper
  @protected
  StreamSubscription<DataEvent<T>> processData<T>(
    Stream<DataEvent<T>> stream, {
    bool handleLoading = true,
    bool ignoreCache = false,
    required ResultCallback<T>? onSuccess,
    LoadingCallback? onLoading,
    ApiExceptionCallback? onFailure,
  }) {
    return stream.listen((event) {
      switch (event) {
        case LoadingEvent<T>():
          if (handleLoading) (onLoading ?? _handleLoader)(event.isLoading);
          break;
        case SuccessEvent<T>():
          if (event.isCache && ignoreCache) break;
          onSuccess?.call(event.data);
          break;
        case FailureEvent<T>():
          (onFailure ?? addError)(event.exception);
      }
    });
  }

  @mustCallSuper
  @protected
  Future<void> processDataRequest<T>(
    Future<T> request, {
    bool handleLoading = true,
    required ResultCallback<T>? onSuccess,
    LoadingCallback? onLoading,
    ApiExceptionCallback? onFailure,
  }) async {
    try {
      if (handleLoading) (onLoading ?? _handleLoader)(true);
      final result = await request;
      if (handleLoading) (onLoading ?? _handleLoader)(false);
      onSuccess?.call(result);
    } on ApiException catch (exception) {
      if (handleLoading) (onLoading ?? _handleLoader)(false);
      (onFailure ?? addError)(exception);
    } catch (error, stackTrace) {
      if (handleLoading) (onLoading ?? _handleLoader)(false);
      Log.error(error);
      Log.error(stackTrace);
    }
  }

  void _handleLoader(bool isLoading) {
    if (isLoading) {
      if (_loaderCount == 0) handleLoading(isLoading);
      _loaderCount++;
    } else {
      _loaderCount = max(0, _loaderCount - 1);
      if (_loaderCount == 0) handleLoading(isLoading);
    }
  }

  void handleLoading(bool isLoading) {
    if (isLoading) {
      _startLoading();
    } else {
      _stopLoading();
    }
  }

  Route _buildDialogRoute(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final CapturedThemes themes = InheritedTheme.capture(from: context, to: _navigator.context);
    return DialogRoute(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      settings: const RouteSettings(name: "/loading_dialog"),
      themes: themes,
      builder: (context) => const LoadingIndicator(),
    );
  }

  void _startLoading() {
    if (_dialogRoute != null) return;
    _dialogRoute = _buildDialogRoute(context);
    _navigator.push(_dialogRoute!);
  }

  void _stopLoading() {
    if (_dialogRoute != null) _navigator.removeRoute(_dialogRoute!);
    _dialogRoute = null;
  }
}
