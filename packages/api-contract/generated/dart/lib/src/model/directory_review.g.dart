// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryReviewTypeEnum _$directoryReviewTypeEnum_VENDOR =
    const DirectoryReviewTypeEnum._('VENDOR');
const DirectoryReviewTypeEnum _$directoryReviewTypeEnum_PRODUCT =
    const DirectoryReviewTypeEnum._('PRODUCT');
const DirectoryReviewTypeEnum _$directoryReviewTypeEnum_BUYER =
    const DirectoryReviewTypeEnum._('BUYER');

DirectoryReviewTypeEnum _$directoryReviewTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$directoryReviewTypeEnum_VENDOR;
    case 'PRODUCT':
      return _$directoryReviewTypeEnum_PRODUCT;
    case 'BUYER':
      return _$directoryReviewTypeEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryReviewTypeEnum> _$directoryReviewTypeEnumValues =
    BuiltSet<DirectoryReviewTypeEnum>(const <DirectoryReviewTypeEnum>[
  _$directoryReviewTypeEnum_VENDOR,
  _$directoryReviewTypeEnum_PRODUCT,
  _$directoryReviewTypeEnum_BUYER,
]);

Serializer<DirectoryReviewTypeEnum> _$directoryReviewTypeEnumSerializer =
    _$DirectoryReviewTypeEnumSerializer();

class _$DirectoryReviewTypeEnumSerializer
    implements PrimitiveSerializer<DirectoryReviewTypeEnum> {
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
  final Iterable<Type> types = const <Type>[DirectoryReviewTypeEnum];
  @override
  final String wireName = 'DirectoryReviewTypeEnum';

  @override
  Object serialize(Serializers serializers, DirectoryReviewTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryReviewTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryReviewTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryReview extends DirectoryReview {
  @override
  final String id;
  @override
  final DirectoryReviewTypeEnum type;
  @override
  final BuiltMap<String, DirectoryReviewRatingsValue?> ratings;
  @override
  final String? comment;
  @override
  final String authorName;
  @override
  final String orderReference;
  @override
  final String storeName;
  @override
  final String? productName;
  @override
  final String moderationState;
  @override
  final String visibility;
  @override
  final DateTime submittedAt;

  factory _$DirectoryReview([void Function(DirectoryReviewBuilder)? updates]) =>
      (DirectoryReviewBuilder()..update(updates))._build();

  _$DirectoryReview._(
      {required this.id,
      required this.type,
      required this.ratings,
      this.comment,
      required this.authorName,
      required this.orderReference,
      required this.storeName,
      this.productName,
      required this.moderationState,
      required this.visibility,
      required this.submittedAt})
      : super._();
  @override
  DirectoryReview rebuild(void Function(DirectoryReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryReviewBuilder toBuilder() => DirectoryReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryReview &&
        id == other.id &&
        type == other.type &&
        ratings == other.ratings &&
        comment == other.comment &&
        authorName == other.authorName &&
        orderReference == other.orderReference &&
        storeName == other.storeName &&
        productName == other.productName &&
        moderationState == other.moderationState &&
        visibility == other.visibility &&
        submittedAt == other.submittedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, authorName.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, moderationState.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryReview')
          ..add('id', id)
          ..add('type', type)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('authorName', authorName)
          ..add('orderReference', orderReference)
          ..add('storeName', storeName)
          ..add('productName', productName)
          ..add('moderationState', moderationState)
          ..add('visibility', visibility)
          ..add('submittedAt', submittedAt))
        .toString();
  }
}

class DirectoryReviewBuilder
    implements Builder<DirectoryReview, DirectoryReviewBuilder> {
  _$DirectoryReview? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DirectoryReviewTypeEnum? _type;
  DirectoryReviewTypeEnum? get type => _$this._type;
  set type(DirectoryReviewTypeEnum? type) => _$this._type = type;

  MapBuilder<String, DirectoryReviewRatingsValue?>? _ratings;
  MapBuilder<String, DirectoryReviewRatingsValue?> get ratings =>
      _$this._ratings ??= MapBuilder<String, DirectoryReviewRatingsValue?>();
  set ratings(MapBuilder<String, DirectoryReviewRatingsValue?>? ratings) =>
      _$this._ratings = ratings;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  String? _authorName;
  String? get authorName => _$this._authorName;
  set authorName(String? authorName) => _$this._authorName = authorName;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  String? _moderationState;
  String? get moderationState => _$this._moderationState;
  set moderationState(String? moderationState) =>
      _$this._moderationState = moderationState;

  String? _visibility;
  String? get visibility => _$this._visibility;
  set visibility(String? visibility) => _$this._visibility = visibility;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DirectoryReviewBuilder() {
    DirectoryReview._defaults(this);
  }

  DirectoryReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _ratings = $v.ratings.toBuilder();
      _comment = $v.comment;
      _authorName = $v.authorName;
      _orderReference = $v.orderReference;
      _storeName = $v.storeName;
      _productName = $v.productName;
      _moderationState = $v.moderationState;
      _visibility = $v.visibility;
      _submittedAt = $v.submittedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryReview other) {
    _$v = other as _$DirectoryReview;
  }

  @override
  void update(void Function(DirectoryReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryReview build() => _build();

  _$DirectoryReview _build() {
    _$DirectoryReview _$result;
    try {
      _$result = _$v ??
          _$DirectoryReview._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DirectoryReview', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'DirectoryReview', 'type'),
            ratings: ratings.build(),
            comment: comment,
            authorName: BuiltValueNullFieldError.checkNotNull(
                authorName, r'DirectoryReview', 'authorName'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'DirectoryReview', 'orderReference'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'DirectoryReview', 'storeName'),
            productName: productName,
            moderationState: BuiltValueNullFieldError.checkNotNull(
                moderationState, r'DirectoryReview', 'moderationState'),
            visibility: BuiltValueNullFieldError.checkNotNull(
                visibility, r'DirectoryReview', 'visibility'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt, r'DirectoryReview', 'submittedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        ratings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryReview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
