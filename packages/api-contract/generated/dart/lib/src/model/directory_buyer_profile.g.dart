// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryBuyerProfileSubjectTypeEnum
    _$directoryBuyerProfileSubjectTypeEnum_BUYER =
    const DirectoryBuyerProfileSubjectTypeEnum._('BUYER');

DirectoryBuyerProfileSubjectTypeEnum
    _$directoryBuyerProfileSubjectTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$directoryBuyerProfileSubjectTypeEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryBuyerProfileSubjectTypeEnum>
    _$directoryBuyerProfileSubjectTypeEnumValues = BuiltSet<
        DirectoryBuyerProfileSubjectTypeEnum>(const <DirectoryBuyerProfileSubjectTypeEnum>[
  _$directoryBuyerProfileSubjectTypeEnum_BUYER,
]);

const DirectoryBuyerProfileStatusEnum _$directoryBuyerProfileStatusEnum_ACTIVE =
    const DirectoryBuyerProfileStatusEnum._('ACTIVE');
const DirectoryBuyerProfileStatusEnum
    _$directoryBuyerProfileStatusEnum_PENDING_VERIFICATION =
    const DirectoryBuyerProfileStatusEnum._('PENDING_VERIFICATION');
const DirectoryBuyerProfileStatusEnum
    _$directoryBuyerProfileStatusEnum_SUSPENDED =
    const DirectoryBuyerProfileStatusEnum._('SUSPENDED');
const DirectoryBuyerProfileStatusEnum
    _$directoryBuyerProfileStatusEnum_DEACTIVATED =
    const DirectoryBuyerProfileStatusEnum._('DEACTIVATED');
const DirectoryBuyerProfileStatusEnum
    _$directoryBuyerProfileStatusEnum_DELETED =
    const DirectoryBuyerProfileStatusEnum._('DELETED');

DirectoryBuyerProfileStatusEnum _$directoryBuyerProfileStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$directoryBuyerProfileStatusEnum_ACTIVE;
    case 'PENDING_VERIFICATION':
      return _$directoryBuyerProfileStatusEnum_PENDING_VERIFICATION;
    case 'SUSPENDED':
      return _$directoryBuyerProfileStatusEnum_SUSPENDED;
    case 'DEACTIVATED':
      return _$directoryBuyerProfileStatusEnum_DEACTIVATED;
    case 'DELETED':
      return _$directoryBuyerProfileStatusEnum_DELETED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryBuyerProfileStatusEnum>
    _$directoryBuyerProfileStatusEnumValues = BuiltSet<
        DirectoryBuyerProfileStatusEnum>(const <DirectoryBuyerProfileStatusEnum>[
  _$directoryBuyerProfileStatusEnum_ACTIVE,
  _$directoryBuyerProfileStatusEnum_PENDING_VERIFICATION,
  _$directoryBuyerProfileStatusEnum_SUSPENDED,
  _$directoryBuyerProfileStatusEnum_DEACTIVATED,
  _$directoryBuyerProfileStatusEnum_DELETED,
]);

Serializer<DirectoryBuyerProfileSubjectTypeEnum>
    _$directoryBuyerProfileSubjectTypeEnumSerializer =
    _$DirectoryBuyerProfileSubjectTypeEnumSerializer();
Serializer<DirectoryBuyerProfileStatusEnum>
    _$directoryBuyerProfileStatusEnumSerializer =
    _$DirectoryBuyerProfileStatusEnumSerializer();

class _$DirectoryBuyerProfileSubjectTypeEnumSerializer
    implements PrimitiveSerializer<DirectoryBuyerProfileSubjectTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DirectoryBuyerProfileSubjectTypeEnum
  ];
  @override
  final String wireName = 'DirectoryBuyerProfileSubjectTypeEnum';

  @override
  Object serialize(
          Serializers serializers, DirectoryBuyerProfileSubjectTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryBuyerProfileSubjectTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryBuyerProfileSubjectTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryBuyerProfileStatusEnumSerializer
    implements PrimitiveSerializer<DirectoryBuyerProfileStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
    'DELETED': 'DELETED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'PENDING_VERIFICATION': 'PENDING_VERIFICATION',
    'SUSPENDED': 'SUSPENDED',
    'DEACTIVATED': 'DEACTIVATED',
    'DELETED': 'DELETED',
  };

  @override
  final Iterable<Type> types = const <Type>[DirectoryBuyerProfileStatusEnum];
  @override
  final String wireName = 'DirectoryBuyerProfileStatusEnum';

  @override
  Object serialize(
          Serializers serializers, DirectoryBuyerProfileStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryBuyerProfileStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryBuyerProfileStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryBuyerProfile extends DirectoryBuyerProfile {
  @override
  final String id;
  @override
  final DirectoryBuyerProfileSubjectTypeEnum subjectType;
  @override
  final String name;
  @override
  final DirectoryBuyerProfileStatusEnum status;
  @override
  final DirectoryBuyerProfileProfile profile;
  @override
  final DirectoryBuyerProfileRatings ratings;
  @override
  final DirectoryBuyerProfileActivity activity;
  @override
  final BuiltList<DirectoryBuyerProfileRecentOrdersInner> recentOrders;
  @override
  final BuiltList<DirectorySanction> sanctions;
  @override
  final bool canViewEnforcement;

  factory _$DirectoryBuyerProfile(
          [void Function(DirectoryBuyerProfileBuilder)? updates]) =>
      (DirectoryBuyerProfileBuilder()..update(updates))._build();

  _$DirectoryBuyerProfile._(
      {required this.id,
      required this.subjectType,
      required this.name,
      required this.status,
      required this.profile,
      required this.ratings,
      required this.activity,
      required this.recentOrders,
      required this.sanctions,
      required this.canViewEnforcement})
      : super._();
  @override
  DirectoryBuyerProfile rebuild(
          void Function(DirectoryBuyerProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerProfileBuilder toBuilder() =>
      DirectoryBuyerProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerProfile &&
        id == other.id &&
        subjectType == other.subjectType &&
        name == other.name &&
        status == other.status &&
        profile == other.profile &&
        ratings == other.ratings &&
        activity == other.activity &&
        recentOrders == other.recentOrders &&
        sanctions == other.sanctions &&
        canViewEnforcement == other.canViewEnforcement;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, subjectType.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, activity.hashCode);
    _$hash = $jc(_$hash, recentOrders.hashCode);
    _$hash = $jc(_$hash, sanctions.hashCode);
    _$hash = $jc(_$hash, canViewEnforcement.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryBuyerProfile')
          ..add('id', id)
          ..add('subjectType', subjectType)
          ..add('name', name)
          ..add('status', status)
          ..add('profile', profile)
          ..add('ratings', ratings)
          ..add('activity', activity)
          ..add('recentOrders', recentOrders)
          ..add('sanctions', sanctions)
          ..add('canViewEnforcement', canViewEnforcement))
        .toString();
  }
}

class DirectoryBuyerProfileBuilder
    implements Builder<DirectoryBuyerProfile, DirectoryBuyerProfileBuilder> {
  _$DirectoryBuyerProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DirectoryBuyerProfileSubjectTypeEnum? _subjectType;
  DirectoryBuyerProfileSubjectTypeEnum? get subjectType => _$this._subjectType;
  set subjectType(DirectoryBuyerProfileSubjectTypeEnum? subjectType) =>
      _$this._subjectType = subjectType;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DirectoryBuyerProfileStatusEnum? _status;
  DirectoryBuyerProfileStatusEnum? get status => _$this._status;
  set status(DirectoryBuyerProfileStatusEnum? status) =>
      _$this._status = status;

  DirectoryBuyerProfileProfileBuilder? _profile;
  DirectoryBuyerProfileProfileBuilder get profile =>
      _$this._profile ??= DirectoryBuyerProfileProfileBuilder();
  set profile(DirectoryBuyerProfileProfileBuilder? profile) =>
      _$this._profile = profile;

  DirectoryBuyerProfileRatingsBuilder? _ratings;
  DirectoryBuyerProfileRatingsBuilder get ratings =>
      _$this._ratings ??= DirectoryBuyerProfileRatingsBuilder();
  set ratings(DirectoryBuyerProfileRatingsBuilder? ratings) =>
      _$this._ratings = ratings;

  DirectoryBuyerProfileActivityBuilder? _activity;
  DirectoryBuyerProfileActivityBuilder get activity =>
      _$this._activity ??= DirectoryBuyerProfileActivityBuilder();
  set activity(DirectoryBuyerProfileActivityBuilder? activity) =>
      _$this._activity = activity;

  ListBuilder<DirectoryBuyerProfileRecentOrdersInner>? _recentOrders;
  ListBuilder<DirectoryBuyerProfileRecentOrdersInner> get recentOrders =>
      _$this._recentOrders ??=
          ListBuilder<DirectoryBuyerProfileRecentOrdersInner>();
  set recentOrders(
          ListBuilder<DirectoryBuyerProfileRecentOrdersInner>? recentOrders) =>
      _$this._recentOrders = recentOrders;

  ListBuilder<DirectorySanction>? _sanctions;
  ListBuilder<DirectorySanction> get sanctions =>
      _$this._sanctions ??= ListBuilder<DirectorySanction>();
  set sanctions(ListBuilder<DirectorySanction>? sanctions) =>
      _$this._sanctions = sanctions;

  bool? _canViewEnforcement;
  bool? get canViewEnforcement => _$this._canViewEnforcement;
  set canViewEnforcement(bool? canViewEnforcement) =>
      _$this._canViewEnforcement = canViewEnforcement;

  DirectoryBuyerProfileBuilder() {
    DirectoryBuyerProfile._defaults(this);
  }

  DirectoryBuyerProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _subjectType = $v.subjectType;
      _name = $v.name;
      _status = $v.status;
      _profile = $v.profile.toBuilder();
      _ratings = $v.ratings.toBuilder();
      _activity = $v.activity.toBuilder();
      _recentOrders = $v.recentOrders.toBuilder();
      _sanctions = $v.sanctions.toBuilder();
      _canViewEnforcement = $v.canViewEnforcement;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerProfile other) {
    _$v = other as _$DirectoryBuyerProfile;
  }

  @override
  void update(void Function(DirectoryBuyerProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerProfile build() => _build();

  _$DirectoryBuyerProfile _build() {
    _$DirectoryBuyerProfile _$result;
    try {
      _$result = _$v ??
          _$DirectoryBuyerProfile._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DirectoryBuyerProfile', 'id'),
            subjectType: BuiltValueNullFieldError.checkNotNull(
                subjectType, r'DirectoryBuyerProfile', 'subjectType'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'DirectoryBuyerProfile', 'name'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DirectoryBuyerProfile', 'status'),
            profile: profile.build(),
            ratings: ratings.build(),
            activity: activity.build(),
            recentOrders: recentOrders.build(),
            sanctions: sanctions.build(),
            canViewEnforcement: BuiltValueNullFieldError.checkNotNull(
                canViewEnforcement,
                r'DirectoryBuyerProfile',
                'canViewEnforcement'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profile';
        profile.build();
        _$failedField = 'ratings';
        ratings.build();
        _$failedField = 'activity';
        activity.build();
        _$failedField = 'recentOrders';
        recentOrders.build();
        _$failedField = 'sanctions';
        sanctions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryBuyerProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
