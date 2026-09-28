// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_deleted_envelope_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogListingDeletedEnvelopeData
    extends CatalogListingDeletedEnvelopeData {
  @override
  final String id;
  @override
  final DateTime removedAt;

  factory _$CatalogListingDeletedEnvelopeData(
          [void Function(CatalogListingDeletedEnvelopeDataBuilder)? updates]) =>
      (CatalogListingDeletedEnvelopeDataBuilder()..update(updates))._build();

  _$CatalogListingDeletedEnvelopeData._(
      {required this.id, required this.removedAt})
      : super._();
  @override
  CatalogListingDeletedEnvelopeData rebuild(
          void Function(CatalogListingDeletedEnvelopeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingDeletedEnvelopeDataBuilder toBuilder() =>
      CatalogListingDeletedEnvelopeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingDeletedEnvelopeData &&
        id == other.id &&
        removedAt == other.removedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, removedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingDeletedEnvelopeData')
          ..add('id', id)
          ..add('removedAt', removedAt))
        .toString();
  }
}

class CatalogListingDeletedEnvelopeDataBuilder
    implements
        Builder<CatalogListingDeletedEnvelopeData,
            CatalogListingDeletedEnvelopeDataBuilder> {
  _$CatalogListingDeletedEnvelopeData? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _removedAt;
  DateTime? get removedAt => _$this._removedAt;
  set removedAt(DateTime? removedAt) => _$this._removedAt = removedAt;

  CatalogListingDeletedEnvelopeDataBuilder() {
    CatalogListingDeletedEnvelopeData._defaults(this);
  }

  CatalogListingDeletedEnvelopeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _removedAt = $v.removedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingDeletedEnvelopeData other) {
    _$v = other as _$CatalogListingDeletedEnvelopeData;
  }

  @override
  void update(
      void Function(CatalogListingDeletedEnvelopeDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingDeletedEnvelopeData build() => _build();

  _$CatalogListingDeletedEnvelopeData _build() {
    final _$result = _$v ??
        _$CatalogListingDeletedEnvelopeData._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CatalogListingDeletedEnvelopeData', 'id'),
          removedAt: BuiltValueNullFieldError.checkNotNull(
              removedAt, r'CatalogListingDeletedEnvelopeData', 'removedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
