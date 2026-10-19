// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectoryVendorProfileSubjectTypeEnum
    _$directoryVendorProfileSubjectTypeEnum_VENDOR_ORGANIZATION =
    const DirectoryVendorProfileSubjectTypeEnum._('VENDOR_ORGANIZATION');

DirectoryVendorProfileSubjectTypeEnum
    _$directoryVendorProfileSubjectTypeEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR_ORGANIZATION':
      return _$directoryVendorProfileSubjectTypeEnum_VENDOR_ORGANIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectoryVendorProfileSubjectTypeEnum>
    _$directoryVendorProfileSubjectTypeEnumValues = BuiltSet<
        DirectoryVendorProfileSubjectTypeEnum>(const <DirectoryVendorProfileSubjectTypeEnum>[
  _$directoryVendorProfileSubjectTypeEnum_VENDOR_ORGANIZATION,
]);

Serializer<DirectoryVendorProfileSubjectTypeEnum>
    _$directoryVendorProfileSubjectTypeEnumSerializer =
    _$DirectoryVendorProfileSubjectTypeEnumSerializer();

class _$DirectoryVendorProfileSubjectTypeEnumSerializer
    implements PrimitiveSerializer<DirectoryVendorProfileSubjectTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DirectoryVendorProfileSubjectTypeEnum
  ];
  @override
  final String wireName = 'DirectoryVendorProfileSubjectTypeEnum';

  @override
  Object serialize(
          Serializers serializers, DirectoryVendorProfileSubjectTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectoryVendorProfileSubjectTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectoryVendorProfileSubjectTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectoryVendorProfile extends DirectoryVendorProfile {
  @override
  final String id;
  @override
  final DirectoryVendorProfileSubjectTypeEnum subjectType;
  @override
  final String storeName;
  @override
  final String status;
  @override
  final DirectoryVendorProfileStore store;
  @override
  final DirectoryVendorProfileOwner? owner;
  @override
  final DirectoryVendorProfileRatings ratings;
  @override
  final DirectoryVendorProfileActivity activity;
  @override
  final BuiltList<DirectorySanction> sanctions;
  @override
  final bool canViewEnforcement;
  @override
  final bool canViewVerification;

  factory _$DirectoryVendorProfile(
          [void Function(DirectoryVendorProfileBuilder)? updates]) =>
      (DirectoryVendorProfileBuilder()..update(updates))._build();

  _$DirectoryVendorProfile._(
      {required this.id,
      required this.subjectType,
      required this.storeName,
      required this.status,
      required this.store,
      this.owner,
      required this.ratings,
      required this.activity,
      required this.sanctions,
      required this.canViewEnforcement,
      required this.canViewVerification})
      : super._();
  @override
  DirectoryVendorProfile rebuild(
          void Function(DirectoryVendorProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorProfileBuilder toBuilder() =>
      DirectoryVendorProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorProfile &&
        id == other.id &&
        subjectType == other.subjectType &&
        storeName == other.storeName &&
        status == other.status &&
        store == other.store &&
        owner == other.owner &&
        ratings == other.ratings &&
        activity == other.activity &&
        sanctions == other.sanctions &&
        canViewEnforcement == other.canViewEnforcement &&
        canViewVerification == other.canViewVerification;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, subjectType.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, activity.hashCode);
    _$hash = $jc(_$hash, sanctions.hashCode);
    _$hash = $jc(_$hash, canViewEnforcement.hashCode);
    _$hash = $jc(_$hash, canViewVerification.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorProfile')
          ..add('id', id)
          ..add('subjectType', subjectType)
          ..add('storeName', storeName)
          ..add('status', status)
          ..add('store', store)
          ..add('owner', owner)
          ..add('ratings', ratings)
          ..add('activity', activity)
          ..add('sanctions', sanctions)
          ..add('canViewEnforcement', canViewEnforcement)
          ..add('canViewVerification', canViewVerification))
        .toString();
  }
}

class DirectoryVendorProfileBuilder
    implements Builder<DirectoryVendorProfile, DirectoryVendorProfileBuilder> {
  _$DirectoryVendorProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DirectoryVendorProfileSubjectTypeEnum? _subjectType;
  DirectoryVendorProfileSubjectTypeEnum? get subjectType => _$this._subjectType;
  set subjectType(DirectoryVendorProfileSubjectTypeEnum? subjectType) =>
      _$this._subjectType = subjectType;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DirectoryVendorProfileStoreBuilder? _store;
  DirectoryVendorProfileStoreBuilder get store =>
      _$this._store ??= DirectoryVendorProfileStoreBuilder();
  set store(DirectoryVendorProfileStoreBuilder? store) => _$this._store = store;

  DirectoryVendorProfileOwnerBuilder? _owner;
  DirectoryVendorProfileOwnerBuilder get owner =>
      _$this._owner ??= DirectoryVendorProfileOwnerBuilder();
  set owner(DirectoryVendorProfileOwnerBuilder? owner) => _$this._owner = owner;

  DirectoryVendorProfileRatingsBuilder? _ratings;
  DirectoryVendorProfileRatingsBuilder get ratings =>
      _$this._ratings ??= DirectoryVendorProfileRatingsBuilder();
  set ratings(DirectoryVendorProfileRatingsBuilder? ratings) =>
      _$this._ratings = ratings;

  DirectoryVendorProfileActivityBuilder? _activity;
  DirectoryVendorProfileActivityBuilder get activity =>
      _$this._activity ??= DirectoryVendorProfileActivityBuilder();
  set activity(DirectoryVendorProfileActivityBuilder? activity) =>
      _$this._activity = activity;

  ListBuilder<DirectorySanction>? _sanctions;
  ListBuilder<DirectorySanction> get sanctions =>
      _$this._sanctions ??= ListBuilder<DirectorySanction>();
  set sanctions(ListBuilder<DirectorySanction>? sanctions) =>
      _$this._sanctions = sanctions;

  bool? _canViewEnforcement;
  bool? get canViewEnforcement => _$this._canViewEnforcement;
  set canViewEnforcement(bool? canViewEnforcement) =>
      _$this._canViewEnforcement = canViewEnforcement;

  bool? _canViewVerification;
  bool? get canViewVerification => _$this._canViewVerification;
  set canViewVerification(bool? canViewVerification) =>
      _$this._canViewVerification = canViewVerification;

  DirectoryVendorProfileBuilder() {
    DirectoryVendorProfile._defaults(this);
  }

  DirectoryVendorProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _subjectType = $v.subjectType;
      _storeName = $v.storeName;
      _status = $v.status;
      _store = $v.store.toBuilder();
      _owner = $v.owner?.toBuilder();
      _ratings = $v.ratings.toBuilder();
      _activity = $v.activity.toBuilder();
      _sanctions = $v.sanctions.toBuilder();
      _canViewEnforcement = $v.canViewEnforcement;
      _canViewVerification = $v.canViewVerification;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorProfile other) {
    _$v = other as _$DirectoryVendorProfile;
  }

  @override
  void update(void Function(DirectoryVendorProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorProfile build() => _build();

  _$DirectoryVendorProfile _build() {
    _$DirectoryVendorProfile _$result;
    try {
      _$result = _$v ??
          _$DirectoryVendorProfile._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DirectoryVendorProfile', 'id'),
            subjectType: BuiltValueNullFieldError.checkNotNull(
                subjectType, r'DirectoryVendorProfile', 'subjectType'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'DirectoryVendorProfile', 'storeName'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DirectoryVendorProfile', 'status'),
            store: store.build(),
            owner: _owner?.build(),
            ratings: ratings.build(),
            activity: activity.build(),
            sanctions: sanctions.build(),
            canViewEnforcement: BuiltValueNullFieldError.checkNotNull(
                canViewEnforcement,
                r'DirectoryVendorProfile',
                'canViewEnforcement'),
            canViewVerification: BuiltValueNullFieldError.checkNotNull(
                canViewVerification,
                r'DirectoryVendorProfile',
                'canViewVerification'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'store';
        store.build();
        _$failedField = 'owner';
        _owner?.build();
        _$failedField = 'ratings';
        ratings.build();
        _$failedField = 'activity';
        activity.build();
        _$failedField = 'sanctions';
        sanctions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryVendorProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
