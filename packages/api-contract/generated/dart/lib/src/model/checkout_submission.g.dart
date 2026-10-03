// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_submission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutSubmissionDerivedStatusEnum
    _$checkoutSubmissionDerivedStatusEnum_EMPTY =
    const CheckoutSubmissionDerivedStatusEnum._('EMPTY');
const CheckoutSubmissionDerivedStatusEnum
    _$checkoutSubmissionDerivedStatusEnum_AWAITING_CONFIRMATIONS =
    const CheckoutSubmissionDerivedStatusEnum._('AWAITING_CONFIRMATIONS');
const CheckoutSubmissionDerivedStatusEnum
    _$checkoutSubmissionDerivedStatusEnum_AWAITING_PAYMENT =
    const CheckoutSubmissionDerivedStatusEnum._('AWAITING_PAYMENT');
const CheckoutSubmissionDerivedStatusEnum
    _$checkoutSubmissionDerivedStatusEnum_CHILD_ORDERS_UPDATED =
    const CheckoutSubmissionDerivedStatusEnum._('CHILD_ORDERS_UPDATED');

CheckoutSubmissionDerivedStatusEnum
    _$checkoutSubmissionDerivedStatusEnumValueOf(String name) {
  switch (name) {
    case 'EMPTY':
      return _$checkoutSubmissionDerivedStatusEnum_EMPTY;
    case 'AWAITING_CONFIRMATIONS':
      return _$checkoutSubmissionDerivedStatusEnum_AWAITING_CONFIRMATIONS;
    case 'AWAITING_PAYMENT':
      return _$checkoutSubmissionDerivedStatusEnum_AWAITING_PAYMENT;
    case 'CHILD_ORDERS_UPDATED':
      return _$checkoutSubmissionDerivedStatusEnum_CHILD_ORDERS_UPDATED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutSubmissionDerivedStatusEnum>
    _$checkoutSubmissionDerivedStatusEnumValues = BuiltSet<
        CheckoutSubmissionDerivedStatusEnum>(const <CheckoutSubmissionDerivedStatusEnum>[
  _$checkoutSubmissionDerivedStatusEnum_EMPTY,
  _$checkoutSubmissionDerivedStatusEnum_AWAITING_CONFIRMATIONS,
  _$checkoutSubmissionDerivedStatusEnum_AWAITING_PAYMENT,
  _$checkoutSubmissionDerivedStatusEnum_CHILD_ORDERS_UPDATED,
]);

Serializer<CheckoutSubmissionDerivedStatusEnum>
    _$checkoutSubmissionDerivedStatusEnumSerializer =
    _$CheckoutSubmissionDerivedStatusEnumSerializer();

class _$CheckoutSubmissionDerivedStatusEnumSerializer
    implements PrimitiveSerializer<CheckoutSubmissionDerivedStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EMPTY': 'EMPTY',
    'AWAITING_CONFIRMATIONS': 'AWAITING_CONFIRMATIONS',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'CHILD_ORDERS_UPDATED': 'CHILD_ORDERS_UPDATED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EMPTY': 'EMPTY',
    'AWAITING_CONFIRMATIONS': 'AWAITING_CONFIRMATIONS',
    'AWAITING_PAYMENT': 'AWAITING_PAYMENT',
    'CHILD_ORDERS_UPDATED': 'CHILD_ORDERS_UPDATED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CheckoutSubmissionDerivedStatusEnum
  ];
  @override
  final String wireName = 'CheckoutSubmissionDerivedStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CheckoutSubmissionDerivedStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutSubmissionDerivedStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutSubmissionDerivedStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutSubmission extends CheckoutSubmission {
  @override
  final String id;
  @override
  final String reference;
  @override
  final DateTime submittedAt;
  @override
  final CheckoutSubmissionDerivedStatusEnum derivedStatus;
  @override
  final BuiltList<CheckoutChildOrder> orders;
  @override
  final String notice;

  factory _$CheckoutSubmission(
          [void Function(CheckoutSubmissionBuilder)? updates]) =>
      (CheckoutSubmissionBuilder()..update(updates))._build();

  _$CheckoutSubmission._(
      {required this.id,
      required this.reference,
      required this.submittedAt,
      required this.derivedStatus,
      required this.orders,
      required this.notice})
      : super._();
  @override
  CheckoutSubmission rebuild(
          void Function(CheckoutSubmissionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutSubmissionBuilder toBuilder() =>
      CheckoutSubmissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutSubmission &&
        id == other.id &&
        reference == other.reference &&
        submittedAt == other.submittedAt &&
        derivedStatus == other.derivedStatus &&
        orders == other.orders &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, derivedStatus.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutSubmission')
          ..add('id', id)
          ..add('reference', reference)
          ..add('submittedAt', submittedAt)
          ..add('derivedStatus', derivedStatus)
          ..add('orders', orders)
          ..add('notice', notice))
        .toString();
  }
}

class CheckoutSubmissionBuilder
    implements Builder<CheckoutSubmission, CheckoutSubmissionBuilder> {
  _$CheckoutSubmission? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  CheckoutSubmissionDerivedStatusEnum? _derivedStatus;
  CheckoutSubmissionDerivedStatusEnum? get derivedStatus =>
      _$this._derivedStatus;
  set derivedStatus(CheckoutSubmissionDerivedStatusEnum? derivedStatus) =>
      _$this._derivedStatus = derivedStatus;

  ListBuilder<CheckoutChildOrder>? _orders;
  ListBuilder<CheckoutChildOrder> get orders =>
      _$this._orders ??= ListBuilder<CheckoutChildOrder>();
  set orders(ListBuilder<CheckoutChildOrder>? orders) =>
      _$this._orders = orders;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  CheckoutSubmissionBuilder() {
    CheckoutSubmission._defaults(this);
  }

  CheckoutSubmissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _submittedAt = $v.submittedAt;
      _derivedStatus = $v.derivedStatus;
      _orders = $v.orders.toBuilder();
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutSubmission other) {
    _$v = other as _$CheckoutSubmission;
  }

  @override
  void update(void Function(CheckoutSubmissionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutSubmission build() => _build();

  _$CheckoutSubmission _build() {
    _$CheckoutSubmission _$result;
    try {
      _$result = _$v ??
          _$CheckoutSubmission._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CheckoutSubmission', 'id'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, r'CheckoutSubmission', 'reference'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt, r'CheckoutSubmission', 'submittedAt'),
            derivedStatus: BuiltValueNullFieldError.checkNotNull(
                derivedStatus, r'CheckoutSubmission', 'derivedStatus'),
            orders: orders.build(),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'CheckoutSubmission', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutSubmission', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
