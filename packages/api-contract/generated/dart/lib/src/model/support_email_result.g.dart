// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_email_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportEmailResult extends SupportEmailResult {
  @override
  final String message;

  factory _$SupportEmailResult(
          [void Function(SupportEmailResultBuilder)? updates]) =>
      (SupportEmailResultBuilder()..update(updates))._build();

  _$SupportEmailResult._({required this.message}) : super._();
  @override
  SupportEmailResult rebuild(
          void Function(SupportEmailResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportEmailResultBuilder toBuilder() =>
      SupportEmailResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportEmailResult && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportEmailResult')
          ..add('message', message))
        .toString();
  }
}

class SupportEmailResultBuilder
    implements Builder<SupportEmailResult, SupportEmailResultBuilder> {
  _$SupportEmailResult? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  SupportEmailResultBuilder() {
    SupportEmailResult._defaults(this);
  }

  SupportEmailResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportEmailResult other) {
    _$v = other as _$SupportEmailResult;
  }

  @override
  void update(void Function(SupportEmailResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportEmailResult build() => _build();

  _$SupportEmailResult _build() {
    final _$result = _$v ??
        _$SupportEmailResult._(
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'SupportEmailResult', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
