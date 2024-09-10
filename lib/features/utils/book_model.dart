class BookModel {
  final String id;
  final String imageUrl;
  final String title;
  final String price;
  final String description;
  final String author;
  final String authorBio;
  final DateTime releaseDate;
  final String category;
  final String? pdfUrl;

  BookModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
    required this.author,
    required this.authorBio,
    required this.releaseDate,
    required this.category,
    this.pdfUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      author: json['author'],
      authorBio: json['authorBio'],
      releaseDate: DateTime.parse(json['releaseDate']),
      category: json['category'],
      pdfUrl: json['pdfUrl'],
    );
  }
}

class BookDetails {
  final String title;
  final String author;
  final String imageUrl;

  BookDetails({
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}