// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ModerationDetailModerationStateEnum
    _$moderationDetailModerationStateEnum_NONE =
    const ModerationDetailModerationStateEnum._('NONE');
const ModerationDetailModerationStateEnum
    _$moderationDetailModerationStateEnum_FLAGGED =
    const ModerationDetailModerationStateEnum._('FLAGGED');
const ModerationDetailModerationStateEnum
    _$moderationDetailModerationStateEnum_HIDDEN_PENDING_REVIEW =
    const ModerationDetailModerationStateEnum._('HIDDEN_PENDING_REVIEW');
const ModerationDetailModerationStateEnum
    _$moderationDetailModerationStateEnum_CORRECTION_REQUESTED =
    const ModerationDetailModerationStateEnum._('CORRECTION_REQUESTED');
const ModerationDetailModerationStateEnum
    _$moderationDetailModerationStateEnum_REMOVED =
    const ModerationDetailModerationStateEnum._('REMOVED');

ModerationDetailModerationStateEnum
    _$moderationDetailModerationStateEnumValueOf(String name) {
  switch (name) {
    case 'NONE':
      return _$moderationDetailModerationStateEnum_NONE;
    case 'FLAGGED':
      return _$moderationDetailModerationStateEnum_FLAGGED;
    case 'HIDDEN_PENDING_REVIEW':
      return _$moderationDetailModerationStateEnum_HIDDEN_PENDING_REVIEW;
    case 'CORRECTION_REQUESTED':
      return _$moderationDetailModerationStateEnum_CORRECTION_REQUESTED;
    case 'REMOVED':
      return _$moderationDetailModerationStateEnum_REMOVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationDetailModerationStateEnum>
    _$moderationDetailModerationStateEnumValues = BuiltSet<
        ModerationDetailModerationStateEnum>(const <ModerationDetailModerationStateEnum>[
  _$moderationDetailModerationStateEnum_NONE,
  _$moderationDetailModerationStateEnum_FLAGGED,
  _$moderationDetailModerationStateEnum_HIDDEN_PENDING_REVIEW,
  _$moderationDetailModerationStateEnum_CORRECTION_REQUESTED,
  _$moderationDetailModerationStateEnum_REMOVED,
]);

const ModerationDetailReviewerPartyEnum
    _$moderationDetailReviewerPartyEnum_BUYER =
    const ModerationDetailReviewerPartyEnum._('BUYER');
const ModerationDetailReviewerPartyEnum
    _$moderationDetailReviewerPartyEnum_VENDOR =
    const ModerationDetailReviewerPartyEnum._('VENDOR');

ModerationDetailReviewerPartyEnum _$moderationDetailReviewerPartyEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$moderationDetailReviewerPartyEnum_BUYER;
    case 'VENDOR':
      return _$moderationDetailReviewerPartyEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationDetailReviewerPartyEnum>
    _$moderationDetailReviewerPartyEnumValues = BuiltSet<
        ModerationDetailReviewerPartyEnum>(const <ModerationDetailReviewerPartyEnum>[
  _$moderationDetailReviewerPartyEnum_BUYER,
  _$moderationDetailReviewerPartyEnum_VENDOR,
]);

const ModerationDetailAvailableActionsEnum
    _$moderationDetailAvailableActionsEnum_DISMISS_FLAG =
    const ModerationDetailAvailableActionsEnum._('DISMISS_FLAG');
const ModerationDetailAvailableActionsEnum
    _$moderationDetailAvailableActionsEnum_REQUEST_CORRECTION =
    const ModerationDetailAvailableActionsEnum._('REQUEST_CORRECTION');
const ModerationDetailAvailableActionsEnum
    _$moderationDetailAvailableActionsEnum_HIDE_PENDING_REVIEW =
    const ModerationDetailAvailableActionsEnum._('HIDE_PENDING_REVIEW');
const ModerationDetailAvailableActionsEnum
    _$moderationDetailAvailableActionsEnum_REMOVE =
    const ModerationDetailAvailableActionsEnum._('REMOVE');
const ModerationDetailAvailableActionsEnum
    _$moderationDetailAvailableActionsEnum_RESTORE =
    const ModerationDetailAvailableActionsEnum._('RESTORE');

ModerationDetailAvailableActionsEnum
    _$moderationDetailAvailableActionsEnumValueOf(String name) {
  switch (name) {
    case 'DISMISS_FLAG':
      return _$moderationDetailAvailableActionsEnum_DISMISS_FLAG;
    case 'REQUEST_CORRECTION':
      return _$moderationDetailAvailableActionsEnum_REQUEST_CORRECTION;
    case 'HIDE_PENDING_REVIEW':
      return _$moderationDetailAvailableActionsEnum_HIDE_PENDING_REVIEW;
    case 'REMOVE':
      return _$moderationDetailAvailableActionsEnum_REMOVE;
    case 'RESTORE':
      return _$moderationDetailAvailableActionsEnum_RESTORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationDetailAvailableActionsEnum>
    _$moderationDetailAvailableActionsEnumValues = BuiltSet<
        ModerationDetailAvailableActionsEnum>(const <ModerationDetailAvailableActionsEnum>[
  _$moderationDetailAvailableActionsEnum_DISMISS_FLAG,
  _$moderationDetailAvailableActionsEnum_REQUEST_CORRECTION,
  _$moderationDetailAvailableActionsEnum_HIDE_PENDING_REVIEW,
  _$moderationDetailAvailableActionsEnum_REMOVE,
  _$moderationDetailAvailableActionsEnum_RESTORE,
]);

const ModerationDetailVisibilityEnum _$moderationDetailVisibilityEnum_PUBLIC =
    const ModerationDetailVisibilityEnum._('PUBLIC');
const ModerationDetailVisibilityEnum
    _$moderationDetailVisibilityEnum_HIDDEN_UNTIL_REVEAL =
    const ModerationDetailVisibilityEnum._('HIDDEN_UNTIL_REVEAL');
const ModerationDetailVisibilityEnum
    _$moderationDetailVisibilityEnum_WITHHELD_ACTIVE_DISPUTE =
    const ModerationDetailVisibilityEnum._('WITHHELD_ACTIVE_DISPUTE');
const ModerationDetailVisibilityEnum
    _$moderationDetailVisibilityEnum_HIDDEN_BY_MODERATION =
    const ModerationDetailVisibilityEnum._('HIDDEN_BY_MODERATION');
const ModerationDetailVisibilityEnum _$moderationDetailVisibilityEnum_REMOVED =
    const ModerationDetailVisibilityEnum._('REMOVED');
const ModerationDetailVisibilityEnum
    _$moderationDetailVisibilityEnum_EXCLUDED_BY_INVESTIGATION =
    const ModerationDetailVisibilityEnum._('EXCLUDED_BY_INVESTIGATION');

ModerationDetailVisibilityEnum _$moderationDetailVisibilityEnumValueOf(
    String name) {
  switch (name) {
    case 'PUBLIC':
      return _$moderationDetailVisibilityEnum_PUBLIC;
    case 'HIDDEN_UNTIL_REVEAL':
      return _$moderationDetailVisibilityEnum_HIDDEN_UNTIL_REVEAL;
    case 'WITHHELD_ACTIVE_DISPUTE':
      return _$moderationDetailVisibilityEnum_WITHHELD_ACTIVE_DISPUTE;
    case 'HIDDEN_BY_MODERATION':
      return _$moderationDetailVisibilityEnum_HIDDEN_BY_MODERATION;
    case 'REMOVED':
      return _$moderationDetailVisibilityEnum_REMOVED;
    case 'EXCLUDED_BY_INVESTIGATION':
      return _$moderationDetailVisibilityEnum_EXCLUDED_BY_INVESTIGATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ModerationDetailVisibilityEnum>
    _$moderationDetailVisibilityEnumValues = BuiltSet<
        ModerationDetailVisibilityEnum>(const <ModerationDetailVisibilityEnum>[
  _$moderationDetailVisibilityEnum_PUBLIC,
  _$moderationDetailVisibilityEnum_HIDDEN_UNTIL_REVEAL,
  _$moderationDetailVisibilityEnum_WITHHELD_ACTIVE_DISPUTE,
  _$moderationDetailVisibilityEnum_HIDDEN_BY_MODERATION,
  _$moderationDetailVisibilityEnum_REMOVED,
  _$moderationDetailVisibilityEnum_EXCLUDED_BY_INVESTIGATION,
]);

Serializer<ModerationDetailModerationStateEnum>
    _$moderationDetailModerationStateEnumSerializer =
    _$ModerationDetailModerationStateEnumSerializer();
Serializer<ModerationDetailReviewerPartyEnum>
    _$moderationDetailReviewerPartyEnumSerializer =
    _$ModerationDetailReviewerPartyEnumSerializer();
Serializer<ModerationDetailAvailableActionsEnum>
    _$moderationDetailAvailableActionsEnumSerializer =
    _$ModerationDetailAvailableActionsEnumSerializer();
Serializer<ModerationDetailVisibilityEnum>
    _$moderationDetailVisibilityEnumSerializer =
    _$ModerationDetailVisibilityEnumSerializer();

class _$ModerationDetailModerationStateEnumSerializer
    implements PrimitiveSerializer<ModerationDetailModerationStateEnum> {
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
    ModerationDetailModerationStateEnum
  ];
  @override
  final String wireName = 'ModerationDetailModerationStateEnum';

  @override
  Object serialize(
          Serializers serializers, ModerationDetailModerationStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationDetailModerationStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationDetailModerationStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationDetailReviewerPartyEnumSerializer
    implements PrimitiveSerializer<ModerationDetailReviewerPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[ModerationDetailReviewerPartyEnum];
  @override
  final String wireName = 'ModerationDetailReviewerPartyEnum';

  @override
  Object serialize(
          Serializers serializers, ModerationDetailReviewerPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationDetailReviewerPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationDetailReviewerPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationDetailAvailableActionsEnumSerializer
    implements PrimitiveSerializer<ModerationDetailAvailableActionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISMISS_FLAG': 'DISMISS_FLAG',
    'REQUEST_CORRECTION': 'REQUEST_CORRECTION',
    'HIDE_PENDING_REVIEW': 'HIDE_PENDING_REVIEW',
    'REMOVE': 'REMOVE',
    'RESTORE': 'RESTORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISMISS_FLAG': 'DISMISS_FLAG',
    'REQUEST_CORRECTION': 'REQUEST_CORRECTION',
    'HIDE_PENDING_REVIEW': 'HIDE_PENDING_REVIEW',
    'REMOVE': 'REMOVE',
    'RESTORE': 'RESTORE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ModerationDetailAvailableActionsEnum
  ];
  @override
  final String wireName = 'ModerationDetailAvailableActionsEnum';

  @override
  Object serialize(
          Serializers serializers, ModerationDetailAvailableActionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationDetailAvailableActionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationDetailAvailableActionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationDetailVisibilityEnumSerializer
    implements PrimitiveSerializer<ModerationDetailVisibilityEnum> {
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
  final Iterable<Type> types = const <Type>[ModerationDetailVisibilityEnum];
  @override
  final String wireName = 'ModerationDetailVisibilityEnum';

  @override
  Object serialize(
          Serializers serializers, ModerationDetailVisibilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ModerationDetailVisibilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ModerationDetailVisibilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ModerationDetail extends ModerationDetail {
  @override
  final String? id;
  @override
  final String? type;
  @override
  final ReviewRatings? ratings;
  @override
  final String? comment;
  @override
  final String? displayName;
  @override
  final ModerationDetailModerationStateEnum? moderationState;
  @override
  final ModerationDetailReviewerPartyEnum? reviewerParty;
  @override
  final String? displayNameChoice;
  @override
  final String? authorDisplayRule;
  @override
  final BuiltMap<String, JsonObject?>? verifiedPurchase;
  @override
  final BuiltMap<String, JsonObject?>? relatedDispute;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? revisions;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? flags;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? history;
  @override
  final BuiltList<ModerationDetailAvailableActionsEnum>? availableActions;
  @override
  final BuiltList<ReviewMediaLink>? media;
  @override
  final int? lockVersion;
  @override
  final ModerationDetailVisibilityEnum? visibility;

  factory _$ModerationDetail(
          [void Function(ModerationDetailBuilder)? updates]) =>
      (ModerationDetailBuilder()..update(updates))._build();

  _$ModerationDetail._(
      {this.id,
      this.type,
      this.ratings,
      this.comment,
      this.displayName,
      this.moderationState,
      this.reviewerParty,
      this.displayNameChoice,
      this.authorDisplayRule,
      this.verifiedPurchase,
      this.relatedDispute,
      this.revisions,
      this.flags,
      this.history,
      this.availableActions,
      this.media,
      this.lockVersion,
      this.visibility})
      : super._();
  @override
  ModerationDetail rebuild(void Function(ModerationDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModerationDetailBuilder toBuilder() =>
      ModerationDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModerationDetail &&
        id == other.id &&
        type == other.type &&
        ratings == other.ratings &&
        comment == other.comment &&
        displayName == other.displayName &&
        moderationState == other.moderationState &&
        reviewerParty == other.reviewerParty &&
        displayNameChoice == other.displayNameChoice &&
        authorDisplayRule == other.authorDisplayRule &&
        verifiedPurchase == other.verifiedPurchase &&
        relatedDispute == other.relatedDispute &&
        revisions == other.revisions &&
        flags == other.flags &&
        history == other.history &&
        availableActions == other.availableActions &&
        media == other.media &&
        lockVersion == other.lockVersion &&
        visibility == other.visibility;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, moderationState.hashCode);
    _$hash = $jc(_$hash, reviewerParty.hashCode);
    _$hash = $jc(_$hash, displayNameChoice.hashCode);
    _$hash = $jc(_$hash, authorDisplayRule.hashCode);
    _$hash = $jc(_$hash, verifiedPurchase.hashCode);
    _$hash = $jc(_$hash, relatedDispute.hashCode);
    _$hash = $jc(_$hash, revisions.hashCode);
    _$hash = $jc(_$hash, flags.hashCode);
    _$hash = $jc(_$hash, history.hashCode);
    _$hash = $jc(_$hash, availableActions.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModerationDetail')
          ..add('id', id)
          ..add('type', type)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('displayName', displayName)
          ..add('moderationState', moderationState)
          ..add('reviewerParty', reviewerParty)
          ..add('displayNameChoice', displayNameChoice)
          ..add('authorDisplayRule', authorDisplayRule)
          ..add('verifiedPurchase', verifiedPurchase)
          ..add('relatedDispute', relatedDispute)
          ..add('revisions', revisions)
          ..add('flags', flags)
          ..add('history', history)
          ..add('availableActions', availableActions)
          ..add('media', media)
          ..add('lockVersion', lockVersion)
          ..add('visibility', visibility))
        .toString();
  }
}

class ModerationDetailBuilder
    implements Builder<ModerationDetail, ModerationDetailBuilder> {
  _$ModerationDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

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

  ModerationDetailModerationStateEnum? _moderationState;
  ModerationDetailModerationStateEnum? get moderationState =>
      _$this._moderationState;
  set moderationState(ModerationDetailModerationStateEnum? moderationState) =>
      _$this._moderationState = moderationState;

  ModerationDetailReviewerPartyEnum? _reviewerParty;
  ModerationDetailReviewerPartyEnum? get reviewerParty => _$this._reviewerParty;
  set reviewerParty(ModerationDetailReviewerPartyEnum? reviewerParty) =>
      _$this._reviewerParty = reviewerParty;

  String? _displayNameChoice;
  String? get displayNameChoice => _$this._displayNameChoice;
  set displayNameChoice(String? displayNameChoice) =>
      _$this._displayNameChoice = displayNameChoice;

  String? _authorDisplayRule;
  String? get authorDisplayRule => _$this._authorDisplayRule;
  set authorDisplayRule(String? authorDisplayRule) =>
      _$this._authorDisplayRule = authorDisplayRule;

  MapBuilder<String, JsonObject?>? _verifiedPurchase;
  MapBuilder<String, JsonObject?> get verifiedPurchase =>
      _$this._verifiedPurchase ??= MapBuilder<String, JsonObject?>();
  set verifiedPurchase(MapBuilder<String, JsonObject?>? verifiedPurchase) =>
      _$this._verifiedPurchase = verifiedPurchase;

  MapBuilder<String, JsonObject?>? _relatedDispute;
  MapBuilder<String, JsonObject?> get relatedDispute =>
      _$this._relatedDispute ??= MapBuilder<String, JsonObject?>();
  set relatedDispute(MapBuilder<String, JsonObject?>? relatedDispute) =>
      _$this._relatedDispute = relatedDispute;

  ListBuilder<BuiltMap<String, JsonObject?>>? _revisions;
  ListBuilder<BuiltMap<String, JsonObject?>> get revisions =>
      _$this._revisions ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set revisions(ListBuilder<BuiltMap<String, JsonObject?>>? revisions) =>
      _$this._revisions = revisions;

  ListBuilder<BuiltMap<String, JsonObject?>>? _flags;
  ListBuilder<BuiltMap<String, JsonObject?>> get flags =>
      _$this._flags ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set flags(ListBuilder<BuiltMap<String, JsonObject?>>? flags) =>
      _$this._flags = flags;

  ListBuilder<BuiltMap<String, JsonObject?>>? _history;
  ListBuilder<BuiltMap<String, JsonObject?>> get history =>
      _$this._history ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set history(ListBuilder<BuiltMap<String, JsonObject?>>? history) =>
      _$this._history = history;

  ListBuilder<ModerationDetailAvailableActionsEnum>? _availableActions;
  ListBuilder<ModerationDetailAvailableActionsEnum> get availableActions =>
      _$this._availableActions ??=
          ListBuilder<ModerationDetailAvailableActionsEnum>();
  set availableActions(
          ListBuilder<ModerationDetailAvailableActionsEnum>?
              availableActions) =>
      _$this._availableActions = availableActions;

  ListBuilder<ReviewMediaLink>? _media;
  ListBuilder<ReviewMediaLink> get media =>
      _$this._media ??= ListBuilder<ReviewMediaLink>();
  set media(ListBuilder<ReviewMediaLink>? media) => _$this._media = media;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ModerationDetailVisibilityEnum? _visibility;
  ModerationDetailVisibilityEnum? get visibility => _$this._visibility;
  set visibility(ModerationDetailVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  ModerationDetailBuilder() {
    ModerationDetail._defaults(this);
  }

  ModerationDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _ratings = $v.ratings?.toBuilder();
      _comment = $v.comment;
      _displayName = $v.displayName;
      _moderationState = $v.moderationState;
      _reviewerParty = $v.reviewerParty;
      _displayNameChoice = $v.displayNameChoice;
      _authorDisplayRule = $v.authorDisplayRule;
      _verifiedPurchase = $v.verifiedPurchase?.toBuilder();
      _relatedDispute = $v.relatedDispute?.toBuilder();
      _revisions = $v.revisions?.toBuilder();
      _flags = $v.flags?.toBuilder();
      _history = $v.history?.toBuilder();
      _availableActions = $v.availableActions?.toBuilder();
      _media = $v.media?.toBuilder();
      _lockVersion = $v.lockVersion;
      _visibility = $v.visibility;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModerationDetail other) {
    _$v = other as _$ModerationDetail;
  }

  @override
  void update(void Function(ModerationDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModerationDetail build() => _build();

  _$ModerationDetail _build() {
    _$ModerationDetail _$result;
    try {
      _$result = _$v ??
          _$ModerationDetail._(
            id: id,
            type: type,
            ratings: _ratings?.build(),
            comment: comment,
            displayName: displayName,
            moderationState: moderationState,
            reviewerParty: reviewerParty,
            displayNameChoice: displayNameChoice,
            authorDisplayRule: authorDisplayRule,
            verifiedPurchase: _verifiedPurchase?.build(),
            relatedDispute: _relatedDispute?.build(),
            revisions: _revisions?.build(),
            flags: _flags?.build(),
            history: _history?.build(),
            availableActions: _availableActions?.build(),
            media: _media?.build(),
            lockVersion: lockVersion,
            visibility: visibility,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        _ratings?.build();

        _$failedField = 'verifiedPurchase';
        _verifiedPurchase?.build();
        _$failedField = 'relatedDispute';
        _relatedDispute?.build();
        _$failedField = 'revisions';
        _revisions?.build();
        _$failedField = 'flags';
        _flags?.build();
        _$failedField = 'history';
        _history?.build();
        _$failedField = 'availableActions';
        _availableActions?.build();
        _$failedField = 'media';
        _media?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ModerationDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
