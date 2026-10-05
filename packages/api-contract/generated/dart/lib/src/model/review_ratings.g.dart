// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_ratings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReviewRatingsSpeedKindEnum _$reviewRatingsSpeedKindEnum_DELIVERY_SPEED =
    const ReviewRatingsSpeedKindEnum._('DELIVERY_SPEED');
const ReviewRatingsSpeedKindEnum _$reviewRatingsSpeedKindEnum_PROCESSING_SPEED =
    const ReviewRatingsSpeedKindEnum._('PROCESSING_SPEED');

ReviewRatingsSpeedKindEnum _$reviewRatingsSpeedKindEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY_SPEED':
      return _$reviewRatingsSpeedKindEnum_DELIVERY_SPEED;
    case 'PROCESSING_SPEED':
      return _$reviewRatingsSpeedKindEnum_PROCESSING_SPEED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReviewRatingsSpeedKindEnum> _$reviewRatingsSpeedKindEnumValues =
    BuiltSet<ReviewRatingsSpeedKindEnum>(const <ReviewRatingsSpeedKindEnum>[
  _$reviewRatingsSpeedKindEnum_DELIVERY_SPEED,
  _$reviewRatingsSpeedKindEnum_PROCESSING_SPEED,
]);

Serializer<ReviewRatingsSpeedKindEnum> _$reviewRatingsSpeedKindEnumSerializer =
    _$ReviewRatingsSpeedKindEnumSerializer();

class _$ReviewRatingsSpeedKindEnumSerializer
    implements PrimitiveSerializer<ReviewRatingsSpeedKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY_SPEED': 'DELIVERY_SPEED',
    'PROCESSING_SPEED': 'PROCESSING_SPEED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY_SPEED': 'DELIVERY_SPEED',
    'PROCESSING_SPEED': 'PROCESSING_SPEED',
  };

  @override
  final Iterable<Type> types = const <Type>[ReviewRatingsSpeedKindEnum];
  @override
  final String wireName = 'ReviewRatingsSpeedKindEnum';

  @override
  Object serialize(Serializers serializers, ReviewRatingsSpeedKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReviewRatingsSpeedKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReviewRatingsSpeedKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReviewRatings extends ReviewRatings {
  @override
  final int? serviceQuality;
  @override
  final int? speedRating;
  @override
  final ReviewRatingsSpeedKindEnum? speedKind;
  @override
  final int? productQuality;
  @override
  final int? inquirySeriousness;
  @override
  final int? communicationQuality;
  @override
  final int? paymentReliability;

  factory _$ReviewRatings([void Function(ReviewRatingsBuilder)? updates]) =>
      (ReviewRatingsBuilder()..update(updates))._build();

  _$ReviewRatings._(
      {this.serviceQuality,
      this.speedRating,
      this.speedKind,
      this.productQuality,
      this.inquirySeriousness,
      this.communicationQuality,
      this.paymentReliability})
      : super._();
  @override
  ReviewRatings rebuild(void Function(ReviewRatingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewRatingsBuilder toBuilder() => ReviewRatingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewRatings &&
        serviceQuality == other.serviceQuality &&
        speedRating == other.speedRating &&
        speedKind == other.speedKind &&
        productQuality == other.productQuality &&
        inquirySeriousness == other.inquirySeriousness &&
        communicationQuality == other.communicationQuality &&
        paymentReliability == other.paymentReliability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, serviceQuality.hashCode);
    _$hash = $jc(_$hash, speedRating.hashCode);
    _$hash = $jc(_$hash, speedKind.hashCode);
    _$hash = $jc(_$hash, productQuality.hashCode);
    _$hash = $jc(_$hash, inquirySeriousness.hashCode);
    _$hash = $jc(_$hash, communicationQuality.hashCode);
    _$hash = $jc(_$hash, paymentReliability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewRatings')
          ..add('serviceQuality', serviceQuality)
          ..add('speedRating', speedRating)
          ..add('speedKind', speedKind)
          ..add('productQuality', productQuality)
          ..add('inquirySeriousness', inquirySeriousness)
          ..add('communicationQuality', communicationQuality)
          ..add('paymentReliability', paymentReliability))
        .toString();
  }
}

class ReviewRatingsBuilder
    implements Builder<ReviewRatings, ReviewRatingsBuilder> {
  _$ReviewRatings? _$v;

  int? _serviceQuality;
  int? get serviceQuality => _$this._serviceQuality;
  set serviceQuality(int? serviceQuality) =>
      _$this._serviceQuality = serviceQuality;

  int? _speedRating;
  int? get speedRating => _$this._speedRating;
  set speedRating(int? speedRating) => _$this._speedRating = speedRating;

  ReviewRatingsSpeedKindEnum? _speedKind;
  ReviewRatingsSpeedKindEnum? get speedKind => _$this._speedKind;
  set speedKind(ReviewRatingsSpeedKindEnum? speedKind) =>
      _$this._speedKind = speedKind;

  int? _productQuality;
  int? get productQuality => _$this._productQuality;
  set productQuality(int? productQuality) =>
      _$this._productQuality = productQuality;

  int? _inquirySeriousness;
  int? get inquirySeriousness => _$this._inquirySeriousness;
  set inquirySeriousness(int? inquirySeriousness) =>
      _$this._inquirySeriousness = inquirySeriousness;

  int? _communicationQuality;
  int? get communicationQuality => _$this._communicationQuality;
  set communicationQuality(int? communicationQuality) =>
      _$this._communicationQuality = communicationQuality;

  int? _paymentReliability;
  int? get paymentReliability => _$this._paymentReliability;
  set paymentReliability(int? paymentReliability) =>
      _$this._paymentReliability = paymentReliability;

  ReviewRatingsBuilder() {
    ReviewRatings._defaults(this);
  }

  ReviewRatingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _serviceQuality = $v.serviceQuality;
      _speedRating = $v.speedRating;
      _speedKind = $v.speedKind;
      _productQuality = $v.productQuality;
      _inquirySeriousness = $v.inquirySeriousness;
      _communicationQuality = $v.communicationQuality;
      _paymentReliability = $v.paymentReliability;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewRatings other) {
    _$v = other as _$ReviewRatings;
  }

  @override
  void update(void Function(ReviewRatingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewRatings build() => _build();

  _$ReviewRatings _build() {
    final _$result = _$v ??
        _$ReviewRatings._(
          serviceQuality: serviceQuality,
          speedRating: speedRating,
          speedKind: speedKind,
          productQuality: productQuality,
          inquirySeriousness: inquirySeriousness,
          communicationQuality: communicationQuality,
          paymentReliability: paymentReliability,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
