// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_activity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamActivity extends VendorTeamActivity {
  @override
  final String id;
  @override
  final String? actorName;
  @override
  final String actorRole;
  @override
  final String action;
  @override
  final String resourceType;
  @override
  final String? resourceId;
  @override
  final DateTime createdAt;
  @override
  final bool succeeded;
  @override
  final BuiltMap<String, JsonObject?> before;
  @override
  final BuiltMap<String, JsonObject?> after;

  factory _$VendorTeamActivity(
          [void Function(VendorTeamActivityBuilder)? updates]) =>
      (VendorTeamActivityBuilder()..update(updates))._build();

  _$VendorTeamActivity._(
      {required this.id,
      this.actorName,
      required this.actorRole,
      required this.action,
      required this.resourceType,
      this.resourceId,
      required this.createdAt,
      required this.succeeded,
      required this.before,
      required this.after})
      : super._();
  @override
  VendorTeamActivity rebuild(
          void Function(VendorTeamActivityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamActivityBuilder toBuilder() =>
      VendorTeamActivityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamActivity &&
        id == other.id &&
        actorName == other.actorName &&
        actorRole == other.actorRole &&
        action == other.action &&
        resourceType == other.resourceType &&
        resourceId == other.resourceId &&
        createdAt == other.createdAt &&
        succeeded == other.succeeded &&
        before == other.before &&
        after == other.after;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, resourceType.hashCode);
    _$hash = $jc(_$hash, resourceId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, succeeded.hashCode);
    _$hash = $jc(_$hash, before.hashCode);
    _$hash = $jc(_$hash, after.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamActivity')
          ..add('id', id)
          ..add('actorName', actorName)
          ..add('actorRole', actorRole)
          ..add('action', action)
          ..add('resourceType', resourceType)
          ..add('resourceId', resourceId)
          ..add('createdAt', createdAt)
          ..add('succeeded', succeeded)
          ..add('before', before)
          ..add('after', after))
        .toString();
  }
}

class VendorTeamActivityBuilder
    implements Builder<VendorTeamActivity, VendorTeamActivityBuilder> {
  _$VendorTeamActivity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _resourceType;
  String? get resourceType => _$this._resourceType;
  set resourceType(String? resourceType) => _$this._resourceType = resourceType;

  String? _resourceId;
  String? get resourceId => _$this._resourceId;
  set resourceId(String? resourceId) => _$this._resourceId = resourceId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  bool? _succeeded;
  bool? get succeeded => _$this._succeeded;
  set succeeded(bool? succeeded) => _$this._succeeded = succeeded;

  MapBuilder<String, JsonObject?>? _before;
  MapBuilder<String, JsonObject?> get before =>
      _$this._before ??= MapBuilder<String, JsonObject?>();
  set before(MapBuilder<String, JsonObject?>? before) =>
      _$this._before = before;

  MapBuilder<String, JsonObject?>? _after;
  MapBuilder<String, JsonObject?> get after =>
      _$this._after ??= MapBuilder<String, JsonObject?>();
  set after(MapBuilder<String, JsonObject?>? after) => _$this._after = after;

  VendorTeamActivityBuilder() {
    VendorTeamActivity._defaults(this);
  }

  VendorTeamActivityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _actorName = $v.actorName;
      _actorRole = $v.actorRole;
      _action = $v.action;
      _resourceType = $v.resourceType;
      _resourceId = $v.resourceId;
      _createdAt = $v.createdAt;
      _succeeded = $v.succeeded;
      _before = $v.before.toBuilder();
      _after = $v.after.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamActivity other) {
    _$v = other as _$VendorTeamActivity;
  }

  @override
  void update(void Function(VendorTeamActivityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamActivity build() => _build();

  _$VendorTeamActivity _build() {
    _$VendorTeamActivity _$result;
    try {
      _$result = _$v ??
          _$VendorTeamActivity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'VendorTeamActivity', 'id'),
            actorName: actorName,
            actorRole: BuiltValueNullFieldError.checkNotNull(
                actorRole, r'VendorTeamActivity', 'actorRole'),
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'VendorTeamActivity', 'action'),
            resourceType: BuiltValueNullFieldError.checkNotNull(
                resourceType, r'VendorTeamActivity', 'resourceType'),
            resourceId: resourceId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'VendorTeamActivity', 'createdAt'),
            succeeded: BuiltValueNullFieldError.checkNotNull(
                succeeded, r'VendorTeamActivity', 'succeeded'),
            before: before.build(),
            after: after.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'before';
        before.build();
        _$failedField = 'after';
        after.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeamActivity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
