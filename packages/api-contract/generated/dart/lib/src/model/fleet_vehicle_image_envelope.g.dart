// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_image_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FleetVehicleImageEnvelope extends FleetVehicleImageEnvelope {
  @override
  final FleetVehicleImageEnvelopeData data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> errors;

  factory _$FleetVehicleImageEnvelope(
          [void Function(FleetVehicleImageEnvelopeBuilder)? updates]) =>
      (FleetVehicleImageEnvelopeBuilder()..update(updates))._build();

  _$FleetVehicleImageEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  FleetVehicleImageEnvelope rebuild(
          void Function(FleetVehicleImageEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleImageEnvelopeBuilder toBuilder() =>
      FleetVehicleImageEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleImageEnvelope &&
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
    return (newBuiltValueToStringHelper(r'FleetVehicleImageEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class FleetVehicleImageEnvelopeBuilder
    implements
        Builder<FleetVehicleImageEnvelope, FleetVehicleImageEnvelopeBuilder> {
  _$FleetVehicleImageEnvelope? _$v;

  FleetVehicleImageEnvelopeDataBuilder? _data;
  FleetVehicleImageEnvelopeDataBuilder get data =>
      _$this._data ??= FleetVehicleImageEnvelopeDataBuilder();
  set data(FleetVehicleImageEnvelopeDataBuilder? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BuiltMap<String, JsonObject?>>? _errors;
  ListBuilder<BuiltMap<String, JsonObject?>> get errors =>
      _$this._errors ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set errors(ListBuilder<BuiltMap<String, JsonObject?>>? errors) =>
      _$this._errors = errors;

  FleetVehicleImageEnvelopeBuilder() {
    FleetVehicleImageEnvelope._defaults(this);
  }

  FleetVehicleImageEnvelopeBuilder get _$this {
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
  void replace(FleetVehicleImageEnvelope other) {
    _$v = other as _$FleetVehicleImageEnvelope;
  }

  @override
  void update(void Function(FleetVehicleImageEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleImageEnvelope build() => _build();

  _$FleetVehicleImageEnvelope _build() {
    _$FleetVehicleImageEnvelope _$result;
    try {
      _$result = _$v ??
          _$FleetVehicleImageEnvelope._(
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
            r'FleetVehicleImageEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
