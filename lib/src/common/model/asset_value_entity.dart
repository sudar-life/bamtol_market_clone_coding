import 'package:photo_manager/photo_manager.dart';

class AssetValueEntity extends AssetEntity {
  final String? thumbnail;
  AssetValueEntity({
    asset,
    this.thumbnail,
  }) : super(
          id: asset != null ? asset.id : '',
          typeInt: asset != null ? asset.typeInt : 0,
          width: asset != null ? asset.width : 0,
          height: asset != null ? asset.height : 0,
        );
}
