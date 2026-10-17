// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_two_factor_enrollment_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerTwoFactorEnrollmentEnvelope
    extends BuyerTwoFactorEnrollmentEnvelope {
  @override
  final BuyerTwoFactorEnrollment data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerTwoFactorEnrollmentEnvelope(
          [void Function(BuyerTwoFactorEnrollmentEnvelopeBuilder)? updates]) =>
      (BuyerTwoFactorEnrollmentEnvelopeBuilder()..update(updates))._build();

  _$BuyerTwoFactorEnrollmentEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerTwoFactorEnrollmentEnvelope rebuild(
          void Function(BuyerTwoFactorEnrollmentEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerTwoFactorEnrollmentEnvelopeBuilder toBuilder() =>
      BuyerTwoFactorEnrollmentEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerTwoFactorEnrollmentEnvelope &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerTwoFactorEnrollmentEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerTwoFactorEnrollmentEnvelopeBuilder
    implements
        Builder<BuyerTwoFactorEnrollmentEnvelope,
            BuyerTwoFactorEnrollmentEnvelopeBuilder> {
  _$BuyerTwoFactorEnrollmentEnvelope? _$v;

  BuyerTwoFactorEnrollmentBuilder? _data;
  BuyerTwoFactorEnrollmentBuilder get data =>
      _$this._data ??= BuyerTwoFactorEnrollmentBuilder();
  set data(BuyerTwoFactorEnrollmentBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerTwoFactorEnrollmentEnvelopeBuilder() {
    BuyerTwoFactorEnrollmentEnvelope._defaults(this);
  }

  BuyerTwoFactorEnrollmentEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerTwoFactorEnrollmentEnvelope other) {
    _$v = other as _$BuyerTwoFactorEnrollmentEnvelope;
  }

  @override
  void update(void Function(BuyerTwoFactorEnrollmentEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerTwoFactorEnrollmentEnvelope build() => _build();

  _$BuyerTwoFactorEnrollmentEnvelope _build() {
    _$BuyerTwoFactorEnrollmentEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerTwoFactorEnrollmentEnvelope._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerTwoFactorEnrollmentEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
