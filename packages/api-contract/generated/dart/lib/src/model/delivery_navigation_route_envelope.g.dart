// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_navigation_route_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryNavigationRouteEnvelope
    extends DeliveryNavigationRouteEnvelope {
  @override
  final DeliveryNavigationRoute data;

  factory _$DeliveryNavigationRouteEnvelope(
          [void Function(DeliveryNavigationRouteEnvelopeBuilder)? updates]) =>
      (DeliveryNavigationRouteEnvelopeBuilder()..update(updates))._build();

  _$DeliveryNavigationRouteEnvelope._({required this.data}) : super._();
  @override
  DeliveryNavigationRouteEnvelope rebuild(
          void Function(DeliveryNavigationRouteEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryNavigationRouteEnvelopeBuilder toBuilder() =>
      DeliveryNavigationRouteEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryNavigationRouteEnvelope && data == other.data;
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
    return (newBuiltValueToStringHelper(r'DeliveryNavigationRouteEnvelope')
          ..add('data', data))
        .toString();
  }
}

class DeliveryNavigationRouteEnvelopeBuilder
    implements
        Builder<DeliveryNavigationRouteEnvelope,
            DeliveryNavigationRouteEnvelopeBuilder> {
  _$DeliveryNavigationRouteEnvelope? _$v;

  DeliveryNavigationRouteBuilder? _data;
  DeliveryNavigationRouteBuilder get data =>
      _$this._data ??= DeliveryNavigationRouteBuilder();
  set data(DeliveryNavigationRouteBuilder? data) => _$this._data = data;

  DeliveryNavigationRouteEnvelopeBuilder() {
    DeliveryNavigationRouteEnvelope._defaults(this);
  }

  DeliveryNavigationRouteEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryNavigationRouteEnvelope other) {
    _$v = other as _$DeliveryNavigationRouteEnvelope;
  }

  @override
  void update(void Function(DeliveryNavigationRouteEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryNavigationRouteEnvelope build() => _build();

  _$DeliveryNavigationRouteEnvelope _build() {
    _$DeliveryNavigationRouteEnvelope _$result;
    try {
      _$result = _$v ??
          _$DeliveryNavigationRouteEnvelope._(
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryNavigationRouteEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
