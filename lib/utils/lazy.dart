import 'dart:async';

sealed class BaseFactory<T> {
  const BaseFactory(this.factory);

  final T Function() factory;

  T call() => factory();
}

base class LazyFactory<T> extends BaseFactory<T> {
  const LazyFactory(super.function);
}

base class LazyFutureFactory<T> extends BaseFactory<T> {
  const LazyFutureFactory(super.function);
}

sealed class BaseLazy<T> {
  T call();

  T get value => call();

  bool get isInitialized;
}

class Lazy<T> extends BaseLazy<T> {
  final LazyFactory<T> _factory;
  T? _data;

  Lazy(this._factory);

  @override
  T call() => _data ??= _factory();

  @override
  bool get isInitialized => _data != null;
}

class LazyFuture<T> extends BaseLazy<Future<T>> {
  final LazyFutureFactory<T> _factory;
  final Completer<T> _completer = Completer();
  bool _isCompleted = false;

  LazyFuture(this._factory);

  @override
  Future<T> call() {
    if (!_isCompleted) {
      _completer.complete(_factory());
      _isCompleted = true;
    }
    return _completer.future;
  }

  @override
  bool get isInitialized => _isCompleted;
}
