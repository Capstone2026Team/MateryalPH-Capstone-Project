// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_variant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionVariant extends SiteInspectionVariant {
  @override
  final String id;
  @override
  final String? label;

  factory _$SiteInspectionVariant(
          [void Function(SiteInspectionVariantBuilder)? updates]) =>
      (SiteInspectionVariantBuilder()..update(updates))._build();

  _$SiteInspectionVariant._({required this.id, this.label}) : super._();
  @override
  SiteInspectionVariant rebuild(
          void Function(SiteInspectionVariantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionVariantBuilder toBuilder() =>
      SiteInspectionVariantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionVariant &&
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
    return (newBuiltValueToStringHelper(r'SiteInspectionVariant')
          ..add('id', id)
          ..add('label', label))
        .toString();
  }
}

class SiteInspectionVariantBuilder
    implements Builder<SiteInspectionVariant, SiteInspectionVariantBuilder> {
  _$SiteInspectionVariant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  SiteInspectionVariantBuilder() {
    SiteInspectionVariant._defaults(this);
  }

  SiteInspectionVariantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionVariant other) {
    _$v = other as _$SiteInspectionVariant;
  }

  @override
  void update(void Function(SiteInspectionVariantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionVariant build() => _build();

  _$SiteInspectionVariant _build() {
    final _$result = _$v ??
        _$SiteInspectionVariant._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SiteInspectionVariant', 'id'),
          label: label,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
