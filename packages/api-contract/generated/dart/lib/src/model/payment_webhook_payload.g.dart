// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_webhook_payload.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentWebhookPayload extends PaymentWebhookPayload {
  @override
  final String event;
  @override
  final String? businessId;
  @override
  final String? created;
  @override
  final BuiltMap<String, JsonObject?> data;

  factory _$PaymentWebhookPayload(
          [void Function(PaymentWebhookPayloadBuilder)? updates]) =>
      (PaymentWebhookPayloadBuilder()..update(updates))._build();

  _$PaymentWebhookPayload._(
      {required this.event, this.businessId, this.created, required this.data})
      : super._();
  @override
  PaymentWebhookPayload rebuild(
          void Function(PaymentWebhookPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentWebhookPayloadBuilder toBuilder() =>
      PaymentWebhookPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentWebhookPayload &&
        event == other.event &&
        businessId == other.businessId &&
        created == other.created &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, businessId.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentWebhookPayload')
          ..add('event', event)
          ..add('businessId', businessId)
          ..add('created', created)
          ..add('data', data))
        .toString();
  }
}

class PaymentWebhookPayloadBuilder
    implements Builder<PaymentWebhookPayload, PaymentWebhookPayloadBuilder> {
  _$PaymentWebhookPayload? _$v;

  String? _event;
  String? get event => _$this._event;
  set event(String? event) => _$this._event = event;

  String? _businessId;
  String? get businessId => _$this._businessId;
  set businessId(String? businessId) => _$this._businessId = businessId;

  String? _created;
  String? get created => _$this._created;
  set created(String? created) => _$this._created = created;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  PaymentWebhookPayloadBuilder() {
    PaymentWebhookPayload._defaults(this);
  }

  PaymentWebhookPayloadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _event = $v.event;
      _businessId = $v.businessId;
      _created = $v.created;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentWebhookPayload other) {
    _$v = other as _$PaymentWebhookPayload;
  }

  @override
  void update(void Function(PaymentWebhookPayloadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentWebhookPayload build() => _build();

  _$PaymentWebhookPayload _build() {
    _$PaymentWebhookPayload _$result;
    try {
      _$result = _$v ??
          _$PaymentWebhookPayload._(
            event: BuiltValueNullFieldError.checkNotNull(
                event, r'PaymentWebhookPayload', 'event'),
            businessId: businessId,
            created: created,
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentWebhookPayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
