// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_preview_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryPreviewEnvelope extends DeliveryPreviewEnvelope {
  @override
  final DeliveryPreview data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$DeliveryPreviewEnvelope(
          [void Function(DeliveryPreviewEnvelopeBuilder)? updates]) =>
      (DeliveryPreviewEnvelopeBuilder()..update(updates))._build();

  _$DeliveryPreviewEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DeliveryPreviewEnvelope rebuild(
          void Function(DeliveryPreviewEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPreviewEnvelopeBuilder toBuilder() =>
      DeliveryPreviewEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPreviewEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DeliveryPreviewEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DeliveryPreviewEnvelopeBuilder
    implements
        Builder<DeliveryPreviewEnvelope, DeliveryPreviewEnvelopeBuilder> {
  _$DeliveryPreviewEnvelope? _$v;

  DeliveryPreviewBuilder? _data;
  DeliveryPreviewBuilder get data => _$this._data ??= DeliveryPreviewBuilder();
  set data(DeliveryPreviewBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  DeliveryPreviewEnvelopeBuilder() {
    DeliveryPreviewEnvelope._defaults(this);
  }

  DeliveryPreviewEnvelopeBuilder get _$this {
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
  void replace(DeliveryPreviewEnvelope other) {
    _$v = other as _$DeliveryPreviewEnvelope;
  }

  @override
  void update(void Function(DeliveryPreviewEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPreviewEnvelope build() => _build();

  _$DeliveryPreviewEnvelope _build() {
    _$DeliveryPreviewEnvelope _$result;
    try {
      _$result = _$v ??
          _$DeliveryPreviewEnvelope._(
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
            r'DeliveryPreviewEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
