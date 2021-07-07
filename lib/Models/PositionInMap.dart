class PositionInMap {
  String streetName;
  String section;
  String city;

  PositionInMap(this.streetName, this.city, this.section);

  void addSection(String section) {
    this.section = section;
  }

  @override
  String toString() {
    return ("streetName: " +
        streetName +
        ", section: " +
        section.toString() +
        ", city: " +
        city);
  }
}
