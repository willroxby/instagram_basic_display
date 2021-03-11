part of instagram;

Iterable<List<T>> batches<T>(Iterable<T> source, int size) sync* {
  List<T>? accumulator;
  for (var value in source) {
    (accumulator ??= []).add(value);
    if (accumulator.length == size) {
      yield accumulator;
      accumulator = null;
    }
  }
  if (accumulator != null) yield accumulator;
}
