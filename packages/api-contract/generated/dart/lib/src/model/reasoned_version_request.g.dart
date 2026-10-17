// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reasoned_version_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReasonedVersionRequest extends ReasonedVersionRequest {
  @override
  final int lockVersion;
  @override
  final String reason;

  factory _$ReasonedVersionRequest(
          [void Function(ReasonedVersionRequestBuilder)? updates]) =>
      (ReasonedVersionRequestBuilder()..update(updates))._build();

  _$ReasonedVersionRequest._({required this.lockVersion, required this.reason})
      : super._();
  @override
  ReasonedVersionRequest rebuild(
          void Function(ReasonedVersionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReasonedVersionRequestBuilder toBuilder() =>
      ReasonedVersionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReasonedVersionRequest &&
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
    return (newBuiltValueToStringHelper(r'ReasonedVersionRequest')
          ..add('lockVersion', lockVersion)
          ..add('reason', reason))
        .toString();
  }
}

class ReasonedVersionRequestBuilder
    implements Builder<ReasonedVersionRequest, ReasonedVersionRequestBuilder> {
  _$ReasonedVersionRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ReasonedVersionRequestBuilder() {
    ReasonedVersionRequest._defaults(this);
  }

  ReasonedVersionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReasonedVersionRequest other) {
    _$v = other as _$ReasonedVersionRequest;
  }

  @override
  void update(void Function(ReasonedVersionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReasonedVersionRequest build() => _build();

  _$ReasonedVersionRequest _build() {
    final _$result = _$v ??
        _$ReasonedVersionRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ReasonedVersionRequest', 'lockVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ReasonedVersionRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
