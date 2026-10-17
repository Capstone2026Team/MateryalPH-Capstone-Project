// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_order_reviews.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerOrderReviewsStateEnum _$buyerOrderReviewsStateEnum_NOT_COMPLETED =
    const BuyerOrderReviewsStateEnum._('NOT_COMPLETED');
const BuyerOrderReviewsStateEnum _$buyerOrderReviewsStateEnum_OPEN =
    const BuyerOrderReviewsStateEnum._('OPEN');
const BuyerOrderReviewsStateEnum _$buyerOrderReviewsStateEnum_CLOSED =
    const BuyerOrderReviewsStateEnum._('CLOSED');

BuyerOrderReviewsStateEnum _$buyerOrderReviewsStateEnumValueOf(String name) {
  switch (name) {
    case 'NOT_COMPLETED':
      return _$buyerOrderReviewsStateEnum_NOT_COMPLETED;
    case 'OPEN':
      return _$buyerOrderReviewsStateEnum_OPEN;
    case 'CLOSED':
      return _$buyerOrderReviewsStateEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOrderReviewsStateEnum> _$buyerOrderReviewsStateEnumValues =
    BuiltSet<BuyerOrderReviewsStateEnum>(const <BuyerOrderReviewsStateEnum>[
  _$buyerOrderReviewsStateEnum_NOT_COMPLETED,
  _$buyerOrderReviewsStateEnum_OPEN,
  _$buyerOrderReviewsStateEnum_CLOSED,
]);

const BuyerOrderReviewsRevealReasonEnum
    _$buyerOrderReviewsRevealReasonEnum_BOTH_SUBMITTED =
    const BuyerOrderReviewsRevealReasonEnum._('BOTH_SUBMITTED');
const BuyerOrderReviewsRevealReasonEnum
    _$buyerOrderReviewsRevealReasonEnum_WINDOW_EXPIRED =
    const BuyerOrderReviewsRevealReasonEnum._('WINDOW_EXPIRED');

BuyerOrderReviewsRevealReasonEnum _$buyerOrderReviewsRevealReasonEnumValueOf(
    String name) {
  switch (name) {
    case 'BOTH_SUBMITTED':
      return _$buyerOrderReviewsRevealReasonEnum_BOTH_SUBMITTED;
    case 'WINDOW_EXPIRED':
      return _$buyerOrderReviewsRevealReasonEnum_WINDOW_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOrderReviewsRevealReasonEnum>
    _$buyerOrderReviewsRevealReasonEnumValues = BuiltSet<
        BuyerOrderReviewsRevealReasonEnum>(const <BuyerOrderReviewsRevealReasonEnum>[
  _$buyerOrderReviewsRevealReasonEnum_BOTH_SUBMITTED,
  _$buyerOrderReviewsRevealReasonEnum_WINDOW_EXPIRED,
]);

const BuyerOrderReviewsPartyEnum _$buyerOrderReviewsPartyEnum_BUYER =
    const BuyerOrderReviewsPartyEnum._('BUYER');

BuyerOrderReviewsPartyEnum _$buyerOrderReviewsPartyEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$buyerOrderReviewsPartyEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOrderReviewsPartyEnum> _$buyerOrderReviewsPartyEnumValues =
    BuiltSet<BuyerOrderReviewsPartyEnum>(const <BuyerOrderReviewsPartyEnum>[
  _$buyerOrderReviewsPartyEnum_BUYER,
]);

const BuyerOrderReviewsSpeedKindEnum
    _$buyerOrderReviewsSpeedKindEnum_DELIVERY_SPEED =
    const BuyerOrderReviewsSpeedKindEnum._('DELIVERY_SPEED');
const BuyerOrderReviewsSpeedKindEnum
    _$buyerOrderReviewsSpeedKindEnum_PROCESSING_SPEED =
    const BuyerOrderReviewsSpeedKindEnum._('PROCESSING_SPEED');

BuyerOrderReviewsSpeedKindEnum _$buyerOrderReviewsSpeedKindEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERY_SPEED':
      return _$buyerOrderReviewsSpeedKindEnum_DELIVERY_SPEED;
    case 'PROCESSING_SPEED':
      return _$buyerOrderReviewsSpeedKindEnum_PROCESSING_SPEED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOrderReviewsSpeedKindEnum>
    _$buyerOrderReviewsSpeedKindEnumValues = BuiltSet<
        BuyerOrderReviewsSpeedKindEnum>(const <BuyerOrderReviewsSpeedKindEnum>[
  _$buyerOrderReviewsSpeedKindEnum_DELIVERY_SPEED,
  _$buyerOrderReviewsSpeedKindEnum_PROCESSING_SPEED,
]);

Serializer<BuyerOrderReviewsStateEnum> _$buyerOrderReviewsStateEnumSerializer =
    _$BuyerOrderReviewsStateEnumSerializer();
Serializer<BuyerOrderReviewsRevealReasonEnum>
    _$buyerOrderReviewsRevealReasonEnumSerializer =
    _$BuyerOrderReviewsRevealReasonEnumSerializer();
Serializer<BuyerOrderReviewsPartyEnum> _$buyerOrderReviewsPartyEnumSerializer =
    _$BuyerOrderReviewsPartyEnumSerializer();
Serializer<BuyerOrderReviewsSpeedKindEnum>
    _$buyerOrderReviewsSpeedKindEnumSerializer =
    _$BuyerOrderReviewsSpeedKindEnumSerializer();

class _$BuyerOrderReviewsStateEnumSerializer
    implements PrimitiveSerializer<BuyerOrderReviewsStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_COMPLETED': 'NOT_COMPLETED',
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_COMPLETED': 'NOT_COMPLETED',
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOrderReviewsStateEnum];
  @override
  final String wireName = 'BuyerOrderReviewsStateEnum';

  @override
  Object serialize(Serializers serializers, BuyerOrderReviewsStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOrderReviewsStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOrderReviewsStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOrderReviewsRevealReasonEnumSerializer
    implements PrimitiveSerializer<BuyerOrderReviewsRevealReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BOTH_SUBMITTED': 'BOTH_SUBMITTED',
    'WINDOW_EXPIRED': 'WINDOW_EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BOTH_SUBMITTED': 'BOTH_SUBMITTED',
    'WINDOW_EXPIRED': 'WINDOW_EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOrderReviewsRevealReasonEnum];
  @override
  final String wireName = 'BuyerOrderReviewsRevealReasonEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerOrderReviewsRevealReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOrderReviewsRevealReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOrderReviewsRevealReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOrderReviewsPartyEnumSerializer
    implements PrimitiveSerializer<BuyerOrderReviewsPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOrderReviewsPartyEnum];
  @override
  final String wireName = 'BuyerOrderReviewsPartyEnum';

  @override
  Object serialize(Serializers serializers, BuyerOrderReviewsPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOrderReviewsPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOrderReviewsPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOrderReviewsSpeedKindEnumSerializer
    implements PrimitiveSerializer<BuyerOrderReviewsSpeedKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY_SPEED': 'DELIVERY_SPEED',
    'PROCESSING_SPEED': 'PROCESSING_SPEED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY_SPEED': 'DELIVERY_SPEED',
    'PROCESSING_SPEED': 'PROCESSING_SPEED',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerOrderReviewsSpeedKindEnum];
  @override
  final String wireName = 'BuyerOrderReviewsSpeedKindEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerOrderReviewsSpeedKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOrderReviewsSpeedKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOrderReviewsSpeedKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOrderReviews extends BuyerOrderReviews {
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final BuyerOrderReviewsStateEnum state;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? closesAt;
  @override
  final String? closesAtLabel;
  @override
  final bool revealed;
  @override
  final DateTime? revealedAt;
  @override
  final BuyerOrderReviewsRevealReasonEnum? revealReason;
  @override
  final bool withheldForDispute;
  @override
  final ReviewWindowRules rules;
  @override
  final BuyerOrderReviewsPartyEnum party;
  @override
  final BuyerOrderReviewsSpeedKindEnum speedKind;
  @override
  final String speedLabel;
  @override
  final BuiltList<ReviewDisplayOption> displayNameOptions;
  @override
  final OwnReview? vendorRating;
  @override
  final bool canSubmitVendorRating;
  @override
  final BuiltList<ReviewLine> lines;
  @override
  final CounterpartRating? counterpartRating;

  factory _$BuyerOrderReviews(
          [void Function(BuyerOrderReviewsBuilder)? updates]) =>
      (BuyerOrderReviewsBuilder()..update(updates))._build();

  _$BuyerOrderReviews._(
      {required this.orderId,
      required this.orderReference,
      required this.state,
      this.completedAt,
      this.closesAt,
      this.closesAtLabel,
      required this.revealed,
      this.revealedAt,
      this.revealReason,
      required this.withheldForDispute,
      required this.rules,
      required this.party,
      required this.speedKind,
      required this.speedLabel,
      required this.displayNameOptions,
      this.vendorRating,
      required this.canSubmitVendorRating,
      required this.lines,
      this.counterpartRating})
      : super._();
  @override
  BuyerOrderReviews rebuild(void Function(BuyerOrderReviewsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOrderReviewsBuilder toBuilder() =>
      BuyerOrderReviewsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOrderReviews &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        state == other.state &&
        completedAt == other.completedAt &&
        closesAt == other.closesAt &&
        closesAtLabel == other.closesAtLabel &&
        revealed == other.revealed &&
        revealedAt == other.revealedAt &&
        revealReason == other.revealReason &&
        withheldForDispute == other.withheldForDispute &&
        rules == other.rules &&
        party == other.party &&
        speedKind == other.speedKind &&
        speedLabel == other.speedLabel &&
        displayNameOptions == other.displayNameOptions &&
        vendorRating == other.vendorRating &&
        canSubmitVendorRating == other.canSubmitVendorRating &&
        lines == other.lines &&
        counterpartRating == other.counterpartRating;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, closesAtLabel.hashCode);
    _$hash = $jc(_$hash, revealed.hashCode);
    _$hash = $jc(_$hash, revealedAt.hashCode);
    _$hash = $jc(_$hash, revealReason.hashCode);
    _$hash = $jc(_$hash, withheldForDispute.hashCode);
    _$hash = $jc(_$hash, rules.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, speedKind.hashCode);
    _$hash = $jc(_$hash, speedLabel.hashCode);
    _$hash = $jc(_$hash, displayNameOptions.hashCode);
    _$hash = $jc(_$hash, vendorRating.hashCode);
    _$hash = $jc(_$hash, canSubmitVendorRating.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, counterpartRating.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerOrderReviews')
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('state', state)
          ..add('completedAt', completedAt)
          ..add('closesAt', closesAt)
          ..add('closesAtLabel', closesAtLabel)
          ..add('revealed', revealed)
          ..add('revealedAt', revealedAt)
          ..add('revealReason', revealReason)
          ..add('withheldForDispute', withheldForDispute)
          ..add('rules', rules)
          ..add('party', party)
          ..add('speedKind', speedKind)
          ..add('speedLabel', speedLabel)
          ..add('displayNameOptions', displayNameOptions)
          ..add('vendorRating', vendorRating)
          ..add('canSubmitVendorRating', canSubmitVendorRating)
          ..add('lines', lines)
          ..add('counterpartRating', counterpartRating))
        .toString();
  }
}

class BuyerOrderReviewsBuilder
    implements Builder<BuyerOrderReviews, BuyerOrderReviewsBuilder> {
  _$BuyerOrderReviews? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  BuyerOrderReviewsStateEnum? _state;
  BuyerOrderReviewsStateEnum? get state => _$this._state;
  set state(BuyerOrderReviewsStateEnum? state) => _$this._state = state;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  DateTime? _closesAt;
  DateTime? get closesAt => _$this._closesAt;
  set closesAt(DateTime? closesAt) => _$this._closesAt = closesAt;

  String? _closesAtLabel;
  String? get closesAtLabel => _$this._closesAtLabel;
  set closesAtLabel(String? closesAtLabel) =>
      _$this._closesAtLabel = closesAtLabel;

  bool? _revealed;
  bool? get revealed => _$this._revealed;
  set revealed(bool? revealed) => _$this._revealed = revealed;

  DateTime? _revealedAt;
  DateTime? get revealedAt => _$this._revealedAt;
  set revealedAt(DateTime? revealedAt) => _$this._revealedAt = revealedAt;

  BuyerOrderReviewsRevealReasonEnum? _revealReason;
  BuyerOrderReviewsRevealReasonEnum? get revealReason => _$this._revealReason;
  set revealReason(BuyerOrderReviewsRevealReasonEnum? revealReason) =>
      _$this._revealReason = revealReason;

  bool? _withheldForDispute;
  bool? get withheldForDispute => _$this._withheldForDispute;
  set withheldForDispute(bool? withheldForDispute) =>
      _$this._withheldForDispute = withheldForDispute;

  ReviewWindowRulesBuilder? _rules;
  ReviewWindowRulesBuilder get rules =>
      _$this._rules ??= ReviewWindowRulesBuilder();
  set rules(ReviewWindowRulesBuilder? rules) => _$this._rules = rules;

  BuyerOrderReviewsPartyEnum? _party;
  BuyerOrderReviewsPartyEnum? get party => _$this._party;
  set party(BuyerOrderReviewsPartyEnum? party) => _$this._party = party;

  BuyerOrderReviewsSpeedKindEnum? _speedKind;
  BuyerOrderReviewsSpeedKindEnum? get speedKind => _$this._speedKind;
  set speedKind(BuyerOrderReviewsSpeedKindEnum? speedKind) =>
      _$this._speedKind = speedKind;

  String? _speedLabel;
  String? get speedLabel => _$this._speedLabel;
  set speedLabel(String? speedLabel) => _$this._speedLabel = speedLabel;

  ListBuilder<ReviewDisplayOption>? _displayNameOptions;
  ListBuilder<ReviewDisplayOption> get displayNameOptions =>
      _$this._displayNameOptions ??= ListBuilder<ReviewDisplayOption>();
  set displayNameOptions(
          ListBuilder<ReviewDisplayOption>? displayNameOptions) =>
      _$this._displayNameOptions = displayNameOptions;

  OwnReviewBuilder? _vendorRating;
  OwnReviewBuilder get vendorRating =>
      _$this._vendorRating ??= OwnReviewBuilder();
  set vendorRating(OwnReviewBuilder? vendorRating) =>
      _$this._vendorRating = vendorRating;

  bool? _canSubmitVendorRating;
  bool? get canSubmitVendorRating => _$this._canSubmitVendorRating;
  set canSubmitVendorRating(bool? canSubmitVendorRating) =>
      _$this._canSubmitVendorRating = canSubmitVendorRating;

  ListBuilder<ReviewLine>? _lines;
  ListBuilder<ReviewLine> get lines =>
      _$this._lines ??= ListBuilder<ReviewLine>();
  set lines(ListBuilder<ReviewLine>? lines) => _$this._lines = lines;

  CounterpartRatingBuilder? _counterpartRating;
  CounterpartRatingBuilder get counterpartRating =>
      _$this._counterpartRating ??= CounterpartRatingBuilder();
  set counterpartRating(CounterpartRatingBuilder? counterpartRating) =>
      _$this._counterpartRating = counterpartRating;

  BuyerOrderReviewsBuilder() {
    BuyerOrderReviews._defaults(this);
  }

  BuyerOrderReviewsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _state = $v.state;
      _completedAt = $v.completedAt;
      _closesAt = $v.closesAt;
      _closesAtLabel = $v.closesAtLabel;
      _revealed = $v.revealed;
      _revealedAt = $v.revealedAt;
      _revealReason = $v.revealReason;
      _withheldForDispute = $v.withheldForDispute;
      _rules = $v.rules.toBuilder();
      _party = $v.party;
      _speedKind = $v.speedKind;
      _speedLabel = $v.speedLabel;
      _displayNameOptions = $v.displayNameOptions.toBuilder();
      _vendorRating = $v.vendorRating?.toBuilder();
      _canSubmitVendorRating = $v.canSubmitVendorRating;
      _lines = $v.lines.toBuilder();
      _counterpartRating = $v.counterpartRating?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerOrderReviews other) {
    _$v = other as _$BuyerOrderReviews;
  }

  @override
  void update(void Function(BuyerOrderReviewsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOrderReviews build() => _build();

  _$BuyerOrderReviews _build() {
    _$BuyerOrderReviews _$result;
    try {
      _$result = _$v ??
          _$BuyerOrderReviews._(
            orderId: BuiltValueNullFieldError.checkNotNull(
                orderId, r'BuyerOrderReviews', 'orderId'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'BuyerOrderReviews', 'orderReference'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'BuyerOrderReviews', 'state'),
            completedAt: completedAt,
            closesAt: closesAt,
            closesAtLabel: closesAtLabel,
            revealed: BuiltValueNullFieldError.checkNotNull(
                revealed, r'BuyerOrderReviews', 'revealed'),
            revealedAt: revealedAt,
            revealReason: revealReason,
            withheldForDispute: BuiltValueNullFieldError.checkNotNull(
                withheldForDispute, r'BuyerOrderReviews', 'withheldForDispute'),
            rules: rules.build(),
            party: BuiltValueNullFieldError.checkNotNull(
                party, r'BuyerOrderReviews', 'party'),
            speedKind: BuiltValueNullFieldError.checkNotNull(
                speedKind, r'BuyerOrderReviews', 'speedKind'),
            speedLabel: BuiltValueNullFieldError.checkNotNull(
                speedLabel, r'BuyerOrderReviews', 'speedLabel'),
            displayNameOptions: displayNameOptions.build(),
            vendorRating: _vendorRating?.build(),
            canSubmitVendorRating: BuiltValueNullFieldError.checkNotNull(
                canSubmitVendorRating,
                r'BuyerOrderReviews',
                'canSubmitVendorRating'),
            lines: lines.build(),
            counterpartRating: _counterpartRating?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();

        _$failedField = 'displayNameOptions';
        displayNameOptions.build();
        _$failedField = 'vendorRating';
        _vendorRating?.build();

        _$failedField = 'lines';
        lines.build();
        _$failedField = 'counterpartRating';
        _counterpartRating?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerOrderReviews', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
