// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_thread_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentThreadRefReadOnlyReasonEnum
    _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_COMPLETED =
    const FulfillmentThreadRefReadOnlyReasonEnum._('ORDER_COMPLETED');
const FulfillmentThreadRefReadOnlyReasonEnum
    _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_CANCELLED =
    const FulfillmentThreadRefReadOnlyReasonEnum._('ORDER_CANCELLED');
const FulfillmentThreadRefReadOnlyReasonEnum
    _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT =
    const FulfillmentThreadRefReadOnlyReasonEnum._('ORDER_NOT_IN_FULFILLMENT');

FulfillmentThreadRefReadOnlyReasonEnum
    _$fulfillmentThreadRefReadOnlyReasonEnumValueOf(String name) {
  switch (name) {
    case 'ORDER_COMPLETED':
      return _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_COMPLETED;
    case 'ORDER_CANCELLED':
      return _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_CANCELLED;
    case 'ORDER_NOT_IN_FULFILLMENT':
      return _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentThreadRefReadOnlyReasonEnum>
    _$fulfillmentThreadRefReadOnlyReasonEnumValues = BuiltSet<
        FulfillmentThreadRefReadOnlyReasonEnum>(const <FulfillmentThreadRefReadOnlyReasonEnum>[
  _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_COMPLETED,
  _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_CANCELLED,
  _$fulfillmentThreadRefReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT,
]);

Serializer<FulfillmentThreadRefReadOnlyReasonEnum>
    _$fulfillmentThreadRefReadOnlyReasonEnumSerializer =
    _$FulfillmentThreadRefReadOnlyReasonEnumSerializer();

class _$FulfillmentThreadRefReadOnlyReasonEnumSerializer
    implements PrimitiveSerializer<FulfillmentThreadRefReadOnlyReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER_COMPLETED': 'ORDER_COMPLETED',
    'ORDER_CANCELLED': 'ORDER_CANCELLED',
    'ORDER_NOT_IN_FULFILLMENT': 'ORDER_NOT_IN_FULFILLMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER_COMPLETED': 'ORDER_COMPLETED',
    'ORDER_CANCELLED': 'ORDER_CANCELLED',
    'ORDER_NOT_IN_FULFILLMENT': 'ORDER_NOT_IN_FULFILLMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FulfillmentThreadRefReadOnlyReasonEnum
  ];
  @override
  final String wireName = 'FulfillmentThreadRefReadOnlyReasonEnum';

  @override
  Object serialize(Serializers serializers,
          FulfillmentThreadRefReadOnlyReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentThreadRefReadOnlyReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentThreadRefReadOnlyReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentThreadRef extends FulfillmentThreadRef {
  @override
  final bool available;
  @override
  final String? conversationId;
  @override
  final bool readOnly;
  @override
  final FulfillmentThreadRefReadOnlyReasonEnum? readOnlyReason;
  @override
  final String? notice;

  factory _$FulfillmentThreadRef(
          [void Function(FulfillmentThreadRefBuilder)? updates]) =>
      (FulfillmentThreadRefBuilder()..update(updates))._build();

  _$FulfillmentThreadRef._(
      {required this.available,
      this.conversationId,
      required this.readOnly,
      this.readOnlyReason,
      this.notice})
      : super._();
  @override
  FulfillmentThreadRef rebuild(
          void Function(FulfillmentThreadRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentThreadRefBuilder toBuilder() =>
      FulfillmentThreadRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentThreadRef &&
        available == other.available &&
        conversationId == other.conversationId &&
        readOnly == other.readOnly &&
        readOnlyReason == other.readOnlyReason &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jc(_$hash, readOnly.hashCode);
    _$hash = $jc(_$hash, readOnlyReason.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentThreadRef')
          ..add('available', available)
          ..add('conversationId', conversationId)
          ..add('readOnly', readOnly)
          ..add('readOnlyReason', readOnlyReason)
          ..add('notice', notice))
        .toString();
  }
}

class FulfillmentThreadRefBuilder
    implements Builder<FulfillmentThreadRef, FulfillmentThreadRefBuilder> {
  _$FulfillmentThreadRef? _$v;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  bool? _readOnly;
  bool? get readOnly => _$this._readOnly;
  set readOnly(bool? readOnly) => _$this._readOnly = readOnly;

  FulfillmentThreadRefReadOnlyReasonEnum? _readOnlyReason;
  FulfillmentThreadRefReadOnlyReasonEnum? get readOnlyReason =>
      _$this._readOnlyReason;
  set readOnlyReason(FulfillmentThreadRefReadOnlyReasonEnum? readOnlyReason) =>
      _$this._readOnlyReason = readOnlyReason;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  FulfillmentThreadRefBuilder() {
    FulfillmentThreadRef._defaults(this);
  }

  FulfillmentThreadRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _available = $v.available;
      _conversationId = $v.conversationId;
      _readOnly = $v.readOnly;
      _readOnlyReason = $v.readOnlyReason;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentThreadRef other) {
    _$v = other as _$FulfillmentThreadRef;
  }

  @override
  void update(void Function(FulfillmentThreadRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentThreadRef build() => _build();

  _$FulfillmentThreadRef _build() {
    final _$result = _$v ??
        _$FulfillmentThreadRef._(
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'FulfillmentThreadRef', 'available'),
          conversationId: conversationId,
          readOnly: BuiltValueNullFieldError.checkNotNull(
              readOnly, r'FulfillmentThreadRef', 'readOnly'),
          readOnlyReason: readOnlyReason,
          notice: notice,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
