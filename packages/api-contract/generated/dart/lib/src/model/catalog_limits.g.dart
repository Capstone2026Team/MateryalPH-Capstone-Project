// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_limits.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogLimits extends CatalogLimits {
  @override
  final int maxVariants;
  @override
  final int maxMedia;
  @override
  final int maxListingImageKb;
  @override
  final BuiltList<String> imageTypes;

  factory _$CatalogLimits([void Function(CatalogLimitsBuilder)? updates]) =>
      (CatalogLimitsBuilder()..update(updates))._build();

  _$CatalogLimits._(
      {required this.maxVariants,
      required this.maxMedia,
      required this.maxListingImageKb,
      required this.imageTypes})
      : super._();
  @override
  CatalogLimits rebuild(void Function(CatalogLimitsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogLimitsBuilder toBuilder() => CatalogLimitsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogLimits &&
        maxVariants == other.maxVariants &&
        maxMedia == other.maxMedia &&
        maxListingImageKb == other.maxListingImageKb &&
        imageTypes == other.imageTypes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxVariants.hashCode);
    _$hash = $jc(_$hash, maxMedia.hashCode);
    _$hash = $jc(_$hash, maxListingImageKb.hashCode);
    _$hash = $jc(_$hash, imageTypes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogLimits')
          ..add('maxVariants', maxVariants)
          ..add('maxMedia', maxMedia)
          ..add('maxListingImageKb', maxListingImageKb)
          ..add('imageTypes', imageTypes))
        .toString();
  }
}

class CatalogLimitsBuilder
    implements Builder<CatalogLimits, CatalogLimitsBuilder> {
  _$CatalogLimits? _$v;

  int? _maxVariants;
  int? get maxVariants => _$this._maxVariants;
  set maxVariants(int? maxVariants) => _$this._maxVariants = maxVariants;

  int? _maxMedia;
  int? get maxMedia => _$this._maxMedia;
  set maxMedia(int? maxMedia) => _$this._maxMedia = maxMedia;

  int? _maxListingImageKb;
  int? get maxListingImageKb => _$this._maxListingImageKb;
  set maxListingImageKb(int? maxListingImageKb) =>
      _$this._maxListingImageKb = maxListingImageKb;

  ListBuilder<String>? _imageTypes;
  ListBuilder<String> get imageTypes =>
      _$this._imageTypes ??= ListBuilder<String>();
  set imageTypes(ListBuilder<String>? imageTypes) =>
      _$this._imageTypes = imageTypes;

  CatalogLimitsBuilder() {
    CatalogLimits._defaults(this);
  }

  CatalogLimitsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxVariants = $v.maxVariants;
      _maxMedia = $v.maxMedia;
      _maxListingImageKb = $v.maxListingImageKb;
      _imageTypes = $v.imageTypes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogLimits other) {
    _$v = other as _$CatalogLimits;
  }

  @override
  void update(void Function(CatalogLimitsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogLimits build() => _build();

  _$CatalogLimits _build() {
    _$CatalogLimits _$result;
    try {
      _$result = _$v ??
          _$CatalogLimits._(
            maxVariants: BuiltValueNullFieldError.checkNotNull(
                maxVariants, r'CatalogLimits', 'maxVariants'),
            maxMedia: BuiltValueNullFieldError.checkNotNull(
                maxMedia, r'CatalogLimits', 'maxMedia'),
            maxListingImageKb: BuiltValueNullFieldError.checkNotNull(
                maxListingImageKb, r'CatalogLimits', 'maxListingImageKb'),
            imageTypes: imageTypes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'imageTypes';
        imageTypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogLimits', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
