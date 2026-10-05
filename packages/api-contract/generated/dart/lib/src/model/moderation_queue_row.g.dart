// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_queue_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ModerationQueueRowTypeEnum _$moderationQueueRowTypeEnum_VENDOR =
    const ModerationQueueRowTypeEnum._('VENDOR');
const ModerationQueueRowTypeEnum _$moderationQueueRowTypeEnum_PRODUCT =
    const ModerationQueueRowTypeEnum._('PRODUCT');
const ModerationQueueRowTypeEnum _$moderationQueueRowTypeEnum_BUYER =
    const ModerationQueueRowTypeEnum._('BUYER');

ModerationQueueRowTypeEnum _$moderationQueueRowTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$moderationQueueRowTypeEnum_VENDOR;
    case 'PRODUCT':
      return _$moderationQueueRowTypeEnum_PRODUCT;
    case 'BUYER':
      return _$moderationQueueRowTypeEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationQueueRowTypeEnum> _$moderationQueueRowTypeEnumValues =
    BuiltSet<ModerationQueueRowTypeEnum>(const <ModerationQueueRowTypeEnum>[
  _$moderationQueueRowTypeEnum_VENDOR,
  _$moderationQueueRowTypeEnum_PRODUCT,
  _$moderationQueueRowTypeEnum_BUYER,
]);

const ModerationQueueRowModerationStateEnum
    _$moderationQueueRowModerationStateEnum_NONE =
    const ModerationQueueRowModerationStateEnum._('NONE');
const ModerationQueueRowModerationStateEnum
    _$moderationQueueRowModerationStateEnum_FLAGGED =
    const ModerationQueueRowModerationStateEnum._('FLAGGED');
const ModerationQueueRowModerationStateEnum
    _$moderationQueueRowModerationStateEnum_HIDDEN_PENDING_REVIEW =
    const ModerationQueueRowModerationStateEnum._('HIDDEN_PENDING_REVIEW');
const ModerationQueueRowModerationStateEnum
    _$moderationQueueRowModerationStateEnum_CORRECTION_REQUESTED =
    const ModerationQueueRowModerationStateEnum._('CORRECTION_REQUESTED');
const ModerationQueueRowModerationStateEnum
    _$moderationQueueRowModerationStateEnum_REMOVED =
    const ModerationQueueRowModerationStateEnum._('REMOVED');

ModerationQueueRowModerationStateEnum
    _$moderationQueueRowModerationStateEnumValueOf(String name) {
  switch (name) {
    case 'NONE':
      return _$moderationQueueRowModerationStateEnum_NONE;
    case 'FLAGGED':
      return _$moderationQueueRowModerationStateEnum_FLAGGED;
    case 'HIDDEN_PENDING_REVIEW':
      return _$moderationQueueRowModerationStateEnum_HIDDEN_PENDING_REVIEW;
    case 'CORRECTION_REQUESTED':
      return _$moderationQueueRowModerationStateEnum_CORRECTION_REQUESTED;
    case 'REMOVED':
      return _$moderationQueueRowModerationStateEnum_REMOVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationQueueRowModerationStateEnum>
    _$moderationQueueRowModerationStateEnumValues = BuiltSet<
        ModerationQueueRowModerationStateEnum>(const <ModerationQueueRowModerationStateEnum>[
  _$moderationQueueRowModerationStateEnum_NONE,
  _$moderationQueueRowModerationStateEnum_FLAGGED,
  _$moderationQueueRowModerationStateEnum_HIDDEN_PENDING_REVIEW,
  _$moderationQueueRowModerationStateEnum_CORRECTION_REQUESTED,
  _$moderationQueueRowModerationStateEnum_REMOVED,
]);

Serializer<ModerationQueueRowTypeEnum> _$moderationQueueRowTypeEnumSerializer =
    _$ModerationQueueRowTypeEnumSerializer();
Serializer<ModerationQueueRowModerationStateEnum>
    _$moderationQueueRowModerationStateEnumSerializer =
    _$ModerationQueueRowModerationStateEnumSerializer();

class _$ModerationQueueRowTypeEnumSerializer
    implements PrimitiveSerializer<ModerationQueueRowTypeEnum> {
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
  final Iterable<Type> types = const <Type>[ModerationQueueRowTypeEnum];
  @override
  final String wireName = 'ModerationQueueRowTypeEnum';

  @override
  Object serialize(Serializers serializers, ModerationQueueRowTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationQueueRowTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationQueueRowTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationQueueRowModerationStateEnumSerializer
    implements PrimitiveSerializer<ModerationQueueRowModerationStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NONE': 'NONE',
    'FLAGGED': 'FLAGGED',
    'HIDDEN_PENDING_REVIEW': 'HIDDEN_PENDING_REVIEW',
    'CORRECTION_REQUESTED': 'CORRECTION_REQUESTED',
    'REMOVED': 'REMOVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NONE': 'NONE',
    'FLAGGED': 'FLAGGED',
    'HIDDEN_PENDING_REVIEW': 'HIDDEN_PENDING_REVIEW',
    'CORRECTION_REQUESTED': 'CORRECTION_REQUESTED',
    'REMOVED': 'REMOVED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ModerationQueueRowModerationStateEnum
  ];
  @override
  final String wireName = 'ModerationQueueRowModerationStateEnum';

  @override
  Object serialize(
          Serializers serializers, ModerationQueueRowModerationStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationQueueRowModerationStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationQueueRowModerationStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationQueueRow extends ModerationQueueRow {
  @override
  final String id;
  @override
  final ModerationQueueRowTypeEnum type;
  @override
  final ModerationQueueRowModerationStateEnum moderationState;
  @override
  final String orderReference;
  @override
  final String storeName;
  @override
  final String displayName;
  @override
  final ReviewRatings ratings;
  @override
  final String? comment;
  @override
  final int openFlags;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? updatedAt;

  factory _$ModerationQueueRow(
          [void Function(ModerationQueueRowBuilder)? updates]) =>
      (ModerationQueueRowBuilder()..update(updates))._build();

  _$ModerationQueueRow._(
      {required this.id,
      required this.type,
      required this.moderationState,
      required this.orderReference,
      required this.storeName,
      required this.displayName,
      required this.ratings,
      this.comment,
      required this.openFlags,
      this.submittedAt,
      this.updatedAt})
      : super._();
  @override
  ModerationQueueRow rebuild(
          void Function(ModerationQueueRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModerationQueueRowBuilder toBuilder() =>
      ModerationQueueRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModerationQueueRow &&
        id == other.id &&
        type == other.type &&
        moderationState == other.moderationState &&
        orderReference == other.orderReference &&
        storeName == other.storeName &&
        displayName == other.displayName &&
        ratings == other.ratings &&
        comment == other.comment &&
        openFlags == other.openFlags &&
        submittedAt == other.submittedAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, moderationState.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, openFlags.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModerationQueueRow')
          ..add('id', id)
          ..add('type', type)
          ..add('moderationState', moderationState)
          ..add('orderReference', orderReference)
          ..add('storeName', storeName)
          ..add('displayName', displayName)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('openFlags', openFlags)
          ..add('submittedAt', submittedAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ModerationQueueRowBuilder
    implements Builder<ModerationQueueRow, ModerationQueueRowBuilder> {
  _$ModerationQueueRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ModerationQueueRowTypeEnum? _type;
  ModerationQueueRowTypeEnum? get type => _$this._type;
  set type(ModerationQueueRowTypeEnum? type) => _$this._type = type;

  ModerationQueueRowModerationStateEnum? _moderationState;
  ModerationQueueRowModerationStateEnum? get moderationState =>
      _$this._moderationState;
  set moderationState(ModerationQueueRowModerationStateEnum? moderationState) =>
      _$this._moderationState = moderationState;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  ReviewRatingsBuilder? _ratings;
  ReviewRatingsBuilder get ratings =>
      _$this._ratings ??= ReviewRatingsBuilder();
  set ratings(ReviewRatingsBuilder? ratings) => _$this._ratings = ratings;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  int? _openFlags;
  int? get openFlags => _$this._openFlags;
  set openFlags(int? openFlags) => _$this._openFlags = openFlags;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ModerationQueueRowBuilder() {
    ModerationQueueRow._defaults(this);
  }

  ModerationQueueRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _moderationState = $v.moderationState;
      _orderReference = $v.orderReference;
      _storeName = $v.storeName;
      _displayName = $v.displayName;
      _ratings = $v.ratings.toBuilder();
      _comment = $v.comment;
      _openFlags = $v.openFlags;
      _submittedAt = $v.submittedAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModerationQueueRow other) {
    _$v = other as _$ModerationQueueRow;
  }

  @override
  void update(void Function(ModerationQueueRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModerationQueueRow build() => _build();

  _$ModerationQueueRow _build() {
    _$ModerationQueueRow _$result;
    try {
      _$result = _$v ??
          _$ModerationQueueRow._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ModerationQueueRow', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ModerationQueueRow', 'type'),
            moderationState: BuiltValueNullFieldError.checkNotNull(
                moderationState, r'ModerationQueueRow', 'moderationState'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'ModerationQueueRow', 'orderReference'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'ModerationQueueRow', 'storeName'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ModerationQueueRow', 'displayName'),
            ratings: ratings.build(),
            comment: comment,
            openFlags: BuiltValueNullFieldError.checkNotNull(
                openFlags, r'ModerationQueueRow', 'openFlags'),
            submittedAt: submittedAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        ratings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ModerationQueueRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
