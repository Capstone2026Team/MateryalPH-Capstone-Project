// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_scope_psgc_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeoScopePsgcVersion extends GeoScopePsgcVersion {
  @override
  final String id;
  @override
  final String label;
  @override
  final String effectiveOn;

  factory _$GeoScopePsgcVersion(
          [void Function(GeoScopePsgcVersionBuilder)? updates]) =>
      (GeoScopePsgcVersionBuilder()..update(updates))._build();

  _$GeoScopePsgcVersion._(
      {required this.id, required this.label, required this.effectiveOn})
      : super._();
  @override
  GeoScopePsgcVersion rebuild(
          void Function(GeoScopePsgcVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoScopePsgcVersionBuilder toBuilder() =>
      GeoScopePsgcVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoScopePsgcVersion &&
        id == other.id &&
        label == other.label &&
        effectiveOn == other.effectiveOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, effectiveOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoScopePsgcVersion')
          ..add('id', id)
          ..add('label', label)
          ..add('effectiveOn', effectiveOn))
        .toString();
  }
}

class GeoScopePsgcVersionBuilder
    implements Builder<GeoScopePsgcVersion, GeoScopePsgcVersionBuilder> {
  _$GeoScopePsgcVersion? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _effectiveOn;
  String? get effectiveOn => _$this._effectiveOn;
  set effectiveOn(String? effectiveOn) => _$this._effectiveOn = effectiveOn;

  GeoScopePsgcVersionBuilder() {
    GeoScopePsgcVersion._defaults(this);
  }

  GeoScopePsgcVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _effectiveOn = $v.effectiveOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoScopePsgcVersion other) {
    _$v = other as _$GeoScopePsgcVersion;
  }

  @override
  void update(void Function(GeoScopePsgcVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoScopePsgcVersion build() => _build();

  _$GeoScopePsgcVersion _build() {
    final _$result = _$v ??
        _$GeoScopePsgcVersion._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'GeoScopePsgcVersion', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'GeoScopePsgcVersion', 'label'),
          effectiveOn: BuiltValueNullFieldError.checkNotNull(
              effectiveOn, r'GeoScopePsgcVersion', 'effectiveOn'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
