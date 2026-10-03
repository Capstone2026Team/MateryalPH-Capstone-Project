// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryPlanEnvelope extends DeliveryPlanEnvelope {
  @override
  final DeliveryPlan data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$DeliveryPlanEnvelope(
          [void Function(DeliveryPlanEnvelopeBuilder)? updates]) =>
      (DeliveryPlanEnvelopeBuilder()..update(updates))._build();

  _$DeliveryPlanEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  DeliveryPlanEnvelope rebuild(
          void Function(DeliveryPlanEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanEnvelopeBuilder toBuilder() =>
      DeliveryPlanEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanEnvelope &&
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
    return (newBuiltValueToStringHelper(r'DeliveryPlanEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class DeliveryPlanEnvelopeBuilder
    implements Builder<DeliveryPlanEnvelope, DeliveryPlanEnvelopeBuilder> {
  _$DeliveryPlanEnvelope? _$v;

  DeliveryPlanBuilder? _data;
  DeliveryPlanBuilder get data => _$this._data ??= DeliveryPlanBuilder();
  set data(DeliveryPlanBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  DeliveryPlanEnvelopeBuilder() {
    DeliveryPlanEnvelope._defaults(this);
  }

  DeliveryPlanEnvelopeBuilder get _$this {
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
  void replace(DeliveryPlanEnvelope other) {
    _$v = other as _$DeliveryPlanEnvelope;
  }

  @override
  void update(void Function(DeliveryPlanEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanEnvelope build() => _build();

  _$DeliveryPlanEnvelope _build() {
    _$DeliveryPlanEnvelope _$result;
    try {
      _$result = _$v ??
          _$DeliveryPlanEnvelope._(
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
            r'DeliveryPlanEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
