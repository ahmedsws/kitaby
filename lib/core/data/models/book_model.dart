class BookModel {
  final String isbn,
      title,
      author,
      publisher,
      edition,
      description,
      coverImageUrl,
      category,
      dealType;
  // final DateTime publicationDate;
  final int pageCount, quantity;
  final List<int> ratings;
  final num price;
  final bool status;

  const BookModel({
    required this.isbn,
    required this.title,
    required this.author,
    required this.publisher,
    required this.edition,
    required this.description,
    required this.coverImageUrl,
    required this.category,
    // required this.publicationDate,
    required this.pageCount,
    required this.quantity,
    required this.price,
    this.ratings = const [0],
    required this.status,
    this.dealType = 'بيع',
  });

  BookModel.fromJson(Map<String, dynamic> json)
      : isbn = json['ISBN'],
        title = json['Title'],
        author = json['Author'],
        publisher = json['Publisher'],
        edition = json['Edition'],
        description = json['Descreption'],
        coverImageUrl = json['Cover_Image_url'],
        category = json['Category'],
        // publicationDate = DateTime.parse(json['Publication_Date']),
        pageCount = json['Page_Count'],
        quantity = json['Quantity'],
        price = json['Price'],
        ratings = json['Ratings'] != null ? List.from(json['Ratings']) : [0],
        status = json['Status'],
        dealType = json['Deal_Type'] ?? 'sell';

  Map<String, Object?> toJson() => {
        'ISBN': isbn,
        'Title': title,
        'Author': author,
        'Publisher': publisher,
        'Edition': edition,
        'Descreption': description,
        'Cover_Image_url': coverImageUrl,
        'Category': category,
        // publicationDate = DateTime.parse(json['Publication_Date']),
        'Page_Count': pageCount,
        'Quantity': quantity,
        'Price': price,
        'Status': status,
        'Deal_Type': dealType,
        'Ratings': ratings,
      };
}
