// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_reviews.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorOrderReviewsStateEnum _$vendorOrderReviewsStateEnum_NOT_COMPLETED =
    const VendorOrderReviewsStateEnum._('NOT_COMPLETED');
const VendorOrderReviewsStateEnum _$vendorOrderReviewsStateEnum_OPEN =
    const VendorOrderReviewsStateEnum._('OPEN');
const VendorOrderReviewsStateEnum _$vendorOrderReviewsStateEnum_CLOSED =
    const VendorOrderReviewsStateEnum._('CLOSED');

VendorOrderReviewsStateEnum _$vendorOrderReviewsStateEnumValueOf(String name) {
  switch (name) {
    case 'NOT_COMPLETED':
      return _$vendorOrderReviewsStateEnum_NOT_COMPLETED;
    case 'OPEN':
      return _$vendorOrderReviewsStateEnum_OPEN;
    case 'CLOSED':
      return _$vendorOrderReviewsStateEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderReviewsStateEnum>
    _$vendorOrderReviewsStateEnumValues =
    BuiltSet<VendorOrderReviewsStateEnum>(const <VendorOrderReviewsStateEnum>[
  _$vendorOrderReviewsStateEnum_NOT_COMPLETED,
  _$vendorOrderReviewsStateEnum_OPEN,
  _$vendorOrderReviewsStateEnum_CLOSED,
]);

const VendorOrderReviewsRevealReasonEnum
    _$vendorOrderReviewsRevealReasonEnum_BOTH_SUBMITTED =
    const VendorOrderReviewsRevealReasonEnum._('BOTH_SUBMITTED');
const VendorOrderReviewsRevealReasonEnum
    _$vendorOrderReviewsRevealReasonEnum_WINDOW_EXPIRED =
    const VendorOrderReviewsRevealReasonEnum._('WINDOW_EXPIRED');

VendorOrderReviewsRevealReasonEnum _$vendorOrderReviewsRevealReasonEnumValueOf(
    String name) {
  switch (name) {
    case 'BOTH_SUBMITTED':
      return _$vendorOrderReviewsRevealReasonEnum_BOTH_SUBMITTED;
    case 'WINDOW_EXPIRED':
      return _$vendorOrderReviewsRevealReasonEnum_WINDOW_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderReviewsRevealReasonEnum>
    _$vendorOrderReviewsRevealReasonEnumValues = BuiltSet<
        VendorOrderReviewsRevealReasonEnum>(const <VendorOrderReviewsRevealReasonEnum>[
  _$vendorOrderReviewsRevealReasonEnum_BOTH_SUBMITTED,
  _$vendorOrderReviewsRevealReasonEnum_WINDOW_EXPIRED,
]);

const VendorOrderReviewsPartyEnum _$vendorOrderReviewsPartyEnum_VENDOR =
    const VendorOrderReviewsPartyEnum._('VENDOR');

VendorOrderReviewsPartyEnum _$vendorOrderReviewsPartyEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$vendorOrderReviewsPartyEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorOrderReviewsPartyEnum>
    _$vendorOrderReviewsPartyEnumValues =
    BuiltSet<VendorOrderReviewsPartyEnum>(const <VendorOrderReviewsPartyEnum>[
  _$vendorOrderReviewsPartyEnum_VENDOR,
]);

Serializer<VendorOrderReviewsStateEnum>
    _$vendorOrderReviewsStateEnumSerializer =
    _$VendorOrderReviewsStateEnumSerializer();
Serializer<VendorOrderReviewsRevealReasonEnum>
    _$vendorOrderReviewsRevealReasonEnumSerializer =
    _$VendorOrderReviewsRevealReasonEnumSerializer();
Serializer<VendorOrderReviewsPartyEnum>
    _$vendorOrderReviewsPartyEnumSerializer =
    _$VendorOrderReviewsPartyEnumSerializer();

class _$VendorOrderReviewsStateEnumSerializer
    implements PrimitiveSerializer<VendorOrderReviewsStateEnum> {
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
  final Iterable<Type> types = const <Type>[VendorOrderReviewsStateEnum];
  @override
  final String wireName = 'VendorOrderReviewsStateEnum';

  @override
  Object serialize(Serializers serializers, VendorOrderReviewsStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderReviewsStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderReviewsStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderReviewsRevealReasonEnumSerializer
    implements PrimitiveSerializer<VendorOrderReviewsRevealReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BOTH_SUBMITTED': 'BOTH_SUBMITTED',
    'WINDOW_EXPIRED': 'WINDOW_EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BOTH_SUBMITTED': 'BOTH_SUBMITTED',
    'WINDOW_EXPIRED': 'WINDOW_EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorOrderReviewsRevealReasonEnum];
  @override
  final String wireName = 'VendorOrderReviewsRevealReasonEnum';

  @override
  Object serialize(
          Serializers serializers, VendorOrderReviewsRevealReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderReviewsRevealReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderReviewsRevealReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderReviewsPartyEnumSerializer
    implements PrimitiveSerializer<VendorOrderReviewsPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorOrderReviewsPartyEnum];
  @override
  final String wireName = 'VendorOrderReviewsPartyEnum';

  @override
  Object serialize(Serializers serializers, VendorOrderReviewsPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorOrderReviewsPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorOrderReviewsPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorOrderReviews extends VendorOrderReviews {
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final VendorOrderReviewsStateEnum state;
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
  final VendorOrderReviewsRevealReasonEnum? revealReason;
  @override
  final bool withheldForDispute;
  @override
  final ReviewWindowRules rules;
  @override
  final VendorOrderReviewsPartyEnum party;
  @override
  final OwnReview? buyerRating;
  @override
  final bool canSubmitBuyerRating;
  @override
  final BuiltList<PublicReview> received;

  factory _$VendorOrderReviews(
          [void Function(VendorOrderReviewsBuilder)? updates]) =>
      (VendorOrderReviewsBuilder()..update(updates))._build();

  _$VendorOrderReviews._(
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
      this.buyerRating,
      required this.canSubmitBuyerRating,
      required this.received})
      : super._();
  @override
  VendorOrderReviews rebuild(
          void Function(VendorOrderReviewsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorOrderReviewsBuilder toBuilder() =>
      VendorOrderReviewsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorOrderReviews &&
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
        buyerRating == other.buyerRating &&
        canSubmitBuyerRating == other.canSubmitBuyerRating &&
        received == other.received;
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
    _$hash = $jc(_$hash, buyerRating.hashCode);
    _$hash = $jc(_$hash, canSubmitBuyerRating.hashCode);
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorOrderReviews')
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
          ..add('buyerRating', buyerRating)
          ..add('canSubmitBuyerRating', canSubmitBuyerRating)
          ..add('received', received))
        .toString();
  }
}

class VendorOrderReviewsBuilder
    implements Builder<VendorOrderReviews, VendorOrderReviewsBuilder> {
  _$VendorOrderReviews? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  VendorOrderReviewsStateEnum? _state;
  VendorOrderReviewsStateEnum? get state => _$this._state;
  set state(VendorOrderReviewsStateEnum? state) => _$this._state = state;

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

  VendorOrderReviewsRevealReasonEnum? _revealReason;
  VendorOrderReviewsRevealReasonEnum? get revealReason => _$this._revealReason;
  set revealReason(VendorOrderReviewsRevealReasonEnum? revealReason) =>
      _$this._revealReason = revealReason;

  bool? _withheldForDispute;
  bool? get withheldForDispute => _$this._withheldForDispute;
  set withheldForDispute(bool? withheldForDispute) =>
      _$this._withheldForDispute = withheldForDispute;

  ReviewWindowRulesBuilder? _rules;
  ReviewWindowRulesBuilder get rules =>
      _$this._rules ??= ReviewWindowRulesBuilder();
  set rules(ReviewWindowRulesBuilder? rules) => _$this._rules = rules;

  VendorOrderReviewsPartyEnum? _party;
  VendorOrderReviewsPartyEnum? get party => _$this._party;
  set party(VendorOrderReviewsPartyEnum? party) => _$this._party = party;

  OwnReviewBuilder? _buyerRating;
  OwnReviewBuilder get buyerRating =>
      _$this._buyerRating ??= OwnReviewBuilder();
  set buyerRating(OwnReviewBuilder? buyerRating) =>
      _$this._buyerRating = buyerRating;

  bool? _canSubmitBuyerRating;
  bool? get canSubmitBuyerRating => _$this._canSubmitBuyerRating;
  set canSubmitBuyerRating(bool? canSubmitBuyerRating) =>
      _$this._canSubmitBuyerRating = canSubmitBuyerRating;

  ListBuilder<PublicReview>? _received;
  ListBuilder<PublicReview> get received =>
      _$this._received ??= ListBuilder<PublicReview>();
  set received(ListBuilder<PublicReview>? received) =>
      _$this._received = received;

  VendorOrderReviewsBuilder() {
    VendorOrderReviews._defaults(this);
  }

  VendorOrderReviewsBuilder get _$this {
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
      _buyerRating = $v.buyerRating?.toBuilder();
      _canSubmitBuyerRating = $v.canSubmitBuyerRating;
      _received = $v.received.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorOrderReviews other) {
    _$v = other as _$VendorOrderReviews;
  }

  @override
  void update(void Function(VendorOrderReviewsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorOrderReviews build() => _build();

  _$VendorOrderReviews _build() {
    _$VendorOrderReviews _$result;
    try {
      _$result = _$v ??
          _$VendorOrderReviews._(
            orderId: BuiltValueNullFieldError.checkNotNull(
                orderId, r'VendorOrderReviews', 'orderId'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'VendorOrderReviews', 'orderReference'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'VendorOrderReviews', 'state'),
            completedAt: completedAt,
            closesAt: closesAt,
            closesAtLabel: closesAtLabel,
            revealed: BuiltValueNullFieldError.checkNotNull(
                revealed, r'VendorOrderReviews', 'revealed'),
            revealedAt: revealedAt,
            revealReason: revealReason,
            withheldForDispute: BuiltValueNullFieldError.checkNotNull(
                withheldForDispute,
                r'VendorOrderReviews',
                'withheldForDispute'),
            rules: rules.build(),
            party: BuiltValueNullFieldError.checkNotNull(
                party, r'VendorOrderReviews', 'party'),
            buyerRating: _buyerRating?.build(),
            canSubmitBuyerRating: BuiltValueNullFieldError.checkNotNull(
                canSubmitBuyerRating,
                r'VendorOrderReviews',
                'canSubmitBuyerRating'),
            received: received.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rules';
        rules.build();

        _$failedField = 'buyerRating';
        _buyerRating?.build();

        _$failedField = 'received';
        received.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorOrderReviews', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
