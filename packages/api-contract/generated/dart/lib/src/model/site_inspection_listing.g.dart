// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_listing.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionListing extends SiteInspectionListing {
  @override
  final String id;
  @override
  final String displayName;

  factory _$SiteInspectionListing(
          [void Function(SiteInspectionListingBuilder)? updates]) =>
      (SiteInspectionListingBuilder()..update(updates))._build();

  _$SiteInspectionListing._({required this.id, required this.displayName})
      : super._();
  @override
  SiteInspectionListing rebuild(
          void Function(SiteInspectionListingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionListingBuilder toBuilder() =>
      SiteInspectionListingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionListing &&
        id == other.id &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionListing')
          ..add('id', id)
          ..add('displayName', displayName))
        .toString();
  }
}

class SiteInspectionListingBuilder
    implements Builder<SiteInspectionListing, SiteInspectionListingBuilder> {
  _$SiteInspectionListing? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  SiteInspectionListingBuilder() {
    SiteInspectionListing._defaults(this);
  }

  SiteInspectionListingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionListing other) {
    _$v = other as _$SiteInspectionListing;
  }

  @override
  void update(void Function(SiteInspectionListingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionListing build() => _build();

  _$SiteInspectionListing _build() {
    final _$result = _$v ??
        _$SiteInspectionListing._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SiteInspectionListing', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'SiteInspectionListing', 'displayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
