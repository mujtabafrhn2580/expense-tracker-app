extension NumExtension on num {
  dynamic roundPercentage() {
    if (this % 1 == 0) {
      return this.toInt();
    } else {
      return double.parse(this.toStringAsFixed(1));
    }
  }
}
