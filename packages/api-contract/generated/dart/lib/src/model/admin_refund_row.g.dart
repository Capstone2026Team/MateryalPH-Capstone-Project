// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_refund_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRefundRowTargetTypeEnum _$adminRefundRowTargetTypeEnum_ORDER =
    const AdminRefundRowTargetTypeEnum._('ORDER');
const AdminRefundRowTargetTypeEnum _$adminRefundRowTargetTypeEnum_PLATFORM_FEE =
    const AdminRefundRowTargetTypeEnum._('PLATFORM_FEE');

AdminRefundRowTargetTypeEnum _$adminRefundRowTargetTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'ORDER':
      return _$adminRefundRowTargetTypeEnum_ORDER;
    case 'PLATFORM_FEE':
      return _$adminRefundRowTargetTypeEnum_PLATFORM_FEE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRefundRowTargetTypeEnum>
    _$adminRefundRowTargetTypeEnumValues =
    BuiltSet<AdminRefundRowTargetTypeEnum>(const <AdminRefundRowTargetTypeEnum>[
  _$adminRefundRowTargetTypeEnum_ORDER,
  _$adminRefundRowTargetTypeEnum_PLATFORM_FEE,
]);

const AdminRefundRowTriggerEnum _$adminRefundRowTriggerEnum_CANCELLATION =
    const AdminRefundRowTriggerEnum._('CANCELLATION');
const AdminRefundRowTriggerEnum _$adminRefundRowTriggerEnum_DISPUTE_CONCLUSION =
    const AdminRefundRowTriggerEnum._('DISPUTE_CONCLUSION');
const AdminRefundRowTriggerEnum
    _$adminRefundRowTriggerEnum_TECHNICAL_COMPENSATION =
    const AdminRefundRowTriggerEnum._('TECHNICAL_COMPENSATION');
const AdminRefundRowTriggerEnum _$adminRefundRowTriggerEnum_FEE_CREDIT =
    const AdminRefundRowTriggerEnum._('FEE_CREDIT');

AdminRefundRowTriggerEnum _$adminRefundRowTriggerEnumValueOf(String name) {
  switch (name) {
    case 'CANCELLATION':
      return _$adminRefundRowTriggerEnum_CANCELLATION;
    case 'DISPUTE_CONCLUSION':
      return _$adminRefundRowTriggerEnum_DISPUTE_CONCLUSION;
    case 'TECHNICAL_COMPENSATION':
      return _$adminRefundRowTriggerEnum_TECHNICAL_COMPENSATION;
    case 'FEE_CREDIT':
      return _$adminRefundRowTriggerEnum_FEE_CREDIT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRefundRowTriggerEnum> _$adminRefundRowTriggerEnumValues =
    BuiltSet<AdminRefundRowTriggerEnum>(const <AdminRefundRowTriggerEnum>[
  _$adminRefundRowTriggerEnum_CANCELLATION,
  _$adminRefundRowTriggerEnum_DISPUTE_CONCLUSION,
  _$adminRefundRowTriggerEnum_TECHNICAL_COMPENSATION,
  _$adminRefundRowTriggerEnum_FEE_CREDIT,
]);

const AdminRefundRowStateEnum _$adminRefundRowStateEnum_REFUND_PENDING =
    const AdminRefundRowStateEnum._('REFUND_PENDING');
const AdminRefundRowStateEnum _$adminRefundRowStateEnum_REFUNDED =
    const AdminRefundRowStateEnum._('REFUNDED');
const AdminRefundRowStateEnum _$adminRefundRowStateEnum_REFUND_FAILED =
    const AdminRefundRowStateEnum._('REFUND_FAILED');

AdminRefundRowStateEnum _$adminRefundRowStateEnumValueOf(String name) {
  switch (name) {
    case 'REFUND_PENDING':
      return _$adminRefundRowStateEnum_REFUND_PENDING;
    case 'REFUNDED':
      return _$adminRefundRowStateEnum_REFUNDED;
    case 'REFUND_FAILED':
      return _$adminRefundRowStateEnum_REFUND_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRefundRowStateEnum> _$adminRefundRowStateEnumValues =
    BuiltSet<AdminRefundRowStateEnum>(const <AdminRefundRowStateEnum>[
  _$adminRefundRowStateEnum_REFUND_PENDING,
  _$adminRefundRowStateEnum_REFUNDED,
  _$adminRefundRowStateEnum_REFUND_FAILED,
]);

const AdminRefundRowDisplayStateEnum _$adminRefundRowDisplayStateEnum_QUEUED =
    const AdminRefundRowDisplayStateEnum._('QUEUED');
const AdminRefundRowDisplayStateEnum
    _$adminRefundRowDisplayStateEnum_INITIATED =
    const AdminRefundRowDisplayStateEnum._('INITIATED');
const AdminRefundRowDisplayStateEnum
    _$adminRefundRowDisplayStateEnum_PROCESSED =
    const AdminRefundRowDisplayStateEnum._('PROCESSED');
const AdminRefundRowDisplayStateEnum _$adminRefundRowDisplayStateEnum_FAILED =
    const AdminRefundRowDisplayStateEnum._('FAILED');

AdminRefundRowDisplayStateEnum _$adminRefundRowDisplayStateEnumValueOf(
    String name) {
  switch (name) {
    case 'QUEUED':
      return _$adminRefundRowDisplayStateEnum_QUEUED;
    case 'INITIATED':
      return _$adminRefundRowDisplayStateEnum_INITIATED;
    case 'PROCESSED':
      return _$adminRefundRowDisplayStateEnum_PROCESSED;
    case 'FAILED':
      return _$adminRefundRowDisplayStateEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRefundRowDisplayStateEnum>
    _$adminRefundRowDisplayStateEnumValues = BuiltSet<
        AdminRefundRowDisplayStateEnum>(const <AdminRefundRowDisplayStateEnum>[
  _$adminRefundRowDisplayStateEnum_QUEUED,
  _$adminRefundRowDisplayStateEnum_INITIATED,
  _$adminRefundRowDisplayStateEnum_PROCESSED,
  _$adminRefundRowDisplayStateEnum_FAILED,
]);

Serializer<AdminRefundRowTargetTypeEnum>
    _$adminRefundRowTargetTypeEnumSerializer =
    _$AdminRefundRowTargetTypeEnumSerializer();
Serializer<AdminRefundRowTriggerEnum> _$adminRefundRowTriggerEnumSerializer =
    _$AdminRefundRowTriggerEnumSerializer();
Serializer<AdminRefundRowStateEnum> _$adminRefundRowStateEnumSerializer =
    _$AdminRefundRowStateEnumSerializer();
Serializer<AdminRefundRowDisplayStateEnum>
    _$adminRefundRowDisplayStateEnumSerializer =
    _$AdminRefundRowDisplayStateEnumSerializer();

class _$AdminRefundRowTargetTypeEnumSerializer
    implements PrimitiveSerializer<AdminRefundRowTargetTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER': 'ORDER',
    'PLATFORM_FEE': 'PLATFORM_FEE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER': 'ORDER',
    'PLATFORM_FEE': 'PLATFORM_FEE',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminRefundRowTargetTypeEnum];
  @override
  final String wireName = 'AdminRefundRowTargetTypeEnum';

  @override
  Object serialize(Serializers serializers, AdminRefundRowTargetTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRefundRowTargetTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRefundRowTargetTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRefundRowTriggerEnumSerializer
    implements PrimitiveSerializer<AdminRefundRowTriggerEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CANCELLATION': 'CANCELLATION',
    'DISPUTE_CONCLUSION': 'DISPUTE_CONCLUSION',
    'TECHNICAL_COMPENSATION': 'TECHNICAL_COMPENSATION',
    'FEE_CREDIT': 'FEE_CREDIT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CANCELLATION': 'CANCELLATION',
    'DISPUTE_CONCLUSION': 'DISPUTE_CONCLUSION',
    'TECHNICAL_COMPENSATION': 'TECHNICAL_COMPENSATION',
    'FEE_CREDIT': 'FEE_CREDIT',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminRefundRowTriggerEnum];
  @override
  final String wireName = 'AdminRefundRowTriggerEnum';

  @override
  Object serialize(Serializers serializers, AdminRefundRowTriggerEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRefundRowTriggerEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRefundRowTriggerEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRefundRowStateEnumSerializer
    implements PrimitiveSerializer<AdminRefundRowStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REFUND_PENDING': 'REFUND_PENDING',
    'REFUNDED': 'REFUNDED',
    'REFUND_FAILED': 'REFUND_FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REFUND_PENDING': 'REFUND_PENDING',
    'REFUNDED': 'REFUNDED',
    'REFUND_FAILED': 'REFUND_FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminRefundRowStateEnum];
  @override
  final String wireName = 'AdminRefundRowStateEnum';

  @override
  Object serialize(Serializers serializers, AdminRefundRowStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRefundRowStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRefundRowStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRefundRowDisplayStateEnumSerializer
    implements PrimitiveSerializer<AdminRefundRowDisplayStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'QUEUED': 'QUEUED',
    'INITIATED': 'INITIATED',
    'PROCESSED': 'PROCESSED',
    'FAILED': 'FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'QUEUED': 'QUEUED',
    'INITIATED': 'INITIATED',
    'PROCESSED': 'PROCESSED',
    'FAILED': 'FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminRefundRowDisplayStateEnum];
  @override
  final String wireName = 'AdminRefundRowDisplayStateEnum';

  @override
  Object serialize(
          Serializers serializers, AdminRefundRowDisplayStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminRefundRowDisplayStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminRefundRowDisplayStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminRefundRow extends AdminRefundRow {
  @override
  final String id;
  @override
  final AdminRefundRowTargetTypeEnum targetType;
  @override
  final AdminRefundRowTriggerEnum trigger;
  @override
  final AdminRefundRowStateEnum state;
  @override
  final AdminRefundRowDisplayStateEnum displayState;
  @override
  final int amountCentavos;
  @override
  final int attemptNumber;
  @override
  final String? failureCode;
  @override
  final String? evidenceOrigin;
  @override
  final String? orderId;
  @override
  final String? orderReference;
  @override
  final String? statementReference;
  @override
  final String? vendorName;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime? completedAt;
  @override
  final bool canRetry;

  factory _$AdminRefundRow([void Function(AdminRefundRowBuilder)? updates]) =>
      (AdminRefundRowBuilder()..update(updates))._build();

  _$AdminRefundRow._(
      {required this.id,
      required this.targetType,
      required this.trigger,
      required this.state,
      required this.displayState,
      required this.amountCentavos,
      required this.attemptNumber,
      this.failureCode,
      this.evidenceOrigin,
      this.orderId,
      this.orderReference,
      this.statementReference,
      this.vendorName,
      this.requestedAt,
      this.completedAt,
      required this.canRetry})
      : super._();
  @override
  AdminRefundRow rebuild(void Function(AdminRefundRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminRefundRowBuilder toBuilder() => AdminRefundRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRefundRow &&
        id == other.id &&
        targetType == other.targetType &&
        trigger == other.trigger &&
        state == other.state &&
        displayState == other.displayState &&
        amountCentavos == other.amountCentavos &&
        attemptNumber == other.attemptNumber &&
        failureCode == other.failureCode &&
        evidenceOrigin == other.evidenceOrigin &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        statementReference == other.statementReference &&
        vendorName == other.vendorName &&
        requestedAt == other.requestedAt &&
        completedAt == other.completedAt &&
        canRetry == other.canRetry;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, trigger.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, displayState.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, attemptNumber.hashCode);
    _$hash = $jc(_$hash, failureCode.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, statementReference.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, canRetry.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRefundRow')
          ..add('id', id)
          ..add('targetType', targetType)
          ..add('trigger', trigger)
          ..add('state', state)
          ..add('displayState', displayState)
          ..add('amountCentavos', amountCentavos)
          ..add('attemptNumber', attemptNumber)
          ..add('failureCode', failureCode)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('statementReference', statementReference)
          ..add('vendorName', vendorName)
          ..add('requestedAt', requestedAt)
          ..add('completedAt', completedAt)
          ..add('canRetry', canRetry))
        .toString();
  }
}

class AdminRefundRowBuilder
    implements Builder<AdminRefundRow, AdminRefundRowBuilder> {
  _$AdminRefundRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminRefundRowTargetTypeEnum? _targetType;
  AdminRefundRowTargetTypeEnum? get targetType => _$this._targetType;
  set targetType(AdminRefundRowTargetTypeEnum? targetType) =>
      _$this._targetType = targetType;

  AdminRefundRowTriggerEnum? _trigger;
  AdminRefundRowTriggerEnum? get trigger => _$this._trigger;
  set trigger(AdminRefundRowTriggerEnum? trigger) => _$this._trigger = trigger;

  AdminRefundRowStateEnum? _state;
  AdminRefundRowStateEnum? get state => _$this._state;
  set state(AdminRefundRowStateEnum? state) => _$this._state = state;

  AdminRefundRowDisplayStateEnum? _displayState;
  AdminRefundRowDisplayStateEnum? get displayState => _$this._displayState;
  set displayState(AdminRefundRowDisplayStateEnum? displayState) =>
      _$this._displayState = displayState;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _attemptNumber;
  int? get attemptNumber => _$this._attemptNumber;
  set attemptNumber(int? attemptNumber) =>
      _$this._attemptNumber = attemptNumber;

  String? _failureCode;
  String? get failureCode => _$this._failureCode;
  set failureCode(String? failureCode) => _$this._failureCode = failureCode;

  String? _evidenceOrigin;
  String? get evidenceOrigin => _$this._evidenceOrigin;
  set evidenceOrigin(String? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _statementReference;
  String? get statementReference => _$this._statementReference;
  set statementReference(String? statementReference) =>
      _$this._statementReference = statementReference;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  bool? _canRetry;
  bool? get canRetry => _$this._canRetry;
  set canRetry(bool? canRetry) => _$this._canRetry = canRetry;

  AdminRefundRowBuilder() {
    AdminRefundRow._defaults(this);
  }

  AdminRefundRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _targetType = $v.targetType;
      _trigger = $v.trigger;
      _state = $v.state;
      _displayState = $v.displayState;
      _amountCentavos = $v.amountCentavos;
      _attemptNumber = $v.attemptNumber;
      _failureCode = $v.failureCode;
      _evidenceOrigin = $v.evidenceOrigin;
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _statementReference = $v.statementReference;
      _vendorName = $v.vendorName;
      _requestedAt = $v.requestedAt;
      _completedAt = $v.completedAt;
      _canRetry = $v.canRetry;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRefundRow other) {
    _$v = other as _$AdminRefundRow;
  }

  @override
  void update(void Function(AdminRefundRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRefundRow build() => _build();

  _$AdminRefundRow _build() {
    final _$result = _$v ??
        _$AdminRefundRow._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminRefundRow', 'id'),
          targetType: BuiltValueNullFieldError.checkNotNull(
              targetType, r'AdminRefundRow', 'targetType'),
          trigger: BuiltValueNullFieldError.checkNotNull(
              trigger, r'AdminRefundRow', 'trigger'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'AdminRefundRow', 'state'),
          displayState: BuiltValueNullFieldError.checkNotNull(
              displayState, r'AdminRefundRow', 'displayState'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'AdminRefundRow', 'amountCentavos'),
          attemptNumber: BuiltValueNullFieldError.checkNotNull(
              attemptNumber, r'AdminRefundRow', 'attemptNumber'),
          failureCode: failureCode,
          evidenceOrigin: evidenceOrigin,
          orderId: orderId,
          orderReference: orderReference,
          statementReference: statementReference,
          vendorName: vendorName,
          requestedAt: requestedAt,
          completedAt: completedAt,
          canRetry: BuiltValueNullFieldError.checkNotNull(
              canRetry, r'AdminRefundRow', 'canRetry'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
