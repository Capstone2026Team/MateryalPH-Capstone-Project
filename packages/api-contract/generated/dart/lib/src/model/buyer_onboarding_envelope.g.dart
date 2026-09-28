// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_onboarding_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerOnboardingEnvelope extends BuyerOnboardingEnvelope {
  @override
  final BuyerOnboarding data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$BuyerOnboardingEnvelope(
          [void Function(BuyerOnboardingEnvelopeBuilder)? updates]) =>
      (BuyerOnboardingEnvelopeBuilder()..update(updates))._build();

  _$BuyerOnboardingEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  BuyerOnboardingEnvelope rebuild(
          void Function(BuyerOnboardingEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOnboardingEnvelopeBuilder toBuilder() =>
      BuyerOnboardingEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOnboardingEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BuyerOnboardingEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BuyerOnboardingEnvelopeBuilder
    implements
        Builder<BuyerOnboardingEnvelope, BuyerOnboardingEnvelopeBuilder> {
  _$BuyerOnboardingEnvelope? _$v;

  BuyerOnboardingBuilder? _data;
  BuyerOnboardingBuilder get data => _$this._data ??= BuyerOnboardingBuilder();
  set data(BuyerOnboardingBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  BuyerOnboardingEnvelopeBuilder() {
    BuyerOnboardingEnvelope._defaults(this);
  }

  BuyerOnboardingEnvelopeBuilder get _$this {
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
  void replace(BuyerOnboardingEnvelope other) {
    _$v = other as _$BuyerOnboardingEnvelope;
  }

  @override
  void update(void Function(BuyerOnboardingEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOnboardingEnvelope build() => _build();

  _$BuyerOnboardingEnvelope _build() {
    _$BuyerOnboardingEnvelope _$result;
    try {
      _$result = _$v ??
          _$BuyerOnboardingEnvelope._(
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
            r'BuyerOnboardingEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
