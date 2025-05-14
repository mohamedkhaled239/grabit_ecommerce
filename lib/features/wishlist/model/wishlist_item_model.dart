class WishlistItem {
  final String id;
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final double price;

  WishlistItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': {'en': nameEn, 'ar': nameAr},
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    final titleMap = map['title'] as Map<String, dynamic>?;

    return WishlistItem(
      id: map['id'] ?? '',
      nameEn: titleMap?['en'] ?? '',
      nameAr: titleMap?['ar'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}
