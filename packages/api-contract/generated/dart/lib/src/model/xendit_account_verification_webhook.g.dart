// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xendit_account_verification_webhook.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const XenditAccountVerificationWebhookEventEnum
    _$xenditAccountVerificationWebhookEventEnum_accountPeriodRegistered =
    const XenditAccountVerificationWebhookEventEnum._(
        'accountPeriodRegistered');
const XenditAccountVerificationWebhookEventEnum
    _$xenditAccountVerificationWebhookEventEnum_accountPeriodActivated =
    const XenditAccountVerificationWebhookEventEnum._('accountPeriodActivated');

XenditAccountVerificationWebhookEventEnum
    _$xenditAccountVerificationWebhookEventEnumValueOf(String name) {
  switch (name) {
    case 'accountPeriodRegistered':
      return _$xenditAccountVerificationWebhookEventEnum_accountPeriodRegistered;
    case 'accountPeriodActivated':
      return _$xenditAccountVerificationWebhookEventEnum_accountPeriodActivated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<XenditAccountVerificationWebhookEventEnum>
    _$xenditAccountVerificationWebhookEventEnumValues = BuiltSet<
        XenditAccountVerificationWebhookEventEnum>(const <XenditAccountVerificationWebhookEventEnum>[
  _$xenditAccountVerificationWebhookEventEnum_accountPeriodRegistered,
  _$xenditAccountVerificationWebhookEventEnum_accountPeriodActivated,
]);

Serializer<XenditAccountVerificationWebhookEventEnum>
    _$xenditAccountVerificationWebhookEventEnumSerializer =
    _$XenditAccountVerificationWebhookEventEnumSerializer();

class _$XenditAccountVerificationWebhookEventEnumSerializer
    implements PrimitiveSerializer<XenditAccountVerificationWebhookEventEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accountPeriodRegistered': 'account.registered',
    'accountPeriodActivated': 'account.activated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'account.registered': 'accountPeriodRegistered',
    'account.activated': 'accountPeriodActivated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    XenditAccountVerificationWebhookEventEnum
  ];
  @override
  final String wireName = 'XenditAccountVerificationWebhookEventEnum';

  @override
  Object serialize(Serializers serializers,
          XenditAccountVerificationWebhookEventEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  XenditAccountVerificationWebhookEventEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      XenditAccountVerificationWebhookEventEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$XenditAccountVerificationWebhook
    extends XenditAccountVerificationWebhook {
  @override
  final XenditAccountVerificationWebhookEventEnum event;
  @override
  final DateTime created;
  @override
  final XenditAccountVerificationWebhookData data;

  factory _$XenditAccountVerificationWebhook(
          [void Function(XenditAccountVerificationWebhookBuilder)? updates]) =>
      (XenditAccountVerificationWebhookBuilder()..update(updates))._build();

  _$XenditAccountVerificationWebhook._(
      {required this.event, required this.created, required this.data})
      : super._();
  @override
  XenditAccountVerificationWebhook rebuild(
          void Function(XenditAccountVerificationWebhookBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  XenditAccountVerificationWebhookBuilder toBuilder() =>
      XenditAccountVerificationWebhookBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is XenditAccountVerificationWebhook &&
        event == other.event &&
        created == other.created &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'XenditAccountVerificationWebhook')
          ..add('event', event)
          ..add('created', created)
          ..add('data', data))
        .toString();
  }
}

class XenditAccountVerificationWebhookBuilder
    implements
        Builder<XenditAccountVerificationWebhook,
            XenditAccountVerificationWebhookBuilder> {
  _$XenditAccountVerificationWebhook? _$v;

  XenditAccountVerificationWebhookEventEnum? _event;
  XenditAccountVerificationWebhookEventEnum? get event => _$this._event;
  set event(XenditAccountVerificationWebhookEventEnum? event) =>
      _$this._event = event;

  DateTime? _created;
  DateTime? get created => _$this._created;
  set created(DateTime? created) => _$this._created = created;

  XenditAccountVerificationWebhookDataBuilder? _data;
  XenditAccountVerificationWebhookDataBuilder get data =>
      _$this._data ??= XenditAccountVerificationWebhookDataBuilder();
  set data(XenditAccountVerificationWebhookDataBuilder? data) =>
      _$this._data = data;

  XenditAccountVerificationWebhookBuilder() {
    XenditAccountVerificationWebhook._defaults(this);
  }

  XenditAccountVerificationWebhookBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _event = $v.event;
      _created = $v.created;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(XenditAccountVerificationWebhook other) {
    _$v = other as _$XenditAccountVerificationWebhook;
  }

  @override
  void update(void Function(XenditAccountVerificationWebhookBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  XenditAccountVerificationWebhook build() => _build();

  _$XenditAccountVerificationWebhook _build() {
    _$XenditAccountVerificationWebhook _$result;
    try {
      _$result = _$v ??
          _$XenditAccountVerificationWebhook._(
            event: BuiltValueNullFieldError.checkNotNull(
                event, r'XenditAccountVerificationWebhook', 'event'),
            created: BuiltValueNullFieldError.checkNotNull(
                created, r'XenditAccountVerificationWebhook', 'created'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'XenditAccountVerificationWebhook', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
