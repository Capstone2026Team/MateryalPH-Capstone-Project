// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_approve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatementApproveRequest extends StatementApproveRequest {
  @override
  final int lockVersion;

  factory _$StatementApproveRequest(
          [void Function(StatementApproveRequestBuilder)? updates]) =>
      (StatementApproveRequestBuilder()..update(updates))._build();

  _$StatementApproveRequest._({required this.lockVersion}) : super._();
  @override
  StatementApproveRequest rebuild(
          void Function(StatementApproveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatementApproveRequestBuilder toBuilder() =>
      StatementApproveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatementApproveRequest && lockVersion == other.lockVersion;
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
    return (newBuiltValueToStringHelper(r'StatementApproveRequest')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class StatementApproveRequestBuilder
    implements
        Builder<StatementApproveRequest, StatementApproveRequestBuilder> {
  _$StatementApproveRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  StatementApproveRequestBuilder() {
    StatementApproveRequest._defaults(this);
  }

  StatementApproveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatementApproveRequest other) {
    _$v = other as _$StatementApproveRequest;
  }

  @override
  void update(void Function(StatementApproveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatementApproveRequest build() => _build();

  _$StatementApproveRequest _build() {
    final _$result = _$v ??
        _$StatementApproveRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'StatementApproveRequest', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
