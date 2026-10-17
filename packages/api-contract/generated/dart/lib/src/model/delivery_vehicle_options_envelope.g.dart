// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_vehicle_options_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryVehicleOptionsEnvelope extends DeliveryVehicleOptionsEnvelope {
  @override
  final BuiltList<DeliveryVehicleOption> data;

  factory _$DeliveryVehicleOptionsEnvelope(
          [void Function(DeliveryVehicleOptionsEnvelopeBuilder)? updates]) =>
      (DeliveryVehicleOptionsEnvelopeBuilder()..update(updates))._build();

  _$DeliveryVehicleOptionsEnvelope._({required this.data}) : super._();
  @override
  DeliveryVehicleOptionsEnvelope rebuild(
          void Function(DeliveryVehicleOptionsEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryVehicleOptionsEnvelopeBuilder toBuilder() =>
      DeliveryVehicleOptionsEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryVehicleOptionsEnvelope && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryVehicleOptionsEnvelope')
          ..add('data', data))
        .toString();
  }
}

class DeliveryVehicleOptionsEnvelopeBuilder
    implements
        Builder<DeliveryVehicleOptionsEnvelope,
            DeliveryVehicleOptionsEnvelopeBuilder> {
  _$DeliveryVehicleOptionsEnvelope? _$v;

  ListBuilder<DeliveryVehicleOption>? _data;
  ListBuilder<DeliveryVehicleOption> get data =>
      _$this._data ??= ListBuilder<DeliveryVehicleOption>();
  set data(ListBuilder<DeliveryVehicleOption>? data) => _$this._data = data;

  DeliveryVehicleOptionsEnvelopeBuilder() {
    DeliveryVehicleOptionsEnvelope._defaults(this);
  }

  DeliveryVehicleOptionsEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryVehicleOptionsEnvelope other) {
    _$v = other as _$DeliveryVehicleOptionsEnvelope;
  }

  @override
  void update(void Function(DeliveryVehicleOptionsEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryVehicleOptionsEnvelope build() => _build();

  _$DeliveryVehicleOptionsEnvelope _build() {
    _$DeliveryVehicleOptionsEnvelope _$result;
    try {
      _$result = _$v ??
          _$DeliveryVehicleOptionsEnvelope._(
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryVehicleOptionsEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
