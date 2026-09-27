// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_deactivation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogDeactivation extends CatalogDeactivation {
  @override
  final int lockVersion;
  @override
  final String? reason;

  factory _$CatalogDeactivation(
          [void Function(CatalogDeactivationBuilder)? updates]) =>
      (CatalogDeactivationBuilder()..update(updates))._build();

  _$CatalogDeactivation._({required this.lockVersion, this.reason}) : super._();
  @override
  CatalogDeactivation rebuild(
          void Function(CatalogDeactivationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogDeactivationBuilder toBuilder() =>
      CatalogDeactivationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogDeactivation &&
        lockVersion == other.lockVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogDeactivation')
          ..add('lockVersion', lockVersion)
          ..add('reason', reason))
        .toString();
  }
}

class CatalogDeactivationBuilder
    implements Builder<CatalogDeactivation, CatalogDeactivationBuilder> {
  _$CatalogDeactivation? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CatalogDeactivationBuilder() {
    CatalogDeactivation._defaults(this);
  }

  CatalogDeactivationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogDeactivation other) {
    _$v = other as _$CatalogDeactivation;
  }

  @override
  void update(void Function(CatalogDeactivationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogDeactivation build() => _build();

  _$CatalogDeactivation _build() {
    final _$result = _$v ??
        _$CatalogDeactivation._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CatalogDeactivation', 'lockVersion'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
