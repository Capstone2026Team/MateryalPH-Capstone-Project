// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorReviewRowTypeEnum _$vendorReviewRowTypeEnum_VENDOR =
    const VendorReviewRowTypeEnum._('VENDOR');
const VendorReviewRowTypeEnum _$vendorReviewRowTypeEnum_PRODUCT =
    const VendorReviewRowTypeEnum._('PRODUCT');
const VendorReviewRowTypeEnum _$vendorReviewRowTypeEnum_BUYER =
    const VendorReviewRowTypeEnum._('BUYER');

VendorReviewRowTypeEnum _$vendorReviewRowTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$vendorReviewRowTypeEnum_VENDOR;
    case 'PRODUCT':
      return _$vendorReviewRowTypeEnum_PRODUCT;
    case 'BUYER':
      return _$vendorReviewRowTypeEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorReviewRowTypeEnum> _$vendorReviewRowTypeEnumValues =
    BuiltSet<VendorReviewRowTypeEnum>(const <VendorReviewRowTypeEnum>[
  _$vendorReviewRowTypeEnum_VENDOR,
  _$vendorReviewRowTypeEnum_PRODUCT,
  _$vendorReviewRowTypeEnum_BUYER,
]);

const VendorReviewRowVisibilityEnum _$vendorReviewRowVisibilityEnum_PUBLIC =
    const VendorReviewRowVisibilityEnum._('PUBLIC');
const VendorReviewRowVisibilityEnum
    _$vendorReviewRowVisibilityEnum_HIDDEN_UNTIL_REVEAL =
    const VendorReviewRowVisibilityEnum._('HIDDEN_UNTIL_REVEAL');
const VendorReviewRowVisibilityEnum
    _$vendorReviewRowVisibilityEnum_WITHHELD_ACTIVE_DISPUTE =
    const VendorReviewRowVisibilityEnum._('WITHHELD_ACTIVE_DISPUTE');
const VendorReviewRowVisibilityEnum
    _$vendorReviewRowVisibilityEnum_HIDDEN_BY_MODERATION =
    const VendorReviewRowVisibilityEnum._('HIDDEN_BY_MODERATION');
const VendorReviewRowVisibilityEnum _$vendorReviewRowVisibilityEnum_REMOVED =
    const VendorReviewRowVisibilityEnum._('REMOVED');
const VendorReviewRowVisibilityEnum
    _$vendorReviewRowVisibilityEnum_EXCLUDED_BY_INVESTIGATION =
    const VendorReviewRowVisibilityEnum._('EXCLUDED_BY_INVESTIGATION');

VendorReviewRowVisibilityEnum _$vendorReviewRowVisibilityEnumValueOf(
    String name) {
  switch (name) {
    case 'PUBLIC':
      return _$vendorReviewRowVisibilityEnum_PUBLIC;
    case 'HIDDEN_UNTIL_REVEAL':
      return _$vendorReviewRowVisibilityEnum_HIDDEN_UNTIL_REVEAL;
    case 'WITHHELD_ACTIVE_DISPUTE':
      return _$vendorReviewRowVisibilityEnum_WITHHELD_ACTIVE_DISPUTE;
    case 'HIDDEN_BY_MODERATION':
      return _$vendorReviewRowVisibilityEnum_HIDDEN_BY_MODERATION;
    case 'REMOVED':
      return _$vendorReviewRowVisibilityEnum_REMOVED;
    case 'EXCLUDED_BY_INVESTIGATION':
      return _$vendorReviewRowVisibilityEnum_EXCLUDED_BY_INVESTIGATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorReviewRowVisibilityEnum>
    _$vendorReviewRowVisibilityEnumValues = BuiltSet<
        VendorReviewRowVisibilityEnum>(const <VendorReviewRowVisibilityEnum>[
  _$vendorReviewRowVisibilityEnum_PUBLIC,
  _$vendorReviewRowVisibilityEnum_HIDDEN_UNTIL_REVEAL,
  _$vendorReviewRowVisibilityEnum_WITHHELD_ACTIVE_DISPUTE,
  _$vendorReviewRowVisibilityEnum_HIDDEN_BY_MODERATION,
  _$vendorReviewRowVisibilityEnum_REMOVED,
  _$vendorReviewRowVisibilityEnum_EXCLUDED_BY_INVESTIGATION,
]);

Serializer<VendorReviewRowTypeEnum> _$vendorReviewRowTypeEnumSerializer =
    _$VendorReviewRowTypeEnumSerializer();
Serializer<VendorReviewRowVisibilityEnum>
    _$vendorReviewRowVisibilityEnumSerializer =
    _$VendorReviewRowVisibilityEnumSerializer();

class _$VendorReviewRowTypeEnumSerializer
    implements PrimitiveSerializer<VendorReviewRowTypeEnum> {
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
  final Iterable<Type> types = const <Type>[VendorReviewRowTypeEnum];
  @override
  final String wireName = 'VendorReviewRowTypeEnum';

  @override
  Object serialize(Serializers serializers, VendorReviewRowTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorReviewRowTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorReviewRowTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorReviewRowVisibilityEnumSerializer
    implements PrimitiveSerializer<VendorReviewRowVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PUBLIC': 'PUBLIC',
    'HIDDEN_UNTIL_REVEAL': 'HIDDEN_UNTIL_REVEAL',
    'WITHHELD_ACTIVE_DISPUTE': 'WITHHELD_ACTIVE_DISPUTE',
    'HIDDEN_BY_MODERATION': 'HIDDEN_BY_MODERATION',
    'REMOVED': 'REMOVED',
    'EXCLUDED_BY_INVESTIGATION': 'EXCLUDED_BY_INVESTIGATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PUBLIC': 'PUBLIC',
    'HIDDEN_UNTIL_REVEAL': 'HIDDEN_UNTIL_REVEAL',
    'WITHHELD_ACTIVE_DISPUTE': 'WITHHELD_ACTIVE_DISPUTE',
    'HIDDEN_BY_MODERATION': 'HIDDEN_BY_MODERATION',
    'REMOVED': 'REMOVED',
    'EXCLUDED_BY_INVESTIGATION': 'EXCLUDED_BY_INVESTIGATION',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorReviewRowVisibilityEnum];
  @override
  final String wireName = 'VendorReviewRowVisibilityEnum';

  @override
  Object serialize(
          Serializers serializers, VendorReviewRowVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorReviewRowVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorReviewRowVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorReviewRow extends VendorReviewRow {
  @override
  final String? id;
  @override
  final VendorReviewRowTypeEnum? type;
  @override
  final ReviewRatings? ratings;
  @override
  final String? comment;
  @override
  final String? displayName;
  @override
  final bool? verifiedPurchase;
  @override
  final DateTime? submittedAt;
  @override
  final bool? edited;
  @override
  final String? variantLabel;
  @override
  final BuiltList<ReviewMediaLink>? media;
  @override
  final VendorReviewRowVisibilityEnum? visibility;
  @override
  final String? orderId;
  @override
  final String? orderReference;
  @override
  final bool? canReport;

  factory _$VendorReviewRow([void Function(VendorReviewRowBuilder)? updates]) =>
      (VendorReviewRowBuilder()..update(updates))._build();

  _$VendorReviewRow._(
      {this.id,
      this.type,
      this.ratings,
      this.comment,
      this.displayName,
      this.verifiedPurchase,
      this.submittedAt,
      this.edited,
      this.variantLabel,
      this.media,
      this.visibility,
      this.orderId,
      this.orderReference,
      this.canReport})
      : super._();
  @override
  VendorReviewRow rebuild(void Function(VendorReviewRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorReviewRowBuilder toBuilder() => VendorReviewRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorReviewRow &&
        id == other.id &&
        type == other.type &&
        ratings == other.ratings &&
        comment == other.comment &&
        displayName == other.displayName &&
        verifiedPurchase == other.verifiedPurchase &&
        submittedAt == other.submittedAt &&
        edited == other.edited &&
        variantLabel == other.variantLabel &&
        media == other.media &&
        visibility == other.visibility &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        canReport == other.canReport;
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
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, canReport.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorReviewRow')
          ..add('id', id)
          ..add('type', type)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('displayName', displayName)
          ..add('verifiedPurchase', verifiedPurchase)
          ..add('submittedAt', submittedAt)
          ..add('edited', edited)
          ..add('variantLabel', variantLabel)
          ..add('media', media)
          ..add('visibility', visibility)
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('canReport', canReport))
        .toString();
  }
}

class VendorReviewRowBuilder
    implements Builder<VendorReviewRow, VendorReviewRowBuilder> {
  _$VendorReviewRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  VendorReviewRowTypeEnum? _type;
  VendorReviewRowTypeEnum? get type => _$this._type;
  set type(VendorReviewRowTypeEnum? type) => _$this._type = type;

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

  VendorReviewRowVisibilityEnum? _visibility;
  VendorReviewRowVisibilityEnum? get visibility => _$this._visibility;
  set visibility(VendorReviewRowVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  bool? _canReport;
  bool? get canReport => _$this._canReport;
  set canReport(bool? canReport) => _$this._canReport = canReport;

  VendorReviewRowBuilder() {
    VendorReviewRow._defaults(this);
  }

  VendorReviewRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _ratings = $v.ratings?.toBuilder();
      _comment = $v.comment;
      _displayName = $v.displayName;
      _verifiedPurchase = $v.verifiedPurchase;
      _submittedAt = $v.submittedAt;
      _edited = $v.edited;
      _variantLabel = $v.variantLabel;
      _media = $v.media?.toBuilder();
      _visibility = $v.visibility;
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _canReport = $v.canReport;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorReviewRow other) {
    _$v = other as _$VendorReviewRow;
  }

  @override
  void update(void Function(VendorReviewRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorReviewRow build() => _build();

  _$VendorReviewRow _build() {
    _$VendorReviewRow _$result;
    try {
      _$result = _$v ??
          _$VendorReviewRow._(
            id: id,
            type: type,
            ratings: _ratings?.build(),
            comment: comment,
            displayName: displayName,
            verifiedPurchase: verifiedPurchase,
            submittedAt: submittedAt,
            edited: edited,
            variantLabel: variantLabel,
            media: _media?.build(),
            visibility: visibility,
            orderId: orderId,
            orderReference: orderReference,
            canReport: canReport,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        _ratings?.build();

        _$failedField = 'media';
        _media?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorReviewRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
