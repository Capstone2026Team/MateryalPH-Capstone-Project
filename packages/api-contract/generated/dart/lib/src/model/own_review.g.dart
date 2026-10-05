// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OwnReviewTypeEnum _$ownReviewTypeEnum_VENDOR =
    const OwnReviewTypeEnum._('VENDOR');
const OwnReviewTypeEnum _$ownReviewTypeEnum_PRODUCT =
    const OwnReviewTypeEnum._('PRODUCT');
const OwnReviewTypeEnum _$ownReviewTypeEnum_BUYER =
    const OwnReviewTypeEnum._('BUYER');

OwnReviewTypeEnum _$ownReviewTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$ownReviewTypeEnum_VENDOR;
    case 'PRODUCT':
      return _$ownReviewTypeEnum_PRODUCT;
    case 'BUYER':
      return _$ownReviewTypeEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OwnReviewTypeEnum> _$ownReviewTypeEnumValues =
    BuiltSet<OwnReviewTypeEnum>(const <OwnReviewTypeEnum>[
  _$ownReviewTypeEnum_VENDOR,
  _$ownReviewTypeEnum_PRODUCT,
  _$ownReviewTypeEnum_BUYER,
]);

const OwnReviewVisibilityEnum _$ownReviewVisibilityEnum_PUBLIC =
    const OwnReviewVisibilityEnum._('PUBLIC');
const OwnReviewVisibilityEnum _$ownReviewVisibilityEnum_HIDDEN_UNTIL_REVEAL =
    const OwnReviewVisibilityEnum._('HIDDEN_UNTIL_REVEAL');
const OwnReviewVisibilityEnum
    _$ownReviewVisibilityEnum_WITHHELD_ACTIVE_DISPUTE =
    const OwnReviewVisibilityEnum._('WITHHELD_ACTIVE_DISPUTE');
const OwnReviewVisibilityEnum _$ownReviewVisibilityEnum_HIDDEN_BY_MODERATION =
    const OwnReviewVisibilityEnum._('HIDDEN_BY_MODERATION');
const OwnReviewVisibilityEnum _$ownReviewVisibilityEnum_REMOVED =
    const OwnReviewVisibilityEnum._('REMOVED');
const OwnReviewVisibilityEnum
    _$ownReviewVisibilityEnum_EXCLUDED_BY_INVESTIGATION =
    const OwnReviewVisibilityEnum._('EXCLUDED_BY_INVESTIGATION');

OwnReviewVisibilityEnum _$ownReviewVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'PUBLIC':
      return _$ownReviewVisibilityEnum_PUBLIC;
    case 'HIDDEN_UNTIL_REVEAL':
      return _$ownReviewVisibilityEnum_HIDDEN_UNTIL_REVEAL;
    case 'WITHHELD_ACTIVE_DISPUTE':
      return _$ownReviewVisibilityEnum_WITHHELD_ACTIVE_DISPUTE;
    case 'HIDDEN_BY_MODERATION':
      return _$ownReviewVisibilityEnum_HIDDEN_BY_MODERATION;
    case 'REMOVED':
      return _$ownReviewVisibilityEnum_REMOVED;
    case 'EXCLUDED_BY_INVESTIGATION':
      return _$ownReviewVisibilityEnum_EXCLUDED_BY_INVESTIGATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OwnReviewVisibilityEnum> _$ownReviewVisibilityEnumValues =
    BuiltSet<OwnReviewVisibilityEnum>(const <OwnReviewVisibilityEnum>[
  _$ownReviewVisibilityEnum_PUBLIC,
  _$ownReviewVisibilityEnum_HIDDEN_UNTIL_REVEAL,
  _$ownReviewVisibilityEnum_WITHHELD_ACTIVE_DISPUTE,
  _$ownReviewVisibilityEnum_HIDDEN_BY_MODERATION,
  _$ownReviewVisibilityEnum_REMOVED,
  _$ownReviewVisibilityEnum_EXCLUDED_BY_INVESTIGATION,
]);

Serializer<OwnReviewTypeEnum> _$ownReviewTypeEnumSerializer =
    _$OwnReviewTypeEnumSerializer();
Serializer<OwnReviewVisibilityEnum> _$ownReviewVisibilityEnumSerializer =
    _$OwnReviewVisibilityEnumSerializer();

class _$OwnReviewTypeEnumSerializer
    implements PrimitiveSerializer<OwnReviewTypeEnum> {
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
  final Iterable<Type> types = const <Type>[OwnReviewTypeEnum];
  @override
  final String wireName = 'OwnReviewTypeEnum';

  @override
  Object serialize(Serializers serializers, OwnReviewTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OwnReviewTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OwnReviewTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OwnReviewVisibilityEnumSerializer
    implements PrimitiveSerializer<OwnReviewVisibilityEnum> {
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
  final Iterable<Type> types = const <Type>[OwnReviewVisibilityEnum];
  @override
  final String wireName = 'OwnReviewVisibilityEnum';

  @override
  Object serialize(Serializers serializers, OwnReviewVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OwnReviewVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OwnReviewVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OwnReview extends OwnReview {
  @override
  final String id;
  @override
  final OwnReviewTypeEnum type;
  @override
  final ReviewRatings ratings;
  @override
  final String? comment;
  @override
  final String displayName;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? editableUntil;
  @override
  final String? editableUntilLabel;
  @override
  final bool canEdit;
  @override
  final bool correctionRequested;
  @override
  final DateTime? correctionDueAt;
  @override
  final OwnReviewVisibilityEnum visibility;
  @override
  final int revision;
  @override
  final int lockVersion;
  @override
  final BuiltList<ReviewMediaLink> media;

  factory _$OwnReview([void Function(OwnReviewBuilder)? updates]) =>
      (OwnReviewBuilder()..update(updates))._build();

  _$OwnReview._(
      {required this.id,
      required this.type,
      required this.ratings,
      this.comment,
      required this.displayName,
      this.submittedAt,
      this.editableUntil,
      this.editableUntilLabel,
      required this.canEdit,
      required this.correctionRequested,
      this.correctionDueAt,
      required this.visibility,
      required this.revision,
      required this.lockVersion,
      required this.media})
      : super._();
  @override
  OwnReview rebuild(void Function(OwnReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OwnReviewBuilder toBuilder() => OwnReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OwnReview &&
        id == other.id &&
        type == other.type &&
        ratings == other.ratings &&
        comment == other.comment &&
        displayName == other.displayName &&
        submittedAt == other.submittedAt &&
        editableUntil == other.editableUntil &&
        editableUntilLabel == other.editableUntilLabel &&
        canEdit == other.canEdit &&
        correctionRequested == other.correctionRequested &&
        correctionDueAt == other.correctionDueAt &&
        visibility == other.visibility &&
        revision == other.revision &&
        lockVersion == other.lockVersion &&
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
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, editableUntil.hashCode);
    _$hash = $jc(_$hash, editableUntilLabel.hashCode);
    _$hash = $jc(_$hash, canEdit.hashCode);
    _$hash = $jc(_$hash, correctionRequested.hashCode);
    _$hash = $jc(_$hash, correctionDueAt.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OwnReview')
          ..add('id', id)
          ..add('type', type)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('displayName', displayName)
          ..add('submittedAt', submittedAt)
          ..add('editableUntil', editableUntil)
          ..add('editableUntilLabel', editableUntilLabel)
          ..add('canEdit', canEdit)
          ..add('correctionRequested', correctionRequested)
          ..add('correctionDueAt', correctionDueAt)
          ..add('visibility', visibility)
          ..add('revision', revision)
          ..add('lockVersion', lockVersion)
          ..add('media', media))
        .toString();
  }
}

class OwnReviewBuilder implements Builder<OwnReview, OwnReviewBuilder> {
  _$OwnReview? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  OwnReviewTypeEnum? _type;
  OwnReviewTypeEnum? get type => _$this._type;
  set type(OwnReviewTypeEnum? type) => _$this._type = type;

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

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _editableUntil;
  DateTime? get editableUntil => _$this._editableUntil;
  set editableUntil(DateTime? editableUntil) =>
      _$this._editableUntil = editableUntil;

  String? _editableUntilLabel;
  String? get editableUntilLabel => _$this._editableUntilLabel;
  set editableUntilLabel(String? editableUntilLabel) =>
      _$this._editableUntilLabel = editableUntilLabel;

  bool? _canEdit;
  bool? get canEdit => _$this._canEdit;
  set canEdit(bool? canEdit) => _$this._canEdit = canEdit;

  bool? _correctionRequested;
  bool? get correctionRequested => _$this._correctionRequested;
  set correctionRequested(bool? correctionRequested) =>
      _$this._correctionRequested = correctionRequested;

  DateTime? _correctionDueAt;
  DateTime? get correctionDueAt => _$this._correctionDueAt;
  set correctionDueAt(DateTime? correctionDueAt) =>
      _$this._correctionDueAt = correctionDueAt;

  OwnReviewVisibilityEnum? _visibility;
  OwnReviewVisibilityEnum? get visibility => _$this._visibility;
  set visibility(OwnReviewVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ListBuilder<ReviewMediaLink>? _media;
  ListBuilder<ReviewMediaLink> get media =>
      _$this._media ??= ListBuilder<ReviewMediaLink>();
  set media(ListBuilder<ReviewMediaLink>? media) => _$this._media = media;

  OwnReviewBuilder() {
    OwnReview._defaults(this);
  }

  OwnReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _ratings = $v.ratings.toBuilder();
      _comment = $v.comment;
      _displayName = $v.displayName;
      _submittedAt = $v.submittedAt;
      _editableUntil = $v.editableUntil;
      _editableUntilLabel = $v.editableUntilLabel;
      _canEdit = $v.canEdit;
      _correctionRequested = $v.correctionRequested;
      _correctionDueAt = $v.correctionDueAt;
      _visibility = $v.visibility;
      _revision = $v.revision;
      _lockVersion = $v.lockVersion;
      _media = $v.media.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OwnReview other) {
    _$v = other as _$OwnReview;
  }

  @override
  void update(void Function(OwnReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OwnReview build() => _build();

  _$OwnReview _build() {
    _$OwnReview _$result;
    try {
      _$result = _$v ??
          _$OwnReview._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'OwnReview', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'OwnReview', 'type'),
            ratings: ratings.build(),
            comment: comment,
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'OwnReview', 'displayName'),
            submittedAt: submittedAt,
            editableUntil: editableUntil,
            editableUntilLabel: editableUntilLabel,
            canEdit: BuiltValueNullFieldError.checkNotNull(
                canEdit, r'OwnReview', 'canEdit'),
            correctionRequested: BuiltValueNullFieldError.checkNotNull(
                correctionRequested, r'OwnReview', 'correctionRequested'),
            correctionDueAt: correctionDueAt,
            visibility: BuiltValueNullFieldError.checkNotNull(
                visibility, r'OwnReview', 'visibility'),
            revision: BuiltValueNullFieldError.checkNotNull(
                revision, r'OwnReview', 'revision'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'OwnReview', 'lockVersion'),
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
            r'OwnReview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
