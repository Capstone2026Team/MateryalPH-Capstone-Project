// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lock_version_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LockVersionRequest extends LockVersionRequest {
  @override
  final int lockVersion;

  factory _$LockVersionRequest(
          [void Function(LockVersionRequestBuilder)? updates]) =>
      (LockVersionRequestBuilder()..update(updates))._build();

  _$LockVersionRequest._({required this.lockVersion}) : super._();
  @override
  LockVersionRequest rebuild(
          void Function(LockVersionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LockVersionRequestBuilder toBuilder() =>
      LockVersionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LockVersionRequest && lockVersion == other.lockVersion;
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
    return (newBuiltValueToStringHelper(r'LockVersionRequest')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class LockVersionRequestBuilder
    implements Builder<LockVersionRequest, LockVersionRequestBuilder> {
  _$LockVersionRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  LockVersionRequestBuilder() {
    LockVersionRequest._defaults(this);
  }

  LockVersionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LockVersionRequest other) {
    _$v = other as _$LockVersionRequest;
  }

  @override
  void update(void Function(LockVersionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LockVersionRequest build() => _build();

  _$LockVersionRequest _build() {
    final _$result = _$v ??
        _$LockVersionRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'LockVersionRequest', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
