// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class AuditEventBuilder {
  void replace(AuditEvent other);
  void update(void Function(AuditEventBuilder) updates);
  String? get id;
  set id(String? id);

  DateTime? get createdAt;
  set createdAt(DateTime? createdAt);

  String? get actor;
  set actor(String? actor);

  String? get actorRole;
  set actorRole(String? actorRole);

  String? get action;
  set action(String? action);

  String? get resourceType;
  set resourceType(String? resourceType);

  String? get resourceId;
  set resourceId(String? resourceId);

  String? get organization;
  set organization(String? organization);

  String? get organizationId;
  set organizationId(String? organizationId);

  bool? get succeeded;
  set succeeded(bool? succeeded);

  String? get reason;
  set reason(String? reason);

  String? get correlationId;
  set correlationId(String? correlationId);

  bool? get hasDetail;
  set hasDetail(bool? hasDetail);
}

class _$$AuditEvent extends $AuditEvent {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final String actor;
  @override
  final String? actorRole;
  @override
  final String action;
  @override
  final String resourceType;
  @override
  final String? resourceId;
  @override
  final String? organization;
  @override
  final String? organizationId;
  @override
  final bool succeeded;
  @override
  final String? reason;
  @override
  final String correlationId;
  @override
  final bool hasDetail;

  factory _$$AuditEvent([void Function($AuditEventBuilder)? updates]) =>
      ($AuditEventBuilder()..update(updates))._build();

  _$$AuditEvent._(
      {required this.id,
      required this.createdAt,
      required this.actor,
      this.actorRole,
      required this.action,
      required this.resourceType,
      this.resourceId,
      this.organization,
      this.organizationId,
      required this.succeeded,
      this.reason,
      required this.correlationId,
      required this.hasDetail})
      : super._();
  @override
  $AuditEvent rebuild(void Function($AuditEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $AuditEventBuilder toBuilder() => $AuditEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $AuditEvent &&
        id == other.id &&
        createdAt == other.createdAt &&
        actor == other.actor &&
        actorRole == other.actorRole &&
        action == other.action &&
        resourceType == other.resourceType &&
        resourceId == other.resourceId &&
        organization == other.organization &&
        organizationId == other.organizationId &&
        succeeded == other.succeeded &&
        reason == other.reason &&
        correlationId == other.correlationId &&
        hasDetail == other.hasDetail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, resourceType.hashCode);
    _$hash = $jc(_$hash, resourceId.hashCode);
    _$hash = $jc(_$hash, organization.hashCode);
    _$hash = $jc(_$hash, organizationId.hashCode);
    _$hash = $jc(_$hash, succeeded.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, hasDetail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$AuditEvent')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('actor', actor)
          ..add('actorRole', actorRole)
          ..add('action', action)
          ..add('resourceType', resourceType)
          ..add('resourceId', resourceId)
          ..add('organization', organization)
          ..add('organizationId', organizationId)
          ..add('succeeded', succeeded)
          ..add('reason', reason)
          ..add('correlationId', correlationId)
          ..add('hasDetail', hasDetail))
        .toString();
  }
}

class $AuditEventBuilder
    implements Builder<$AuditEvent, $AuditEventBuilder>, AuditEventBuilder {
  _$$AuditEvent? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(covariant DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(covariant String? actor) => _$this._actor = actor;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(covariant String? actorRole) => _$this._actorRole = actorRole;

  String? _action;
  String? get action => _$this._action;
  set action(covariant String? action) => _$this._action = action;

  String? _resourceType;
  String? get resourceType => _$this._resourceType;
  set resourceType(covariant String? resourceType) =>
      _$this._resourceType = resourceType;

  String? _resourceId;
  String? get resourceId => _$this._resourceId;
  set resourceId(covariant String? resourceId) =>
      _$this._resourceId = resourceId;

  String? _organization;
  String? get organization => _$this._organization;
  set organization(covariant String? organization) =>
      _$this._organization = organization;

  String? _organizationId;
  String? get organizationId => _$this._organizationId;
  set organizationId(covariant String? organizationId) =>
      _$this._organizationId = organizationId;

  bool? _succeeded;
  bool? get succeeded => _$this._succeeded;
  set succeeded(covariant bool? succeeded) => _$this._succeeded = succeeded;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(covariant String? reason) => _$this._reason = reason;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(covariant String? correlationId) =>
      _$this._correlationId = correlationId;

  bool? _hasDetail;
  bool? get hasDetail => _$this._hasDetail;
  set hasDetail(covariant bool? hasDetail) => _$this._hasDetail = hasDetail;

  $AuditEventBuilder() {
    $AuditEvent._defaults(this);
  }

  $AuditEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _actor = $v.actor;
      _actorRole = $v.actorRole;
      _action = $v.action;
      _resourceType = $v.resourceType;
      _resourceId = $v.resourceId;
      _organization = $v.organization;
      _organizationId = $v.organizationId;
      _succeeded = $v.succeeded;
      _reason = $v.reason;
      _correlationId = $v.correlationId;
      _hasDetail = $v.hasDetail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $AuditEvent other) {
    _$v = other as _$$AuditEvent;
  }

  @override
  void update(void Function($AuditEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $AuditEvent build() => _build();

  _$$AuditEvent _build() {
    final _$result = _$v ??
        _$$AuditEvent._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'$AuditEvent', 'id'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'$AuditEvent', 'createdAt'),
          actor: BuiltValueNullFieldError.checkNotNull(
              actor, r'$AuditEvent', 'actor'),
          actorRole: actorRole,
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'$AuditEvent', 'action'),
          resourceType: BuiltValueNullFieldError.checkNotNull(
              resourceType, r'$AuditEvent', 'resourceType'),
          resourceId: resourceId,
          organization: organization,
          organizationId: organizationId,
          succeeded: BuiltValueNullFieldError.checkNotNull(
              succeeded, r'$AuditEvent', 'succeeded'),
          reason: reason,
          correlationId: BuiltValueNullFieldError.checkNotNull(
              correlationId, r'$AuditEvent', 'correlationId'),
          hasDetail: BuiltValueNullFieldError.checkNotNull(
              hasDetail, r'$AuditEvent', 'hasDetail'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
