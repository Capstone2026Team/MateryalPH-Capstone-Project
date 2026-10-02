// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlap_resolve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OverlapResolveRequest extends OverlapResolveRequest {
  @override
  final int overlapCentavos;
  @override
  final int lockVersion;
  @override
  final String reason;

  factory _$OverlapResolveRequest(
          [void Function(OverlapResolveRequestBuilder)? updates]) =>
      (OverlapResolveRequestBuilder()..update(updates))._build();

  _$OverlapResolveRequest._(
      {required this.overlapCentavos,
      required this.lockVersion,
      required this.reason})
      : super._();
  @override
  OverlapResolveRequest rebuild(
          void Function(OverlapResolveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OverlapResolveRequestBuilder toBuilder() =>
      OverlapResolveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OverlapResolveRequest &&
        overlapCentavos == other.overlapCentavos &&
        lockVersion == other.lockVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, overlapCentavos.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OverlapResolveRequest')
          ..add('overlapCentavos', overlapCentavos)
          ..add('lockVersion', lockVersion)
          ..add('reason', reason))
        .toString();
  }
}

class OverlapResolveRequestBuilder
    implements Builder<OverlapResolveRequest, OverlapResolveRequestBuilder> {
  _$OverlapResolveRequest? _$v;

  int? _overlapCentavos;
  int? get overlapCentavos => _$this._overlapCentavos;
  set overlapCentavos(int? overlapCentavos) =>
      _$this._overlapCentavos = overlapCentavos;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  OverlapResolveRequestBuilder() {
    OverlapResolveRequest._defaults(this);
  }

  OverlapResolveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _overlapCentavos = $v.overlapCentavos;
      _lockVersion = $v.lockVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OverlapResolveRequest other) {
    _$v = other as _$OverlapResolveRequest;
  }

  @override
  void update(void Function(OverlapResolveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OverlapResolveRequest build() => _build();

  _$OverlapResolveRequest _build() {
    final _$result = _$v ??
        _$OverlapResolveRequest._(
          overlapCentavos: BuiltValueNullFieldError.checkNotNull(
              overlapCentavos, r'OverlapResolveRequest', 'overlapCentavos'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'OverlapResolveRequest', 'lockVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'OverlapResolveRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
