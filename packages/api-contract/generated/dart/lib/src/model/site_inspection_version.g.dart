// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_inspection_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteInspectionVersion extends SiteInspectionVersion {
  @override
  final int lockVersion;

  factory _$SiteInspectionVersion(
          [void Function(SiteInspectionVersionBuilder)? updates]) =>
      (SiteInspectionVersionBuilder()..update(updates))._build();

  _$SiteInspectionVersion._({required this.lockVersion}) : super._();
  @override
  SiteInspectionVersion rebuild(
          void Function(SiteInspectionVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteInspectionVersionBuilder toBuilder() =>
      SiteInspectionVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteInspectionVersion && lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteInspectionVersion')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class SiteInspectionVersionBuilder
    implements Builder<SiteInspectionVersion, SiteInspectionVersionBuilder> {
  _$SiteInspectionVersion? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  SiteInspectionVersionBuilder() {
    SiteInspectionVersion._defaults(this);
  }

  SiteInspectionVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteInspectionVersion other) {
    _$v = other as _$SiteInspectionVersion;
  }

  @override
  void update(void Function(SiteInspectionVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteInspectionVersion build() => _build();

  _$SiteInspectionVersion _build() {
    final _$result = _$v ??
        _$SiteInspectionVersion._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'SiteInspectionVersion', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
