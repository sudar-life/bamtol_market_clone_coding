import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Product extends Equatable {
  final String? docId;
  final String? title;
  final String? description;
  final int? productPrice;
  final bool? isFree;
  final List<String>? imageUrls;
  final UserModel? owner;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? viewCount;
  final ProductStatusType? status;
  final LatLng? wantTradeLocation;
  final String? wantTradeLocationLabel;
  final ProductCategoryType? categoryType;
  final List<String>? likers;
  const Product({
    this.docId,
    this.title,
    this.description,
    this.productPrice = 0,
    this.isFree,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
    this.viewCount = 0,
    this.wantTradeLocation,
    this.wantTradeLocationLabel,
    this.categoryType = ProductCategoryType.none,
    this.status = ProductStatusType.sale,
    this.owner,
    this.likers,
  });

  const Product.empty() : this();

  Map<String, dynamic> toMap() {
    return {
      'owner': owner!.toJson(),
      'title': title,
      'description': description,
      'productPrice': productPrice,
      'isFree': isFree,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'viewCount': viewCount,
      'updatedAt': DateTime.now(),
      'status': status!.value,
      'wantTradeLocation': [
        wantTradeLocation?.latitude,
        wantTradeLocation?.longitude
      ],
      'wantTradeLocationLabel': wantTradeLocationLabel,
      'categoryType': categoryType?.code,
      'likers': likers,
    };
  }

  factory Product.fromJson(String docId, Map<String, dynamic> json) {
    return Product(
      docId: docId,
      title: json['title'],
      description: json['description'],
      productPrice: json['productPrice'],
      isFree: json['isFree'],
      imageUrls: json['imageUrls'].map<String>((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : json['createdAt'].toDate(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : json['updatedAt'].toDate(),
      viewCount: json['viewCount'].toInt(),
      owner: UserModel.fromJson(json['owner']),
      status: json['status'] == null
          ? ProductStatusType.sale
          : ProductStatusType.values.byName(json['status']),
      categoryType: json['categoryType'] == null
          ? ProductCategoryType.none
          : ProductCategoryType.findByCode(json['categoryType']),
      wantTradeLocationLabel: json['wantTradeLocationLabel'],
      wantTradeLocation: json['wantTradeLocation'] != null &&
              json['wantTradeLocation'][0] != null &&
              json['wantTradeLocation'][1] != null
          ? LatLng(json['wantTradeLocation'][0], json['wantTradeLocation'][1])
          : null,
      likers: json['likers']?.map<String>((e) => e as String).toList(),
    );
  }

  Product copyWith({
    String? title,
    String? description,
    UserModel? owner,
    int? productPrice,
    int? viewCount,
    bool? isFree,
    List<String>? imageUrls,
    List<String>? likers,
    ProductStatusType? status,
    LatLng? wantTradeLocation,
    String? wantTradeLocationLabel,
    ProductCategoryType? categoryType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      docId: docId,
      title: title ?? this.title,
      owner: owner ?? this.owner,
      description: description ?? this.description,
      productPrice: productPrice ?? this.productPrice,
      isFree: isFree ?? this.isFree,
      viewCount: viewCount ?? this.viewCount,
      imageUrls: imageUrls ?? this.imageUrls,
      likers: likers ?? this.likers,
      status: status ?? this.status,
      wantTradeLocation: wantTradeLocation ?? this.wantTradeLocation,
      wantTradeLocationLabel:
          wantTradeLocationLabel ?? this.wantTradeLocationLabel,
      categoryType: categoryType ?? this.categoryType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        title,
        owner,
        description,
        productPrice,
        isFree,
        imageUrls,
        createdAt,
        viewCount,
        status,
        likers,
        wantTradeLocation,
        wantTradeLocationLabel,
        categoryType,
        updatedAt,
      ];
}
