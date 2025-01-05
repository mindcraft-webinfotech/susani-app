class BookedDate {
  int? id;
  String? date;

  BookedDate({
    this.date,
  });
  BookedDate.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    date = json['date'];
  }
}
