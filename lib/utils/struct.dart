class Pair<T, V> {
  final T first;
  final V second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}

mixin ResultMixin<T> {
  T? getResult();
}

mixin RefreshState<T> {
  void refresh(T value);
}

typedef NextCallback<T> = void Function(T? value);
