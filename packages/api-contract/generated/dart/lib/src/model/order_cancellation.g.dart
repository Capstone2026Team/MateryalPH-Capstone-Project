// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_cancellation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderCancellationModeEnum _$orderCancellationModeEnum_WITHDRAW =
    const OrderCancellationModeEnum._('WITHDRAW');
const OrderCancellationModeEnum _$orderCancellationModeEnum_USE_REJECT =
    const OrderCancellationModeEnum._('USE_REJECT');
const OrderCancellationModeEnum
    _$orderCancellationModeEnum_CANCEL_BEFORE_PAYMENT =
    const OrderCancellationModeEnum._('CANCEL_BEFORE_PAYMENT');
const OrderCancellationModeEnum _$orderCancellationModeEnum_CANCEL_NOW =
    const OrderCancellationModeEnum._('CANCEL_NOW');
const OrderCancellationModeEnum _$orderCancellationModeEnum_REQUEST =
    const OrderCancellationModeEnum._('REQUEST');
const OrderCancellationModeEnum _$orderCancellationModeEnum_REQUEST_OPEN =
    const OrderCancellationModeEnum._('REQUEST_OPEN');
const OrderCancellationModeEnum _$orderCancellationModeEnum_UNAVAILABLE =
    const OrderCancellationModeEnum._('UNAVAILABLE');
const OrderCancellationModeEnum _$orderCancellationModeEnum_CLOSED =
    const OrderCancellationModeEnum._('CLOSED');

OrderCancellationModeEnum _$orderCancellationModeEnumValueOf(String name) {
  switch (name) {
    case 'WITHDRAW':
      return _$orderCancellationModeEnum_WITHDRAW;
    case 'USE_REJECT':
      return _$orderCancellationModeEnum_USE_REJECT;
    case 'CANCEL_BEFORE_PAYMENT':
      return _$orderCancellationModeEnum_CANCEL_BEFORE_PAYMENT;
    case 'CANCEL_NOW':
      return _$orderCancellationModeEnum_CANCEL_NOW;
    case 'REQUEST':
      return _$orderCancellationModeEnum_REQUEST;
    case 'REQUEST_OPEN':
      return _$orderCancellationModeEnum_REQUEST_OPEN;
    case 'UNAVAILABLE':
      return _$orderCancellationModeEnum_UNAVAILABLE;
    case 'CLOSED':
      return _$orderCancellationModeEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderCancellationModeEnum> _$orderCancellationModeEnumValues =
    BuiltSet<OrderCancellationModeEnum>(const <OrderCancellationModeEnum>[
  _$orderCancellationModeEnum_WITHDRAW,
  _$orderCancellationModeEnum_USE_REJECT,
  _$orderCancellationModeEnum_CANCEL_BEFORE_PAYMENT,
  _$orderCancellationModeEnum_CANCEL_NOW,
  _$orderCancellationModeEnum_REQUEST,
  _$orderCancellationModeEnum_REQUEST_OPEN,
  _$orderCancellationModeEnum_UNAVAILABLE,
  _$orderCancellationModeEnum_CLOSED,
]);

Serializer<OrderCancellationModeEnum> _$orderCancellationModeEnumSerializer =
    _$OrderCancellationModeEnumSerializer();

class _$OrderCancellationModeEnumSerializer
    implements PrimitiveSerializer<OrderCancellationModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WITHDRAW': 'WITHDRAW',
    'USE_REJECT': 'USE_REJECT',
    'CANCEL_BEFORE_PAYMENT': 'CANCEL_BEFORE_PAYMENT',
    'CANCEL_NOW': 'CANCEL_NOW',
    'REQUEST': 'REQUEST',
    'REQUEST_OPEN': 'REQUEST_OPEN',
    'UNAVAILABLE': 'UNAVAILABLE',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WITHDRAW': 'WITHDRAW',
    'USE_REJECT': 'USE_REJECT',
    'CANCEL_BEFORE_PAYMENT': 'CANCEL_BEFORE_PAYMENT',
    'CANCEL_NOW': 'CANCEL_NOW',
    'REQUEST': 'REQUEST',
    'REQUEST_OPEN': 'REQUEST_OPEN',
    'UNAVAILABLE': 'UNAVAILABLE',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderCancellationModeEnum];
  @override
  final String wireName = 'OrderCancellationModeEnum';

  @override
  Object serialize(Serializers serializers, OrderCancellationModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderCancellationModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderCancellationModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderCancellation extends OrderCancellation {
  @override
  final OrderCancellationModeEnum? mode;
  @override
  final bool? available;
  @override
  final String explanation;
  @override
  final bool? requiresReason;
  @override
  final BuiltList<String>? reasonCodes;
  @override
  final int? nrpcRetainableCentavos;
  @override
  final bool? canWithdrawRequest;
  @override
  final DateTime? responseDueAt;
  @override
  final BuiltList<CancellationRemedy>? remedies;
  @override
  final VendorCancellationRequestRef? openRequest;

  factory _$OrderCancellation(
          [void Function(OrderCancellationBuilder)? updates]) =>
      (OrderCancellationBuilder()..update(updates))._build();

  _$OrderCancellation._(
      {this.mode,
      this.available,
      required this.explanation,
      this.requiresReason,
      this.reasonCodes,
      this.nrpcRetainableCentavos,
      this.canWithdrawRequest,
      this.responseDueAt,
      this.remedies,
      this.openRequest})
      : super._();
  @override
  OrderCancellation rebuild(void Function(OrderCancellationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderCancellationBuilder toBuilder() =>
      OrderCancellationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderCancellation &&
        mode == other.mode &&
        available == other.available &&
        explanation == other.explanation &&
        requiresReason == other.requiresReason &&
        reasonCodes == other.reasonCodes &&
        nrpcRetainableCentavos == other.nrpcRetainableCentavos &&
        canWithdrawRequest == other.canWithdrawRequest &&
        responseDueAt == other.responseDueAt &&
        remedies == other.remedies &&
        openRequest == other.openRequest;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, explanation.hashCode);
    _$hash = $jc(_$hash, requiresReason.hashCode);
    _$hash = $jc(_$hash, reasonCodes.hashCode);
    _$hash = $jc(_$hash, nrpcRetainableCentavos.hashCode);
    _$hash = $jc(_$hash, canWithdrawRequest.hashCode);
    _$hash = $jc(_$hash, responseDueAt.hashCode);
    _$hash = $jc(_$hash, remedies.hashCode);
    _$hash = $jc(_$hash, openRequest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderCancellation')
          ..add('mode', mode)
          ..add('available', available)
          ..add('explanation', explanation)
          ..add('requiresReason', requiresReason)
          ..add('reasonCodes', reasonCodes)
          ..add('nrpcRetainableCentavos', nrpcRetainableCentavos)
          ..add('canWithdrawRequest', canWithdrawRequest)
          ..add('responseDueAt', responseDueAt)
          ..add('remedies', remedies)
          ..add('openRequest', openRequest))
        .toString();
  }
}

class OrderCancellationBuilder
    implements Builder<OrderCancellation, OrderCancellationBuilder> {
  _$OrderCancellation? _$v;

  OrderCancellationModeEnum? _mode;
  OrderCancellationModeEnum? get mode => _$this._mode;
  set mode(OrderCancellationModeEnum? mode) => _$this._mode = mode;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _explanation;
  String? get explanation => _$this._explanation;
  set explanation(String? explanation) => _$this._explanation = explanation;

  bool? _requiresReason;
  bool? get requiresReason => _$this._requiresReason;
  set requiresReason(bool? requiresReason) =>
      _$this._requiresReason = requiresReason;

  ListBuilder<String>? _reasonCodes;
  ListBuilder<String> get reasonCodes =>
      _$this._reasonCodes ??= ListBuilder<String>();
  set reasonCodes(ListBuilder<String>? reasonCodes) =>
      _$this._reasonCodes = reasonCodes;

  int? _nrpcRetainableCentavos;
  int? get nrpcRetainableCentavos => _$this._nrpcRetainableCentavos;
  set nrpcRetainableCentavos(int? nrpcRetainableCentavos) =>
      _$this._nrpcRetainableCentavos = nrpcRetainableCentavos;

  bool? _canWithdrawRequest;
  bool? get canWithdrawRequest => _$this._canWithdrawRequest;
  set canWithdrawRequest(bool? canWithdrawRequest) =>
      _$this._canWithdrawRequest = canWithdrawRequest;

  DateTime? _responseDueAt;
  DateTime? get responseDueAt => _$this._responseDueAt;
  set responseDueAt(DateTime? responseDueAt) =>
      _$this._responseDueAt = responseDueAt;

  ListBuilder<CancellationRemedy>? _remedies;
  ListBuilder<CancellationRemedy> get remedies =>
      _$this._remedies ??= ListBuilder<CancellationRemedy>();
  set remedies(ListBuilder<CancellationRemedy>? remedies) =>
      _$this._remedies = remedies;

  VendorCancellationRequestRefBuilder? _openRequest;
  VendorCancellationRequestRefBuilder get openRequest =>
      _$this._openRequest ??= VendorCancellationRequestRefBuilder();
  set openRequest(VendorCancellationRequestRefBuilder? openRequest) =>
      _$this._openRequest = openRequest;

  OrderCancellationBuilder() {
    OrderCancellation._defaults(this);
  }

  OrderCancellationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _available = $v.available;
      _explanation = $v.explanation;
      _requiresReason = $v.requiresReason;
      _reasonCodes = $v.reasonCodes?.toBuilder();
      _nrpcRetainableCentavos = $v.nrpcRetainableCentavos;
      _canWithdrawRequest = $v.canWithdrawRequest;
      _responseDueAt = $v.responseDueAt;
      _remedies = $v.remedies?.toBuilder();
      _openRequest = $v.openRequest?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderCancellation other) {
    _$v = other as _$OrderCancellation;
  }

  @override
  void update(void Function(OrderCancellationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderCancellation build() => _build();

  _$OrderCancellation _build() {
    _$OrderCancellation _$result;
    try {
      _$result = _$v ??
          _$OrderCancellation._(
            mode: mode,
            available: available,
            explanation: BuiltValueNullFieldError.checkNotNull(
                explanation, r'OrderCancellation', 'explanation'),
            requiresReason: requiresReason,
            reasonCodes: _reasonCodes?.build(),
            nrpcRetainableCentavos: nrpcRetainableCentavos,
            canWithdrawRequest: canWithdrawRequest,
            responseDueAt: responseDueAt,
            remedies: _remedies?.build(),
            openRequest: _openRequest?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasonCodes';
        _reasonCodes?.build();

        _$failedField = 'remedies';
        _remedies?.build();
        _$failedField = 'openRequest';
        _openRequest?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderCancellation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
