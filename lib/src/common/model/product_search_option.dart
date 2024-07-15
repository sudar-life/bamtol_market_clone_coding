import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductSearchOption extends Equatable {
  QueryDocumentSnapshot? lastItem;
  List<ProductStatusType>? status;
  String? ownerId;

  ProductSearchOption({
    this.lastItem,
    this.status,
    this.ownerId,
  });

  ProductSearchOption copyWith({
    QueryDocumentSnapshot? lastItem,
    String? ownerId,
    List<ProductStatusType>? status,
  }) {
    return ProductSearchOption(
      lastItem: lastItem,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  Query<Object?> toQuery(CollectionReference<Object?> collection) {
    Query<Object?> query = collection;
    if (status != null && status!.isNotEmpty) {
      query =
          query.where('status', whereIn: status!.map((e) => e.value).toList());
    }
    if (ownerId != null) {
      query = query.where('owner.uid', isEqualTo: ownerId);
    }
    query = query.orderBy('createdAt', descending: true);
    return query;
  }

  @override
  List<Object?> get props => [
        lastItem,
        status,
        ownerId,
      ];
}
