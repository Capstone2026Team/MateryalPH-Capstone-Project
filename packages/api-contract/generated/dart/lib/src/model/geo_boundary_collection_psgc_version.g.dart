// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_boundary_collection_psgc_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoBoundaryCollectionPsgcVersion
    extends GeoBoundaryCollectionPsgcVersion {
  @override
  final String id;
  @override
  final String label;

  factory _$GeoBoundaryCollectionPsgcVersion(
          [void Function(GeoBoundaryCollectionPsgcVersionBuilder)? updates]) =>
      (GeoBoundaryCollectionPsgcVersionBuilder()..update(updates))._build();

  _$GeoBoundaryCollectionPsgcVersion._({required this.id, required this.label})
      : super._();
  @override
  GeoBoundaryCollectionPsgcVersion rebuild(
          void Function(GeoBoundaryCollectionPsgcVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoBoundaryCollectionPsgcVersionBuilder toBuilder() =>
      GeoBoundaryCollectionPsgcVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoBoundaryCollectionPsgcVersion &&
        id == other.id &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoBoundaryCollectionPsgcVersion')
          ..add('id', id)
          ..add('label', label))
        .toString();
  }
}

class GeoBoundaryCollectionPsgcVersionBuilder
    implements
        Builder<GeoBoundaryCollectionPsgcVersion,
            GeoBoundaryCollectionPsgcVersionBuilder> {
  _$GeoBoundaryCollectionPsgcVersion? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  GeoBoundaryCollectionPsgcVersionBuilder() {
    GeoBoundaryCollectionPsgcVersion._defaults(this);
  }

  GeoBoundaryCollectionPsgcVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoBoundaryCollectionPsgcVersion other) {
    _$v = other as _$GeoBoundaryCollectionPsgcVersion;
  }

  @override
  void update(void Function(GeoBoundaryCollectionPsgcVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoBoundaryCollectionPsgcVersion build() => _build();

  _$GeoBoundaryCollectionPsgcVersion _build() {
    final _$result = _$v ??
        _$GeoBoundaryCollectionPsgcVersion._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GeoBoundaryCollectionPsgcVersion', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'GeoBoundaryCollectionPsgcVersion', 'label'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
