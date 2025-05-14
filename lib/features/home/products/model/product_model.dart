import 'package:cloud_firestore/cloud_firestore.dart';

class LocalizedString {
  final String en;
  final String ar;

  LocalizedString({required this.en, required this.ar});

  factory LocalizedString.fromMap(Map<String, dynamic> map) {
    return LocalizedString(en: map['en'] ?? '', ar: map['ar'] ?? '');
  }

  String getLocalized(String languageCode) {
    return languageCode == 'ar' ? ar : en;
  }
}

class RatingSummary {
  final double average;
  final int count;

  RatingSummary({required this.average, required this.count});

  factory RatingSummary.fromMap(Map<String, dynamic> map) {
    return RatingSummary(
      average: (map['average'] as num?)?.toDouble() ?? 0.0,
      count: (map['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class Product {
  final String id;
  final String productId;
  final String productType;
  final LocalizedString title;
  final LocalizedString description;
  final double price;
  final double? discountPrice;
  final int quantity;
  final String sku;
  final String brandId;
  final String categoryId;
  final String subCategoryId;
  final String mainImage;
  final List<String> images;
  final List<String> tags;
  final String vendorId;
  final RatingSummary ratingSummary;
  final int views;
  final int soldCount;
  final int wishlistCount;
  final int trendingScore;
  final int cartAdds;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String categoryNameEn;
  final String categoryNameAr;

  Product({
    required this.id,
    required this.productId,
    required this.productType,
    required this.title,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.quantity,
    required this.sku,
    required this.brandId,
    required this.categoryId,
    required this.subCategoryId,
    required this.mainImage,
    required this.images,
    required this.tags,
    required this.vendorId,
    required this.ratingSummary,
    required this.views,
    required this.soldCount,
    required this.wishlistCount,
    required this.trendingScore,
    required this.cartAdds,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryNameEn,
    required this.categoryNameAr,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final titleMap =
        data['title'] is Map ? data['title'] as Map<String, dynamic> : {};
    final descriptionMap =
        data['description'] is Map
            ? data['description'] as Map<String, dynamic>
            : {};

    return Product(
      categoryNameEn: data['categoryId']['name']['en']?.toString() ?? '',
      categoryNameAr: data['categoryId']['name']['ar']?.toString() ?? '',
      id: doc.id,
      productId: data['productId']?.toString() ?? '',
      productType: data['productType']?.toString() ?? 'simple',
      title: LocalizedString(
        en: titleMap['en']?.toString() ?? '',
        ar: titleMap['ar']?.toString() ?? '',
      ),
      description: LocalizedString(
        en: descriptionMap['en']?.toString() ?? '',
        ar: descriptionMap['ar']?.toString() ?? '',
      ),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (data['discountPrice'] as num?)?.toDouble(),
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      sku: data['sku']?.toString() ?? '',
      brandId: data['brandId']?.toString() ?? '',
      categoryId: data['categoryId']?.toString() ?? '',
      subCategoryId: data['subCategoryId']?.toString() ?? '',
      mainImage: data['mainImage']?.toString() ?? '',
      images:
          (data['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      tags: (data['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      vendorId: data['vendorId']?.toString() ?? '',
      ratingSummary: RatingSummary(
        average: (data['ratingSummary']?['average'] as num?)?.toDouble() ?? 0.0,
        count: (data['ratingSummary']?['count'] as num?)?.toInt() ?? 0,
      ),
      views: (data['views'] as num?)?.toInt() ?? 0,
      soldCount: (data['soldCount'] as num?)?.toInt() ?? 0,
      wishlistCount: (data['wishlistCount'] as num?)?.toInt() ?? 0,
      trendingScore: (data['trendingScore'] as num?)?.toInt() ?? 0,
      cartAdds: (data['cartAdds'] as num?)?.toInt() ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productType': productType,
      'title': {'en': title.en, 'ar': title.ar},
      'description': {'en': description.en, 'ar': description.ar},
      'price': price,
      'discountPrice': discountPrice,
      'quantity': quantity,
      'sku': sku,
      'brandId': brandId,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'mainImage': mainImage,
      'images': images,
      'tags': tags,
      'vendorId': vendorId,
      'ratingSummary': {
        'average': ratingSummary.average,
        'count': ratingSummary.count,
      },
      'views': views,
      'soldCount': soldCount,
      'wishlistCount': wishlistCount,
      'trendingScore': trendingScore,
      'cartAdds': cartAdds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String getLocalizedTitle(String languageCode) =>
      title.getLocalized(languageCode);
  String getLocalizedDescription(String languageCode) =>
      description.getLocalized(languageCode);
}
