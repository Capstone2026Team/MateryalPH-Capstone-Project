// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_recovery_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PasswordRecoveryEnvelopeAllOfData
    extends PasswordRecoveryEnvelopeAllOfData {
  @override
  final String message;
  @override
  final int resendAfterSeconds;
  @override
  final int expiresIn;

  factory _$PasswordRecoveryEnvelopeAllOfData(
          [void Function(PasswordRecoveryEnvelopeAllOfDataBuilder)? updates]) =>
      (PasswordRecoveryEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$PasswordRecoveryEnvelopeAllOfData._(
      {required this.message,
      required this.resendAfterSeconds,
      required this.expiresIn})
      : super._();
  @override
  PasswordRecoveryEnvelopeAllOfData rebuild(
          void Function(PasswordRecoveryEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PasswordRecoveryEnvelopeAllOfDataBuilder toBuilder() =>
      PasswordRecoveryEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordRecoveryEnvelopeAllOfData &&
        message == other.message &&
        resendAfterSeconds == other.resendAfterSeconds &&
        expiresIn == other.expiresIn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, resendAfterSeconds.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PasswordRecoveryEnvelopeAllOfData')
          ..add('message', message)
          ..add('resendAfterSeconds', resendAfterSeconds)
          ..add('expiresIn', expiresIn))
        .toString();
  }
}

class PasswordRecoveryEnvelopeAllOfDataBuilder
    implements
        Builder<PasswordRecoveryEnvelopeAllOfData,
            PasswordRecoveryEnvelopeAllOfDataBuilder> {
  _$PasswordRecoveryEnvelopeAllOfData? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  int? _resendAfterSeconds;
  int? get resendAfterSeconds => _$this._resendAfterSeconds;
  set resendAfterSeconds(int? resendAfterSeconds) =>
      _$this._resendAfterSeconds = resendAfterSeconds;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  PasswordRecoveryEnvelopeAllOfDataBuilder() {
    PasswordRecoveryEnvelopeAllOfData._defaults(this);
  }

  PasswordRecoveryEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _resendAfterSeconds = $v.resendAfterSeconds;
      _expiresIn = $v.expiresIn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordRecoveryEnvelopeAllOfData other) {
    _$v = other as _$PasswordRecoveryEnvelopeAllOfData;
  }

  @override
  void update(
      void Function(PasswordRecoveryEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordRecoveryEnvelopeAllOfData build() => _build();

  _$PasswordRecoveryEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$PasswordRecoveryEnvelopeAllOfData._(
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'PasswordRecoveryEnvelopeAllOfData', 'message'),
          resendAfterSeconds: BuiltValueNullFieldError.checkNotNull(
              resendAfterSeconds,
              r'PasswordRecoveryEnvelopeAllOfData',
              'resendAfterSeconds'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'PasswordRecoveryEnvelopeAllOfData', 'expiresIn'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
