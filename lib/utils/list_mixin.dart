import 'package:bloc/bloc.dart';

mixin ListMixin<S extends Object?> on BlocBase<S> {
  List<T> appendItems<T>(List<T> initialList, List<T> list) {
    return [...initialList, ...list];
  }

  List<T> replaceItemAt<T>(List<T> initialList, int index, T item) {
    return List<T>.from(initialList)..[index] = item;
  }

  List<T> insertItemAt<T>(Iterable<T> initialList, T item, int index) {
    return List.from(initialList)..insert(index, item);
  }

  List<T> removeItemAt<T>(List<T> initialList, int index) {
    return List<T>.from(initialList)..removeAt(index);
  }
}