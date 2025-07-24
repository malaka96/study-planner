class Note {
  final String id;
  final String title;
  final String description;
  final String section;
  final String reference;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.section,
    required this.reference,
  });

  factory Note.fromJson(Map<String, dynamic> data) {
    return Note(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      section: data['section'],
      reference: data['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'description' : description,
      'section' : section,
      'reference' : reference,
    };
  }
}
