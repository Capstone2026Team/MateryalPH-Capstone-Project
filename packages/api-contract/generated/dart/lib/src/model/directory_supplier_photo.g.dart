// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_supplier_photo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectorySupplierPhoto extends DirectorySupplierPhoto {
  @override
  final BuiltList<GooglePlacePhoto> photos;
  @override
  final BuiltList<GoogleContentAuthor> providerAttributions;

  factory _$DirectorySupplierPhoto(
          [void Function(DirectorySupplierPhotoBuilder)? updates]) =>
      (DirectorySupplierPhotoBuilder()..update(updates))._build();

  _$DirectorySupplierPhoto._(
      {required this.photos, required this.providerAttributions})
      : super._();
  @override
  DirectorySupplierPhoto rebuild(
          void Function(DirectorySupplierPhotoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectorySupplierPhotoBuilder toBuilder() =>
      DirectorySupplierPhotoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectorySupplierPhoto &&
        photos == other.photos &&
        providerAttributions == other.providerAttributions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, photos.hashCode);
    _$hash = $jc(_$hash, providerAttributions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectorySupplierPhoto')
          ..add('photos', photos)
          ..add('providerAttributions', providerAttributions))
        .toString();
  }
}

class DirectorySupplierPhotoBuilder
    implements Builder<DirectorySupplierPhoto, DirectorySupplierPhotoBuilder> {
  _$DirectorySupplierPhoto? _$v;

  ListBuilder<GooglePlacePhoto>? _photos;
  ListBuilder<GooglePlacePhoto> get photos =>
      _$this._photos ??= ListBuilder<GooglePlacePhoto>();
  set photos(ListBuilder<GooglePlacePhoto>? photos) => _$this._photos = photos;

  ListBuilder<GoogleContentAuthor>? _providerAttributions;
  ListBuilder<GoogleContentAuthor> get providerAttributions =>
      _$this._providerAttributions ??= ListBuilder<GoogleContentAuthor>();
  set providerAttributions(
          ListBuilder<GoogleContentAuthor>? providerAttributions) =>
      _$this._providerAttributions = providerAttributions;

  DirectorySupplierPhotoBuilder() {
    DirectorySupplierPhoto._defaults(this);
  }

  DirectorySupplierPhotoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _photos = $v.photos.toBuilder();
      _providerAttributions = $v.providerAttributions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectorySupplierPhoto other) {
    _$v = other as _$DirectorySupplierPhoto;
  }

  @override
  void update(void Function(DirectorySupplierPhotoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectorySupplierPhoto build() => _build();

  _$DirectorySupplierPhoto _build() {
    _$DirectorySupplierPhoto _$result;
    try {
      _$result = _$v ??
          _$DirectorySupplierPhoto._(
            photos: photos.build(),
            providerAttributions: providerAttributions.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'photos';
        photos.build();
        _$failedField = 'providerAttributions';
        providerAttributions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectorySupplierPhoto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
