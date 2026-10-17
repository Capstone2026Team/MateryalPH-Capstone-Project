// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_assignment_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryAssignmentHistory extends DeliveryAssignmentHistory {
  @override
  final String event;
  @override
  final DateTime? at;
  @override
  final String? actorRole;
  @override
  final String? reason;
  @override
  final String? displayName;
  @override
  final String? vehicleName;

  factory _$DeliveryAssignmentHistory(
          [void Function(DeliveryAssignmentHistoryBuilder)? updates]) =>
      (DeliveryAssignmentHistoryBuilder()..update(updates))._build();

  _$DeliveryAssignmentHistory._(
      {required this.event,
      this.at,
      this.actorRole,
      this.reason,
      this.displayName,
      this.vehicleName})
      : super._();
  @override
  DeliveryAssignmentHistory rebuild(
          void Function(DeliveryAssignmentHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryAssignmentHistoryBuilder toBuilder() =>
      DeliveryAssignmentHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryAssignmentHistory &&
        event == other.event &&
        at == other.at &&
        actorRole == other.actorRole &&
        reason == other.reason &&
        displayName == other.displayName &&
        vehicleName == other.vehicleName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, vehicleName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryAssignmentHistory')
          ..add('event', event)
          ..add('at', at)
          ..add('actorRole', actorRole)
          ..add('reason', reason)
          ..add('displayName', displayName)
          ..add('vehicleName', vehicleName))
        .toString();
  }
}

class DeliveryAssignmentHistoryBuilder
    implements
        Builder<DeliveryAssignmentHistory, DeliveryAssignmentHistoryBuilder> {
  _$DeliveryAssignmentHistory? _$v;

  String? _event;
  String? get event => _$this._event;
  set event(String? event) => _$this._event = event;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _vehicleName;
  String? get vehicleName => _$this._vehicleName;
  set vehicleName(String? vehicleName) => _$this._vehicleName = vehicleName;

  DeliveryAssignmentHistoryBuilder() {
    DeliveryAssignmentHistory._defaults(this);
  }

  DeliveryAssignmentHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _event = $v.event;
      _at = $v.at;
      _actorRole = $v.actorRole;
      _reason = $v.reason;
      _displayName = $v.displayName;
      _vehicleName = $v.vehicleName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryAssignmentHistory other) {
    _$v = other as _$DeliveryAssignmentHistory;
  }

  @override
  void update(void Function(DeliveryAssignmentHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryAssignmentHistory build() => _build();

  _$DeliveryAssignmentHistory _build() {
    final _$result = _$v ??
        _$DeliveryAssignmentHistory._(
          event: BuiltValueNullFieldError.checkNotNull(
              event, r'DeliveryAssignmentHistory', 'event'),
          at: at,
          actorRole: actorRole,
          reason: reason,
          displayName: displayName,
          vehicleName: vehicleName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
