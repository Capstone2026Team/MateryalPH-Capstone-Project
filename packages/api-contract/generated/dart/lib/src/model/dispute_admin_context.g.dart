// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_admin_context.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeAdminContextOutcomesEnum
    _$disputeAdminContextOutcomesEnum_DISMISSED =
    const DisputeAdminContextOutcomesEnum._('DISMISSED');
const DisputeAdminContextOutcomesEnum
    _$disputeAdminContextOutcomesEnum_REPLACEMENT =
    const DisputeAdminContextOutcomesEnum._('REPLACEMENT');
const DisputeAdminContextOutcomesEnum
    _$disputeAdminContextOutcomesEnum_FULL_REFUND =
    const DisputeAdminContextOutcomesEnum._('FULL_REFUND');
const DisputeAdminContextOutcomesEnum
    _$disputeAdminContextOutcomesEnum_PARTIAL_REFUND =
    const DisputeAdminContextOutcomesEnum._('PARTIAL_REFUND');
const DisputeAdminContextOutcomesEnum
    _$disputeAdminContextOutcomesEnum_INCONCLUSIVE =
    const DisputeAdminContextOutcomesEnum._('INCONCLUSIVE');
const DisputeAdminContextOutcomesEnum
    _$disputeAdminContextOutcomesEnum_NO_FURTHER_ACTION =
    const DisputeAdminContextOutcomesEnum._('NO_FURTHER_ACTION');

DisputeAdminContextOutcomesEnum _$disputeAdminContextOutcomesEnumValueOf(
    String name) {
  switch (name) {
    case 'DISMISSED':
      return _$disputeAdminContextOutcomesEnum_DISMISSED;
    case 'REPLACEMENT':
      return _$disputeAdminContextOutcomesEnum_REPLACEMENT;
    case 'FULL_REFUND':
      return _$disputeAdminContextOutcomesEnum_FULL_REFUND;
    case 'PARTIAL_REFUND':
      return _$disputeAdminContextOutcomesEnum_PARTIAL_REFUND;
    case 'INCONCLUSIVE':
      return _$disputeAdminContextOutcomesEnum_INCONCLUSIVE;
    case 'NO_FURTHER_ACTION':
      return _$disputeAdminContextOutcomesEnum_NO_FURTHER_ACTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeAdminContextOutcomesEnum>
    _$disputeAdminContextOutcomesEnumValues = BuiltSet<
        DisputeAdminContextOutcomesEnum>(const <DisputeAdminContextOutcomesEnum>[
  _$disputeAdminContextOutcomesEnum_DISMISSED,
  _$disputeAdminContextOutcomesEnum_REPLACEMENT,
  _$disputeAdminContextOutcomesEnum_FULL_REFUND,
  _$disputeAdminContextOutcomesEnum_PARTIAL_REFUND,
  _$disputeAdminContextOutcomesEnum_INCONCLUSIVE,
  _$disputeAdminContextOutcomesEnum_NO_FURTHER_ACTION,
]);

const DisputeAdminContextSanctionsEnum
    _$disputeAdminContextSanctionsEnum_WARNING =
    const DisputeAdminContextSanctionsEnum._('WARNING');
const DisputeAdminContextSanctionsEnum
    _$disputeAdminContextSanctionsEnum_TEMPORARY_RESTRICTION =
    const DisputeAdminContextSanctionsEnum._('TEMPORARY_RESTRICTION');
const DisputeAdminContextSanctionsEnum
    _$disputeAdminContextSanctionsEnum_SUSPENSION =
    const DisputeAdminContextSanctionsEnum._('SUSPENSION');
const DisputeAdminContextSanctionsEnum
    _$disputeAdminContextSanctionsEnum_PERMANENT_BAN =
    const DisputeAdminContextSanctionsEnum._('PERMANENT_BAN');

DisputeAdminContextSanctionsEnum _$disputeAdminContextSanctionsEnumValueOf(
    String name) {
  switch (name) {
    case 'WARNING':
      return _$disputeAdminContextSanctionsEnum_WARNING;
    case 'TEMPORARY_RESTRICTION':
      return _$disputeAdminContextSanctionsEnum_TEMPORARY_RESTRICTION;
    case 'SUSPENSION':
      return _$disputeAdminContextSanctionsEnum_SUSPENSION;
    case 'PERMANENT_BAN':
      return _$disputeAdminContextSanctionsEnum_PERMANENT_BAN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeAdminContextSanctionsEnum>
    _$disputeAdminContextSanctionsEnumValues = BuiltSet<
        DisputeAdminContextSanctionsEnum>(const <DisputeAdminContextSanctionsEnum>[
  _$disputeAdminContextSanctionsEnum_WARNING,
  _$disputeAdminContextSanctionsEnum_TEMPORARY_RESTRICTION,
  _$disputeAdminContextSanctionsEnum_SUSPENSION,
  _$disputeAdminContextSanctionsEnum_PERMANENT_BAN,
]);

const DisputeAdminContextMetricEventsEnum
    _$disputeAdminContextMetricEventsEnum_VALIDATED_DEFECT_RETURN =
    const DisputeAdminContextMetricEventsEnum._('VALIDATED_DEFECT_RETURN');
const DisputeAdminContextMetricEventsEnum
    _$disputeAdminContextMetricEventsEnum_VENDOR_NON_FULFILLMENT =
    const DisputeAdminContextMetricEventsEnum._('VENDOR_NON_FULFILLMENT');
const DisputeAdminContextMetricEventsEnum
    _$disputeAdminContextMetricEventsEnum_MISREPRESENTED_LISTING =
    const DisputeAdminContextMetricEventsEnum._('MISREPRESENTED_LISTING');

DisputeAdminContextMetricEventsEnum
    _$disputeAdminContextMetricEventsEnumValueOf(String name) {
  switch (name) {
    case 'VALIDATED_DEFECT_RETURN':
      return _$disputeAdminContextMetricEventsEnum_VALIDATED_DEFECT_RETURN;
    case 'VENDOR_NON_FULFILLMENT':
      return _$disputeAdminContextMetricEventsEnum_VENDOR_NON_FULFILLMENT;
    case 'MISREPRESENTED_LISTING':
      return _$disputeAdminContextMetricEventsEnum_MISREPRESENTED_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeAdminContextMetricEventsEnum>
    _$disputeAdminContextMetricEventsEnumValues = BuiltSet<
        DisputeAdminContextMetricEventsEnum>(const <DisputeAdminContextMetricEventsEnum>[
  _$disputeAdminContextMetricEventsEnum_VALIDATED_DEFECT_RETURN,
  _$disputeAdminContextMetricEventsEnum_VENDOR_NON_FULFILLMENT,
  _$disputeAdminContextMetricEventsEnum_MISREPRESENTED_LISTING,
]);

Serializer<DisputeAdminContextOutcomesEnum>
    _$disputeAdminContextOutcomesEnumSerializer =
    _$DisputeAdminContextOutcomesEnumSerializer();
Serializer<DisputeAdminContextSanctionsEnum>
    _$disputeAdminContextSanctionsEnumSerializer =
    _$DisputeAdminContextSanctionsEnumSerializer();
Serializer<DisputeAdminContextMetricEventsEnum>
    _$disputeAdminContextMetricEventsEnumSerializer =
    _$DisputeAdminContextMetricEventsEnumSerializer();

class _$DisputeAdminContextOutcomesEnumSerializer
    implements PrimitiveSerializer<DisputeAdminContextOutcomesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISMISSED': 'DISMISSED',
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'INCONCLUSIVE': 'INCONCLUSIVE',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISMISSED': 'DISMISSED',
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'INCONCLUSIVE': 'INCONCLUSIVE',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeAdminContextOutcomesEnum];
  @override
  final String wireName = 'DisputeAdminContextOutcomesEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeAdminContextOutcomesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeAdminContextOutcomesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeAdminContextOutcomesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeAdminContextSanctionsEnumSerializer
    implements PrimitiveSerializer<DisputeAdminContextSanctionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WARNING': 'WARNING',
    'TEMPORARY_RESTRICTION': 'TEMPORARY_RESTRICTION',
    'SUSPENSION': 'SUSPENSION',
    'PERMANENT_BAN': 'PERMANENT_BAN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WARNING': 'WARNING',
    'TEMPORARY_RESTRICTION': 'TEMPORARY_RESTRICTION',
    'SUSPENSION': 'SUSPENSION',
    'PERMANENT_BAN': 'PERMANENT_BAN',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeAdminContextSanctionsEnum];
  @override
  final String wireName = 'DisputeAdminContextSanctionsEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeAdminContextSanctionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeAdminContextSanctionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeAdminContextSanctionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeAdminContextMetricEventsEnumSerializer
    implements PrimitiveSerializer<DisputeAdminContextMetricEventsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALIDATED_DEFECT_RETURN': 'VALIDATED_DEFECT_RETURN',
    'VENDOR_NON_FULFILLMENT': 'VENDOR_NON_FULFILLMENT',
    'MISREPRESENTED_LISTING': 'MISREPRESENTED_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALIDATED_DEFECT_RETURN': 'VALIDATED_DEFECT_RETURN',
    'VENDOR_NON_FULFILLMENT': 'VENDOR_NON_FULFILLMENT',
    'MISREPRESENTED_LISTING': 'MISREPRESENTED_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DisputeAdminContextMetricEventsEnum
  ];
  @override
  final String wireName = 'DisputeAdminContextMetricEventsEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeAdminContextMetricEventsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeAdminContextMetricEventsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeAdminContextMetricEventsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeAdminContext extends DisputeAdminContext {
  @override
  final BuiltList<DisputeAdminContextOutcomesEnum> outcomes;
  @override
  final BuiltList<DisputeAdminContextSanctionsEnum> sanctions;
  @override
  final BuiltList<DisputeAdminContextMetricEventsEnum> metricEvents;
  @override
  final DisputeRefundable refundable;
  @override
  final int alreadyAwardedCentavos;
  @override
  final bool appealReviewerConflict;
  @override
  final bool unansweredClarification;
  @override
  final DisputeAdminParty buyer;
  @override
  final DisputeAdminParty vendor;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> orderTimeline;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> enforcement;

  factory _$DisputeAdminContext(
          [void Function(DisputeAdminContextBuilder)? updates]) =>
      (DisputeAdminContextBuilder()..update(updates))._build();

  _$DisputeAdminContext._(
      {required this.outcomes,
      required this.sanctions,
      required this.metricEvents,
      required this.refundable,
      required this.alreadyAwardedCentavos,
      required this.appealReviewerConflict,
      required this.unansweredClarification,
      required this.buyer,
      required this.vendor,
      required this.orderTimeline,
      required this.enforcement})
      : super._();
  @override
  DisputeAdminContext rebuild(
          void Function(DisputeAdminContextBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeAdminContextBuilder toBuilder() =>
      DisputeAdminContextBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeAdminContext &&
        outcomes == other.outcomes &&
        sanctions == other.sanctions &&
        metricEvents == other.metricEvents &&
        refundable == other.refundable &&
        alreadyAwardedCentavos == other.alreadyAwardedCentavos &&
        appealReviewerConflict == other.appealReviewerConflict &&
        unansweredClarification == other.unansweredClarification &&
        buyer == other.buyer &&
        vendor == other.vendor &&
        orderTimeline == other.orderTimeline &&
        enforcement == other.enforcement;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outcomes.hashCode);
    _$hash = $jc(_$hash, sanctions.hashCode);
    _$hash = $jc(_$hash, metricEvents.hashCode);
    _$hash = $jc(_$hash, refundable.hashCode);
    _$hash = $jc(_$hash, alreadyAwardedCentavos.hashCode);
    _$hash = $jc(_$hash, appealReviewerConflict.hashCode);
    _$hash = $jc(_$hash, unansweredClarification.hashCode);
    _$hash = $jc(_$hash, buyer.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, orderTimeline.hashCode);
    _$hash = $jc(_$hash, enforcement.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeAdminContext')
          ..add('outcomes', outcomes)
          ..add('sanctions', sanctions)
          ..add('metricEvents', metricEvents)
          ..add('refundable', refundable)
          ..add('alreadyAwardedCentavos', alreadyAwardedCentavos)
          ..add('appealReviewerConflict', appealReviewerConflict)
          ..add('unansweredClarification', unansweredClarification)
          ..add('buyer', buyer)
          ..add('vendor', vendor)
          ..add('orderTimeline', orderTimeline)
          ..add('enforcement', enforcement))
        .toString();
  }
}

class DisputeAdminContextBuilder
    implements Builder<DisputeAdminContext, DisputeAdminContextBuilder> {
  _$DisputeAdminContext? _$v;

  ListBuilder<DisputeAdminContextOutcomesEnum>? _outcomes;
  ListBuilder<DisputeAdminContextOutcomesEnum> get outcomes =>
      _$this._outcomes ??= ListBuilder<DisputeAdminContextOutcomesEnum>();
  set outcomes(ListBuilder<DisputeAdminContextOutcomesEnum>? outcomes) =>
      _$this._outcomes = outcomes;

  ListBuilder<DisputeAdminContextSanctionsEnum>? _sanctions;
  ListBuilder<DisputeAdminContextSanctionsEnum> get sanctions =>
      _$this._sanctions ??= ListBuilder<DisputeAdminContextSanctionsEnum>();
  set sanctions(ListBuilder<DisputeAdminContextSanctionsEnum>? sanctions) =>
      _$this._sanctions = sanctions;

  ListBuilder<DisputeAdminContextMetricEventsEnum>? _metricEvents;
  ListBuilder<DisputeAdminContextMetricEventsEnum> get metricEvents =>
      _$this._metricEvents ??=
          ListBuilder<DisputeAdminContextMetricEventsEnum>();
  set metricEvents(
          ListBuilder<DisputeAdminContextMetricEventsEnum>? metricEvents) =>
      _$this._metricEvents = metricEvents;

  DisputeRefundableBuilder? _refundable;
  DisputeRefundableBuilder get refundable =>
      _$this._refundable ??= DisputeRefundableBuilder();
  set refundable(DisputeRefundableBuilder? refundable) =>
      _$this._refundable = refundable;

  int? _alreadyAwardedCentavos;
  int? get alreadyAwardedCentavos => _$this._alreadyAwardedCentavos;
  set alreadyAwardedCentavos(int? alreadyAwardedCentavos) =>
      _$this._alreadyAwardedCentavos = alreadyAwardedCentavos;

  bool? _appealReviewerConflict;
  bool? get appealReviewerConflict => _$this._appealReviewerConflict;
  set appealReviewerConflict(bool? appealReviewerConflict) =>
      _$this._appealReviewerConflict = appealReviewerConflict;

  bool? _unansweredClarification;
  bool? get unansweredClarification => _$this._unansweredClarification;
  set unansweredClarification(bool? unansweredClarification) =>
      _$this._unansweredClarification = unansweredClarification;

  DisputeAdminPartyBuilder? _buyer;
  DisputeAdminPartyBuilder get buyer =>
      _$this._buyer ??= DisputeAdminPartyBuilder();
  set buyer(DisputeAdminPartyBuilder? buyer) => _$this._buyer = buyer;

  DisputeAdminPartyBuilder? _vendor;
  DisputeAdminPartyBuilder get vendor =>
      _$this._vendor ??= DisputeAdminPartyBuilder();
  set vendor(DisputeAdminPartyBuilder? vendor) => _$this._vendor = vendor;

  ListBuilder<BuiltMap<String, JsonObject?>>? _orderTimeline;
  ListBuilder<BuiltMap<String, JsonObject?>> get orderTimeline =>
      _$this._orderTimeline ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set orderTimeline(
          ListBuilder<BuiltMap<String, JsonObject?>>? orderTimeline) =>
      _$this._orderTimeline = orderTimeline;

  ListBuilder<BuiltMap<String, JsonObject?>>? _enforcement;
  ListBuilder<BuiltMap<String, JsonObject?>> get enforcement =>
      _$this._enforcement ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set enforcement(ListBuilder<BuiltMap<String, JsonObject?>>? enforcement) =>
      _$this._enforcement = enforcement;

  DisputeAdminContextBuilder() {
    DisputeAdminContext._defaults(this);
  }

  DisputeAdminContextBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcomes = $v.outcomes.toBuilder();
      _sanctions = $v.sanctions.toBuilder();
      _metricEvents = $v.metricEvents.toBuilder();
      _refundable = $v.refundable.toBuilder();
      _alreadyAwardedCentavos = $v.alreadyAwardedCentavos;
      _appealReviewerConflict = $v.appealReviewerConflict;
      _unansweredClarification = $v.unansweredClarification;
      _buyer = $v.buyer.toBuilder();
      _vendor = $v.vendor.toBuilder();
      _orderTimeline = $v.orderTimeline.toBuilder();
      _enforcement = $v.enforcement.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeAdminContext other) {
    _$v = other as _$DisputeAdminContext;
  }

  @override
  void update(void Function(DisputeAdminContextBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeAdminContext build() => _build();

  _$DisputeAdminContext _build() {
    _$DisputeAdminContext _$result;
    try {
      _$result = _$v ??
          _$DisputeAdminContext._(
            outcomes: outcomes.build(),
            sanctions: sanctions.build(),
            metricEvents: metricEvents.build(),
            refundable: refundable.build(),
            alreadyAwardedCentavos: BuiltValueNullFieldError.checkNotNull(
                alreadyAwardedCentavos,
                r'DisputeAdminContext',
                'alreadyAwardedCentavos'),
            appealReviewerConflict: BuiltValueNullFieldError.checkNotNull(
                appealReviewerConflict,
                r'DisputeAdminContext',
                'appealReviewerConflict'),
            unansweredClarification: BuiltValueNullFieldError.checkNotNull(
                unansweredClarification,
                r'DisputeAdminContext',
                'unansweredClarification'),
            buyer: buyer.build(),
            vendor: vendor.build(),
            orderTimeline: orderTimeline.build(),
            enforcement: enforcement.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'outcomes';
        outcomes.build();
        _$failedField = 'sanctions';
        sanctions.build();
        _$failedField = 'metricEvents';
        metricEvents.build();
        _$failedField = 'refundable';
        refundable.build();

        _$failedField = 'buyer';
        buyer.build();
        _$failedField = 'vendor';
        vendor.build();
        _$failedField = 'orderTimeline';
        orderTimeline.build();
        _$failedField = 'enforcement';
        enforcement.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeAdminContext', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
