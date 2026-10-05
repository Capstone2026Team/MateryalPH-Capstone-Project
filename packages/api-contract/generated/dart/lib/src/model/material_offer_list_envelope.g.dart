// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_offer_list_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MaterialOfferListEnvelope extends MaterialOfferListEnvelope {
  @override
  final BuiltList<MaterialOffer> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$MaterialOfferListEnvelope(
          [void Function(MaterialOfferListEnvelopeBuilder)? updates]) =>
      (MaterialOfferListEnvelopeBuilder()..update(updates))._build();

  _$MaterialOfferListEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  MaterialOfferListEnvelope rebuild(
          void Function(MaterialOfferListEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MaterialOfferListEnvelopeBuilder toBuilder() =>
      MaterialOfferListEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MaterialOfferListEnvelope &&
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
    return (newBuiltValueToStringHelper(r'MaterialOfferListEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class MaterialOfferListEnvelopeBuilder
    implements
        Builder<MaterialOfferListEnvelope, MaterialOfferListEnvelopeBuilder> {
  _$MaterialOfferListEnvelope? _$v;

  ListBuilder<MaterialOffer>? _data;
  ListBuilder<MaterialOffer> get data =>
      _$this._data ??= ListBuilder<MaterialOffer>();
  set data(ListBuilder<MaterialOffer>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  MaterialOfferListEnvelopeBuilder() {
    MaterialOfferListEnvelope._defaults(this);
  }

  MaterialOfferListEnvelopeBuilder get _$this {
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
  void replace(MaterialOfferListEnvelope other) {
    _$v = other as _$MaterialOfferListEnvelope;
  }

  @override
  void update(void Function(MaterialOfferListEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MaterialOfferListEnvelope build() => _build();

  _$MaterialOfferListEnvelope _build() {
    _$MaterialOfferListEnvelope _$result;
    try {
      _$result = _$v ??
          _$MaterialOfferListEnvelope._(
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
            r'MaterialOfferListEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
