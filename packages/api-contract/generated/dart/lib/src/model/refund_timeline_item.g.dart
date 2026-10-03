// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_timeline_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RefundTimelineItemTriggerEnum
    _$refundTimelineItemTriggerEnum_CANCELLATION =
    const RefundTimelineItemTriggerEnum._('CANCELLATION');
const RefundTimelineItemTriggerEnum
    _$refundTimelineItemTriggerEnum_DISPUTE_CONCLUSION =
    const RefundTimelineItemTriggerEnum._('DISPUTE_CONCLUSION');
const RefundTimelineItemTriggerEnum
    _$refundTimelineItemTriggerEnum_TECHNICAL_COMPENSATION =
    const RefundTimelineItemTriggerEnum._('TECHNICAL_COMPENSATION');
const RefundTimelineItemTriggerEnum _$refundTimelineItemTriggerEnum_FEE_CREDIT =
    const RefundTimelineItemTriggerEnum._('FEE_CREDIT');

RefundTimelineItemTriggerEnum _$refundTimelineItemTriggerEnumValueOf(
    String name) {
  switch (name) {
    case 'CANCELLATION':
      return _$refundTimelineItemTriggerEnum_CANCELLATION;
    case 'DISPUTE_CONCLUSION':
      return _$refundTimelineItemTriggerEnum_DISPUTE_CONCLUSION;
    case 'TECHNICAL_COMPENSATION':
      return _$refundTimelineItemTriggerEnum_TECHNICAL_COMPENSATION;
    case 'FEE_CREDIT':
      return _$refundTimelineItemTriggerEnum_FEE_CREDIT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RefundTimelineItemTriggerEnum>
    _$refundTimelineItemTriggerEnumValues = BuiltSet<
        RefundTimelineItemTriggerEnum>(const <RefundTimelineItemTriggerEnum>[
  _$refundTimelineItemTriggerEnum_CANCELLATION,
  _$refundTimelineItemTriggerEnum_DISPUTE_CONCLUSION,
  _$refundTimelineItemTriggerEnum_TECHNICAL_COMPENSATION,
  _$refundTimelineItemTriggerEnum_FEE_CREDIT,
]);

const RefundTimelineItemStateEnum _$refundTimelineItemStateEnum_REFUND_PENDING =
    const RefundTimelineItemStateEnum._('REFUND_PENDING');
const RefundTimelineItemStateEnum _$refundTimelineItemStateEnum_REFUNDED =
    const RefundTimelineItemStateEnum._('REFUNDED');
const RefundTimelineItemStateEnum _$refundTimelineItemStateEnum_REFUND_FAILED =
    const RefundTimelineItemStateEnum._('REFUND_FAILED');

RefundTimelineItemStateEnum _$refundTimelineItemStateEnumValueOf(String name) {
  switch (name) {
    case 'REFUND_PENDING':
      return _$refundTimelineItemStateEnum_REFUND_PENDING;
    case 'REFUNDED':
      return _$refundTimelineItemStateEnum_REFUNDED;
    case 'REFUND_FAILED':
      return _$refundTimelineItemStateEnum_REFUND_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RefundTimelineItemStateEnum>
    _$refundTimelineItemStateEnumValues =
    BuiltSet<RefundTimelineItemStateEnum>(const <RefundTimelineItemStateEnum>[
  _$refundTimelineItemStateEnum_REFUND_PENDING,
  _$refundTimelineItemStateEnum_REFUNDED,
  _$refundTimelineItemStateEnum_REFUND_FAILED,
]);

const RefundTimelineItemDisplayStateEnum
    _$refundTimelineItemDisplayStateEnum_QUEUED =
    const RefundTimelineItemDisplayStateEnum._('QUEUED');
const RefundTimelineItemDisplayStateEnum
    _$refundTimelineItemDisplayStateEnum_INITIATED =
    const RefundTimelineItemDisplayStateEnum._('INITIATED');
const RefundTimelineItemDisplayStateEnum
    _$refundTimelineItemDisplayStateEnum_PROCESSED =
    const RefundTimelineItemDisplayStateEnum._('PROCESSED');
const RefundTimelineItemDisplayStateEnum
    _$refundTimelineItemDisplayStateEnum_FAILED =
    const RefundTimelineItemDisplayStateEnum._('FAILED');

RefundTimelineItemDisplayStateEnum _$refundTimelineItemDisplayStateEnumValueOf(
    String name) {
  switch (name) {
    case 'QUEUED':
      return _$refundTimelineItemDisplayStateEnum_QUEUED;
    case 'INITIATED':
      return _$refundTimelineItemDisplayStateEnum_INITIATED;
    case 'PROCESSED':
      return _$refundTimelineItemDisplayStateEnum_PROCESSED;
    case 'FAILED':
      return _$refundTimelineItemDisplayStateEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RefundTimelineItemDisplayStateEnum>
    _$refundTimelineItemDisplayStateEnumValues = BuiltSet<
        RefundTimelineItemDisplayStateEnum>(const <RefundTimelineItemDisplayStateEnum>[
  _$refundTimelineItemDisplayStateEnum_QUEUED,
  _$refundTimelineItemDisplayStateEnum_INITIATED,
  _$refundTimelineItemDisplayStateEnum_PROCESSED,
  _$refundTimelineItemDisplayStateEnum_FAILED,
]);

Serializer<RefundTimelineItemTriggerEnum>
    _$refundTimelineItemTriggerEnumSerializer =
    _$RefundTimelineItemTriggerEnumSerializer();
Serializer<RefundTimelineItemStateEnum>
    _$refundTimelineItemStateEnumSerializer =
    _$RefundTimelineItemStateEnumSerializer();
Serializer<RefundTimelineItemDisplayStateEnum>
    _$refundTimelineItemDisplayStateEnumSerializer =
    _$RefundTimelineItemDisplayStateEnumSerializer();

class _$RefundTimelineItemTriggerEnumSerializer
    implements PrimitiveSerializer<RefundTimelineItemTriggerEnum> {
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
  final Iterable<Type> types = const <Type>[RefundTimelineItemTriggerEnum];
  @override
  final String wireName = 'RefundTimelineItemTriggerEnum';

  @override
  Object serialize(
          Serializers serializers, RefundTimelineItemTriggerEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RefundTimelineItemTriggerEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RefundTimelineItemTriggerEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RefundTimelineItemStateEnumSerializer
    implements PrimitiveSerializer<RefundTimelineItemStateEnum> {
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
  final Iterable<Type> types = const <Type>[RefundTimelineItemStateEnum];
  @override
  final String wireName = 'RefundTimelineItemStateEnum';

  @override
  Object serialize(Serializers serializers, RefundTimelineItemStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RefundTimelineItemStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RefundTimelineItemStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RefundTimelineItemDisplayStateEnumSerializer
    implements PrimitiveSerializer<RefundTimelineItemDisplayStateEnum> {
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
  final Iterable<Type> types = const <Type>[RefundTimelineItemDisplayStateEnum];
  @override
  final String wireName = 'RefundTimelineItemDisplayStateEnum';

  @override
  Object serialize(
          Serializers serializers, RefundTimelineItemDisplayStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RefundTimelineItemDisplayStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RefundTimelineItemDisplayStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RefundTimelineItem extends RefundTimelineItem {
  @override
  final String id;
  @override
  final RefundTimelineItemTriggerEnum trigger;
  @override
  final RefundTimelineItemStateEnum state;
  @override
  final RefundTimelineItemDisplayStateEnum displayState;
  @override
  final int amountCentavos;
  @override
  final int? principalCentavos;
  @override
  final int processingFeeCentavos;
  @override
  final String paymentPurpose;
  @override
  final String originalMethod;
  @override
  final int attemptNumber;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? failureCode;
  @override
  final String? evidenceOrigin;
  @override
  final bool canRetry;
  @override
  final String? arrivalNote;
  @override
  final String message;

  factory _$RefundTimelineItem(
          [void Function(RefundTimelineItemBuilder)? updates]) =>
      (RefundTimelineItemBuilder()..update(updates))._build();

  _$RefundTimelineItem._(
      {required this.id,
      required this.trigger,
      required this.state,
      required this.displayState,
      required this.amountCentavos,
      this.principalCentavos,
      required this.processingFeeCentavos,
      required this.paymentPurpose,
      required this.originalMethod,
      required this.attemptNumber,
      this.requestedAt,
      this.completedAt,
      this.failureCode,
      this.evidenceOrigin,
      required this.canRetry,
      this.arrivalNote,
      required this.message})
      : super._();
  @override
  RefundTimelineItem rebuild(
          void Function(RefundTimelineItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RefundTimelineItemBuilder toBuilder() =>
      RefundTimelineItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RefundTimelineItem &&
        id == other.id &&
        trigger == other.trigger &&
        state == other.state &&
        displayState == other.displayState &&
        amountCentavos == other.amountCentavos &&
        principalCentavos == other.principalCentavos &&
        processingFeeCentavos == other.processingFeeCentavos &&
        paymentPurpose == other.paymentPurpose &&
        originalMethod == other.originalMethod &&
        attemptNumber == other.attemptNumber &&
        requestedAt == other.requestedAt &&
        completedAt == other.completedAt &&
        failureCode == other.failureCode &&
        evidenceOrigin == other.evidenceOrigin &&
        canRetry == other.canRetry &&
        arrivalNote == other.arrivalNote &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, trigger.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, displayState.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jc(_$hash, processingFeeCentavos.hashCode);
    _$hash = $jc(_$hash, paymentPurpose.hashCode);
    _$hash = $jc(_$hash, originalMethod.hashCode);
    _$hash = $jc(_$hash, attemptNumber.hashCode);
    _$hash = $jc(_$hash, requestedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, failureCode.hashCode);
    _$hash = $jc(_$hash, evidenceOrigin.hashCode);
    _$hash = $jc(_$hash, canRetry.hashCode);
    _$hash = $jc(_$hash, arrivalNote.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RefundTimelineItem')
          ..add('id', id)
          ..add('trigger', trigger)
          ..add('state', state)
          ..add('displayState', displayState)
          ..add('amountCentavos', amountCentavos)
          ..add('principalCentavos', principalCentavos)
          ..add('processingFeeCentavos', processingFeeCentavos)
          ..add('paymentPurpose', paymentPurpose)
          ..add('originalMethod', originalMethod)
          ..add('attemptNumber', attemptNumber)
          ..add('requestedAt', requestedAt)
          ..add('completedAt', completedAt)
          ..add('failureCode', failureCode)
          ..add('evidenceOrigin', evidenceOrigin)
          ..add('canRetry', canRetry)
          ..add('arrivalNote', arrivalNote)
          ..add('message', message))
        .toString();
  }
}

class RefundTimelineItemBuilder
    implements Builder<RefundTimelineItem, RefundTimelineItemBuilder> {
  _$RefundTimelineItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  RefundTimelineItemTriggerEnum? _trigger;
  RefundTimelineItemTriggerEnum? get trigger => _$this._trigger;
  set trigger(RefundTimelineItemTriggerEnum? trigger) =>
      _$this._trigger = trigger;

  RefundTimelineItemStateEnum? _state;
  RefundTimelineItemStateEnum? get state => _$this._state;
  set state(RefundTimelineItemStateEnum? state) => _$this._state = state;

  RefundTimelineItemDisplayStateEnum? _displayState;
  RefundTimelineItemDisplayStateEnum? get displayState => _$this._displayState;
  set displayState(RefundTimelineItemDisplayStateEnum? displayState) =>
      _$this._displayState = displayState;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  int? _processingFeeCentavos;
  int? get processingFeeCentavos => _$this._processingFeeCentavos;
  set processingFeeCentavos(int? processingFeeCentavos) =>
      _$this._processingFeeCentavos = processingFeeCentavos;

  String? _paymentPurpose;
  String? get paymentPurpose => _$this._paymentPurpose;
  set paymentPurpose(String? paymentPurpose) =>
      _$this._paymentPurpose = paymentPurpose;

  String? _originalMethod;
  String? get originalMethod => _$this._originalMethod;
  set originalMethod(String? originalMethod) =>
      _$this._originalMethod = originalMethod;

  int? _attemptNumber;
  int? get attemptNumber => _$this._attemptNumber;
  set attemptNumber(int? attemptNumber) =>
      _$this._attemptNumber = attemptNumber;

  DateTime? _requestedAt;
  DateTime? get requestedAt => _$this._requestedAt;
  set requestedAt(DateTime? requestedAt) => _$this._requestedAt = requestedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  String? _failureCode;
  String? get failureCode => _$this._failureCode;
  set failureCode(String? failureCode) => _$this._failureCode = failureCode;

  String? _evidenceOrigin;
  String? get evidenceOrigin => _$this._evidenceOrigin;
  set evidenceOrigin(String? evidenceOrigin) =>
      _$this._evidenceOrigin = evidenceOrigin;

  bool? _canRetry;
  bool? get canRetry => _$this._canRetry;
  set canRetry(bool? canRetry) => _$this._canRetry = canRetry;

  String? _arrivalNote;
  String? get arrivalNote => _$this._arrivalNote;
  set arrivalNote(String? arrivalNote) => _$this._arrivalNote = arrivalNote;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  RefundTimelineItemBuilder() {
    RefundTimelineItem._defaults(this);
  }

  RefundTimelineItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _trigger = $v.trigger;
      _state = $v.state;
      _displayState = $v.displayState;
      _amountCentavos = $v.amountCentavos;
      _principalCentavos = $v.principalCentavos;
      _processingFeeCentavos = $v.processingFeeCentavos;
      _paymentPurpose = $v.paymentPurpose;
      _originalMethod = $v.originalMethod;
      _attemptNumber = $v.attemptNumber;
      _requestedAt = $v.requestedAt;
      _completedAt = $v.completedAt;
      _failureCode = $v.failureCode;
      _evidenceOrigin = $v.evidenceOrigin;
      _canRetry = $v.canRetry;
      _arrivalNote = $v.arrivalNote;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RefundTimelineItem other) {
    _$v = other as _$RefundTimelineItem;
  }

  @override
  void update(void Function(RefundTimelineItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RefundTimelineItem build() => _build();

  _$RefundTimelineItem _build() {
    final _$result = _$v ??
        _$RefundTimelineItem._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'RefundTimelineItem', 'id'),
          trigger: BuiltValueNullFieldError.checkNotNull(
              trigger, r'RefundTimelineItem', 'trigger'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'RefundTimelineItem', 'state'),
          displayState: BuiltValueNullFieldError.checkNotNull(
              displayState, r'RefundTimelineItem', 'displayState'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'RefundTimelineItem', 'amountCentavos'),
          principalCentavos: principalCentavos,
          processingFeeCentavos: BuiltValueNullFieldError.checkNotNull(
              processingFeeCentavos,
              r'RefundTimelineItem',
              'processingFeeCentavos'),
          paymentPurpose: BuiltValueNullFieldError.checkNotNull(
              paymentPurpose, r'RefundTimelineItem', 'paymentPurpose'),
          originalMethod: BuiltValueNullFieldError.checkNotNull(
              originalMethod, r'RefundTimelineItem', 'originalMethod'),
          attemptNumber: BuiltValueNullFieldError.checkNotNull(
              attemptNumber, r'RefundTimelineItem', 'attemptNumber'),
          requestedAt: requestedAt,
          completedAt: completedAt,
          failureCode: failureCode,
          evidenceOrigin: evidenceOrigin,
          canRetry: BuiltValueNullFieldError.checkNotNull(
              canRetry, r'RefundTimelineItem', 'canRetry'),
          arrivalNote: arrivalNote,
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'RefundTimelineItem', 'message'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
