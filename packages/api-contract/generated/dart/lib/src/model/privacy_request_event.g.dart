// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_request_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PrivacyRequestEvent extends PrivacyRequestEvent {
  @override
  final String event;
  @override
  final String? fromState;
  @override
  final String toState;
  @override
  final String note;
  @override
  final String actor;
  @override
  final String actorRole;
  @override
  final String correlationId;
  @override
  final DateTime occurredAt;

  factory _$PrivacyRequestEvent(
          [void Function(PrivacyRequestEventBuilder)? updates]) =>
      (PrivacyRequestEventBuilder()..update(updates))._build();

  _$PrivacyRequestEvent._(
      {required this.event,
      this.fromState,
      required this.toState,
      required this.note,
      required this.actor,
      required this.actorRole,
      required this.correlationId,
      required this.occurredAt})
      : super._();
  @override
  PrivacyRequestEvent rebuild(
          void Function(PrivacyRequestEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrivacyRequestEventBuilder toBuilder() =>
      PrivacyRequestEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrivacyRequestEvent &&
        event == other.event &&
        fromState == other.fromState &&
        toState == other.toState &&
        note == other.note &&
        actor == other.actor &&
        actorRole == other.actorRole &&
        correlationId == other.correlationId &&
        occurredAt == other.occurredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, event.hashCode);
    _$hash = $jc(_$hash, fromState.hashCode);
    _$hash = $jc(_$hash, toState.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, occurredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PrivacyRequestEvent')
          ..add('event', event)
          ..add('fromState', fromState)
          ..add('toState', toState)
          ..add('note', note)
          ..add('actor', actor)
          ..add('actorRole', actorRole)
          ..add('correlationId', correlationId)
          ..add('occurredAt', occurredAt))
        .toString();
  }
}

class PrivacyRequestEventBuilder
    implements Builder<PrivacyRequestEvent, PrivacyRequestEventBuilder> {
  _$PrivacyRequestEvent? _$v;

  String? _event;
  String? get event => _$this._event;
  set event(String? event) => _$this._event = event;

  String? _fromState;
  String? get fromState => _$this._fromState;
  set fromState(String? fromState) => _$this._fromState = fromState;

  String? _toState;
  String? get toState => _$this._toState;
  set toState(String? toState) => _$this._toState = toState;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  DateTime? _occurredAt;
  DateTime? get occurredAt => _$this._occurredAt;
  set occurredAt(DateTime? occurredAt) => _$this._occurredAt = occurredAt;

  PrivacyRequestEventBuilder() {
    PrivacyRequestEvent._defaults(this);
  }

  PrivacyRequestEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _event = $v.event;
      _fromState = $v.fromState;
      _toState = $v.toState;
      _note = $v.note;
      _actor = $v.actor;
      _actorRole = $v.actorRole;
      _correlationId = $v.correlationId;
      _occurredAt = $v.occurredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PrivacyRequestEvent other) {
    _$v = other as _$PrivacyRequestEvent;
  }

  @override
  void update(void Function(PrivacyRequestEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PrivacyRequestEvent build() => _build();

  _$PrivacyRequestEvent _build() {
    final _$result = _$v ??
        _$PrivacyRequestEvent._(
          event: BuiltValueNullFieldError.checkNotNull(
              event, r'PrivacyRequestEvent', 'event'),
          fromState: fromState,
          toState: BuiltValueNullFieldError.checkNotNull(
              toState, r'PrivacyRequestEvent', 'toState'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'PrivacyRequestEvent', 'note'),
          actor: BuiltValueNullFieldError.checkNotNull(
              actor, r'PrivacyRequestEvent', 'actor'),
          actorRole: BuiltValueNullFieldError.checkNotNull(
              actorRole, r'PrivacyRequestEvent', 'actorRole'),
          correlationId: BuiltValueNullFieldError.checkNotNull(
              correlationId, r'PrivacyRequestEvent', 'correlationId'),
          occurredAt: BuiltValueNullFieldError.checkNotNull(
              occurredAt, r'PrivacyRequestEvent', 'occurredAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
