// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_webhook_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWebhookEnvelope extends VendorWebhookEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$VendorWebhookEnvelope(
          [void Function(VendorWebhookEnvelopeBuilder)? updates]) =>
      (VendorWebhookEnvelopeBuilder()..update(updates))._build();

  _$VendorWebhookEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  VendorWebhookEnvelope rebuild(
          void Function(VendorWebhookEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWebhookEnvelopeBuilder toBuilder() =>
      VendorWebhookEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWebhookEnvelope &&
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
    return (newBuiltValueToStringHelper(r'VendorWebhookEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class VendorWebhookEnvelopeBuilder
    implements Builder<VendorWebhookEnvelope, VendorWebhookEnvelopeBuilder> {
  _$VendorWebhookEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  VendorWebhookEnvelopeBuilder() {
    VendorWebhookEnvelope._defaults(this);
  }

  VendorWebhookEnvelopeBuilder get _$this {
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
  void replace(VendorWebhookEnvelope other) {
    _$v = other as _$VendorWebhookEnvelope;
  }

  @override
  void update(void Function(VendorWebhookEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWebhookEnvelope build() => _build();

  _$VendorWebhookEnvelope _build() {
    _$VendorWebhookEnvelope _$result;
    try {
      _$result = _$v ??
          _$VendorWebhookEnvelope._(
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
            r'VendorWebhookEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
