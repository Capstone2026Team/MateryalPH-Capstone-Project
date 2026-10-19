// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_access_exchange.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportAccessExchange extends SupportAccessExchange {
  @override
  final String token;

  factory _$SupportAccessExchange(
          [void Function(SupportAccessExchangeBuilder)? updates]) =>
      (SupportAccessExchangeBuilder()..update(updates))._build();

  _$SupportAccessExchange._({required this.token}) : super._();
  @override
  SupportAccessExchange rebuild(
          void Function(SupportAccessExchangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportAccessExchangeBuilder toBuilder() =>
      SupportAccessExchangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportAccessExchange && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportAccessExchange')
          ..add('token', token))
        .toString();
  }
}

class SupportAccessExchangeBuilder
    implements Builder<SupportAccessExchange, SupportAccessExchangeBuilder> {
  _$SupportAccessExchange? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  SupportAccessExchangeBuilder() {
    SupportAccessExchange._defaults(this);
  }

  SupportAccessExchangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportAccessExchange other) {
    _$v = other as _$SupportAccessExchange;
  }

  @override
  void update(void Function(SupportAccessExchangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportAccessExchange build() => _build();

  _$SupportAccessExchange _build() {
    final _$result = _$v ??
        _$SupportAccessExchange._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'SupportAccessExchange', 'token'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
