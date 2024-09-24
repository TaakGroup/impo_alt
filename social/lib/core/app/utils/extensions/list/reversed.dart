extension Reversed on List {
  reverse({bool condition = true}) {
    if (condition) return reversed.toList();

    return this;
  }
}
