// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_password_recovery_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WebPasswordRecoveryEnvelopeAllOfData
    extends WebPasswordRecoveryEnvelopeAllOfData {
  @override
  final bool verified;
  @override
  final int expiresIn;
  @override
  final BuiltList<String>? recoveryCodes;

  factory _$WebPasswordRecoveryEnvelopeAllOfData(
          [void Function(WebPasswordRecoveryEnvelopeAllOfDataBuilder)?
              updates]) =>
      (WebPasswordRecoveryEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$WebPasswordRecoveryEnvelopeAllOfData._(
      {required this.verified, required this.expiresIn, this.recoveryCodes})
      : super._();
  @override
  WebPasswordRecoveryEnvelopeAllOfData rebuild(
          void Function(WebPasswordRecoveryEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WebPasswordRecoveryEnvelopeAllOfDataBuilder toBuilder() =>
      WebPasswordRecoveryEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WebPasswordRecoveryEnvelopeAllOfData &&
        verified == other.verified &&
        expiresIn == other.expiresIn &&
        recoveryCodes == other.recoveryCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verified.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WebPasswordRecoveryEnvelopeAllOfData')
          ..add('verified', verified)
          ..add('expiresIn', expiresIn)
          ..add('recoveryCodes', recoveryCodes))
        .toString();
  }
}

class WebPasswordRecoveryEnvelopeAllOfDataBuilder
    implements
        Builder<WebPasswordRecoveryEnvelopeAllOfData,
            WebPasswordRecoveryEnvelopeAllOfDataBuilder> {
  _$WebPasswordRecoveryEnvelopeAllOfData? _$v;

  bool? _verified;
  bool? get verified => _$this._verified;
  set verified(bool? verified) => _$this._verified = verified;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  ListBuilder<String>? _recoveryCodes;
  ListBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= ListBuilder<String>();
  set recoveryCodes(ListBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  WebPasswordRecoveryEnvelopeAllOfDataBuilder() {
    WebPasswordRecoveryEnvelopeAllOfData._defaults(this);
  }

  WebPasswordRecoveryEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verified = $v.verified;
      _expiresIn = $v.expiresIn;
      _recoveryCodes = $v.recoveryCodes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WebPasswordRecoveryEnvelopeAllOfData other) {
    _$v = other as _$WebPasswordRecoveryEnvelopeAllOfData;
  }

  @override
  void update(
      void Function(WebPasswordRecoveryEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WebPasswordRecoveryEnvelopeAllOfData build() => _build();

  _$WebPasswordRecoveryEnvelopeAllOfData _build() {
    _$WebPasswordRecoveryEnvelopeAllOfData _$result;
    try {
      _$result = _$v ??
          _$WebPasswordRecoveryEnvelopeAllOfData._(
            verified: BuiltValueNullFieldError.checkNotNull(
                verified, r'WebPasswordRecoveryEnvelopeAllOfData', 'verified'),
            expiresIn: BuiltValueNullFieldError.checkNotNull(expiresIn,
                r'WebPasswordRecoveryEnvelopeAllOfData', 'expiresIn'),
            recoveryCodes: _recoveryCodes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recoveryCodes';
        _recoveryCodes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WebPasswordRecoveryEnvelopeAllOfData',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
