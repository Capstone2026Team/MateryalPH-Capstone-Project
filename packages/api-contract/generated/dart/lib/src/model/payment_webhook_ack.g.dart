// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_webhook_ack.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentWebhookAck extends PaymentWebhookAck {
  @override
  final bool received;
  @override
  final bool duplicate;

  factory _$PaymentWebhookAck(
          [void Function(PaymentWebhookAckBuilder)? updates]) =>
      (PaymentWebhookAckBuilder()..update(updates))._build();

  _$PaymentWebhookAck._({required this.received, required this.duplicate})
      : super._();
  @override
  PaymentWebhookAck rebuild(void Function(PaymentWebhookAckBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentWebhookAckBuilder toBuilder() =>
      PaymentWebhookAckBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentWebhookAck &&
        received == other.received &&
        duplicate == other.duplicate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, duplicate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentWebhookAck')
          ..add('received', received)
          ..add('duplicate', duplicate))
        .toString();
  }
}

class PaymentWebhookAckBuilder
    implements Builder<PaymentWebhookAck, PaymentWebhookAckBuilder> {
  _$PaymentWebhookAck? _$v;

  bool? _received;
  bool? get received => _$this._received;
  set received(bool? received) => _$this._received = received;

  bool? _duplicate;
  bool? get duplicate => _$this._duplicate;
  set duplicate(bool? duplicate) => _$this._duplicate = duplicate;

  PaymentWebhookAckBuilder() {
    PaymentWebhookAck._defaults(this);
  }

  PaymentWebhookAckBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received;
      _duplicate = $v.duplicate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentWebhookAck other) {
    _$v = other as _$PaymentWebhookAck;
  }

  @override
  void update(void Function(PaymentWebhookAckBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentWebhookAck build() => _build();

  _$PaymentWebhookAck _build() {
    final _$result = _$v ??
        _$PaymentWebhookAck._(
          received: BuiltValueNullFieldError.checkNotNull(
              received, r'PaymentWebhookAck', 'received'),
          duplicate: BuiltValueNullFieldError.checkNotNull(
              duplicate, r'PaymentWebhookAck', 'duplicate'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
