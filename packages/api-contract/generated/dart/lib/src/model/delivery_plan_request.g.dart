// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryPlanRequest extends DeliveryPlanRequest {
  @override
  final BuiltList<OrderLineQuantity>? lines;

  factory _$DeliveryPlanRequest(
          [void Function(DeliveryPlanRequestBuilder)? updates]) =>
      (DeliveryPlanRequestBuilder()..update(updates))._build();

  _$DeliveryPlanRequest._({this.lines}) : super._();
  @override
  DeliveryPlanRequest rebuild(
          void Function(DeliveryPlanRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanRequestBuilder toBuilder() =>
      DeliveryPlanRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanRequest && lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlanRequest')
          ..add('lines', lines))
        .toString();
  }
}

class DeliveryPlanRequestBuilder
    implements Builder<DeliveryPlanRequest, DeliveryPlanRequestBuilder> {
  _$DeliveryPlanRequest? _$v;

  ListBuilder<OrderLineQuantity>? _lines;
  ListBuilder<OrderLineQuantity> get lines =>
      _$this._lines ??= ListBuilder<OrderLineQuantity>();
  set lines(ListBuilder<OrderLineQuantity>? lines) => _$this._lines = lines;

  DeliveryPlanRequestBuilder() {
    DeliveryPlanRequest._defaults(this);
  }

  DeliveryPlanRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlanRequest other) {
    _$v = other as _$DeliveryPlanRequest;
  }

  @override
  void update(void Function(DeliveryPlanRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanRequest build() => _build();

  _$DeliveryPlanRequest _build() {
    _$DeliveryPlanRequest _$result;
    try {
      _$result = _$v ??
          _$DeliveryPlanRequest._(
            lines: _lines?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        _lines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeliveryPlanRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
