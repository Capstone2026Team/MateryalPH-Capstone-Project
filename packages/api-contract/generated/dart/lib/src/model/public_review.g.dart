// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicReviewTypeEnum _$publicReviewTypeEnum_VENDOR =
    const PublicReviewTypeEnum._('VENDOR');
const PublicReviewTypeEnum _$publicReviewTypeEnum_PRODUCT =
    const PublicReviewTypeEnum._('PRODUCT');
const PublicReviewTypeEnum _$publicReviewTypeEnum_BUYER =
    const PublicReviewTypeEnum._('BUYER');

PublicReviewTypeEnum _$publicReviewTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$publicReviewTypeEnum_VENDOR;
    case 'PRODUCT':
      return _$publicReviewTypeEnum_PRODUCT;
    case 'BUYER':
      return _$publicReviewTypeEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicReviewTypeEnum> _$publicReviewTypeEnumValues =
    BuiltSet<PublicReviewTypeEnum>(const <PublicReviewTypeEnum>[
  _$publicReviewTypeEnum_VENDOR,
  _$publicReviewTypeEnum_PRODUCT,
  _$publicReviewTypeEnum_BUYER,
]);

Serializer<PublicReviewTypeEnum> _$publicReviewTypeEnumSerializer =
    _$PublicReviewTypeEnumSerializer();

class _$PublicReviewTypeEnumSerializer
    implements PrimitiveSerializer<PublicReviewTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'PRODUCT': 'PRODUCT',
    'BUYER': 'BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'PRODUCT': 'PRODUCT',
    'BUYER': 'BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[PublicReviewTypeEnum];
  @override
  final String wireName = 'PublicReviewTypeEnum';

  @override
  Object serialize(Serializers serializers, PublicReviewTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicReviewTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicReviewTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicReview extends PublicReview {
  @override
  final String id;
  @override
  final PublicReviewTypeEnum type;
  @override
  final ReviewRatings ratings;
  @override
  final String? comment;
  @override
  final String displayName;
  @override
  final bool verifiedPurchase;
  @override
  final DateTime? submittedAt;
  @override
  final bool edited;
  @override
  final String? variantLabel;
  @override
  final BuiltList<ReviewMediaLink> media;

  factory _$PublicReview([void Function(PublicReviewBuilder)? updates]) =>
      (PublicReviewBuilder()..update(updates))._build();

  _$PublicReview._(
      {required this.id,
      required this.type,
      required this.ratings,
      this.comment,
      required this.displayName,
      required this.verifiedPurchase,
      this.submittedAt,
      required this.edited,
      this.variantLabel,
      required this.media})
      : super._();
  @override
  PublicReview rebuild(void Function(PublicReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicReviewBuilder toBuilder() => PublicReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicReview &&
        id == other.id &&
        type == other.type &&
        ratings == other.ratings &&
        comment == other.comment &&
        displayName == other.displayName &&
        verifiedPurchase == other.verifiedPurchase &&
        submittedAt == other.submittedAt &&
        edited == other.edited &&
        variantLabel == other.variantLabel &&
        media == other.media;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, verifiedPurchase.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, edited.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicReview')
          ..add('id', id)
          ..add('type', type)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('displayName', displayName)
          ..add('verifiedPurchase', verifiedPurchase)
          ..add('submittedAt', submittedAt)
          ..add('edited', edited)
          ..add('variantLabel', variantLabel)
          ..add('media', media))
        .toString();
  }
}

class PublicReviewBuilder
    implements Builder<PublicReview, PublicReviewBuilder> {
  _$PublicReview? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PublicReviewTypeEnum? _type;
  PublicReviewTypeEnum? get type => _$this._type;
  set type(PublicReviewTypeEnum? type) => _$this._type = type;

  ReviewRatingsBuilder? _ratings;
  ReviewRatingsBuilder get ratings =>
      _$this._ratings ??= ReviewRatingsBuilder();
  set ratings(ReviewRatingsBuilder? ratings) => _$this._ratings = ratings;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  bool? _verifiedPurchase;
  bool? get verifiedPurchase => _$this._verifiedPurchase;
  set verifiedPurchase(bool? verifiedPurchase) =>
      _$this._verifiedPurchase = verifiedPurchase;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  bool? _edited;
  bool? get edited => _$this._edited;
  set edited(bool? edited) => _$this._edited = edited;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  ListBuilder<ReviewMediaLink>? _media;
  ListBuilder<ReviewMediaLink> get media =>
      _$this._media ??= ListBuilder<ReviewMediaLink>();
  set media(ListBuilder<ReviewMediaLink>? media) => _$this._media = media;

  PublicReviewBuilder() {
    PublicReview._defaults(this);
  }

  PublicReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _ratings = $v.ratings.toBuilder();
      _comment = $v.comment;
      _displayName = $v.displayName;
      _verifiedPurchase = $v.verifiedPurchase;
      _submittedAt = $v.submittedAt;
      _edited = $v.edited;
      _variantLabel = $v.variantLabel;
      _media = $v.media.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicReview other) {
    _$v = other as _$PublicReview;
  }

  @override
  void update(void Function(PublicReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicReview build() => _build();

  _$PublicReview _build() {
    _$PublicReview _$result;
    try {
      _$result = _$v ??
          _$PublicReview._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PublicReview', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'PublicReview', 'type'),
            ratings: ratings.build(),
            comment: comment,
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'PublicReview', 'displayName'),
            verifiedPurchase: BuiltValueNullFieldError.checkNotNull(
                verifiedPurchase, r'PublicReview', 'verifiedPurchase'),
            submittedAt: submittedAt,
            edited: BuiltValueNullFieldError.checkNotNull(
                edited, r'PublicReview', 'edited'),
            variantLabel: variantLabel,
            media: media.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        ratings.build();

        _$failedField = 'media';
        media.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicReview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
