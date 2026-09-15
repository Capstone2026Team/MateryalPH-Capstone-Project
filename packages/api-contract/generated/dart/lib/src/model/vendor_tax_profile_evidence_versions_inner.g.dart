// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_tax_profile_evidence_versions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTaxProfileEvidenceVersionsInner
    extends VendorTaxProfileEvidenceVersionsInner {
  @override
  final String id;
  @override
  final int version;

  factory _$VendorTaxProfileEvidenceVersionsInner(
          [void Function(VendorTaxProfileEvidenceVersionsInnerBuilder)?
              updates]) =>
      (VendorTaxProfileEvidenceVersionsInnerBuilder()..update(updates))
          ._build();

  _$VendorTaxProfileEvidenceVersionsInner._(
      {required this.id, required this.version})
      : super._();
  @override
  VendorTaxProfileEvidenceVersionsInner rebuild(
          void Function(VendorTaxProfileEvidenceVersionsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTaxProfileEvidenceVersionsInnerBuilder toBuilder() =>
      VendorTaxProfileEvidenceVersionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTaxProfileEvidenceVersionsInner &&
        id == other.id &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorTaxProfileEvidenceVersionsInner')
          ..add('id', id)
          ..add('version', version))
        .toString();
  }
}

class VendorTaxProfileEvidenceVersionsInnerBuilder
    implements
        Builder<VendorTaxProfileEvidenceVersionsInner,
            VendorTaxProfileEvidenceVersionsInnerBuilder> {
  _$VendorTaxProfileEvidenceVersionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  VendorTaxProfileEvidenceVersionsInnerBuilder() {
    VendorTaxProfileEvidenceVersionsInner._defaults(this);
  }

  VendorTaxProfileEvidenceVersionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTaxProfileEvidenceVersionsInner other) {
    _$v = other as _$VendorTaxProfileEvidenceVersionsInner;
  }

  @override
  void update(
      void Function(VendorTaxProfileEvidenceVersionsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTaxProfileEvidenceVersionsInner build() => _build();

  _$VendorTaxProfileEvidenceVersionsInner _build() {
    final _$result = _$v ??
        _$VendorTaxProfileEvidenceVersionsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'VendorTaxProfileEvidenceVersionsInner', 'id'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'VendorTaxProfileEvidenceVersionsInner', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
