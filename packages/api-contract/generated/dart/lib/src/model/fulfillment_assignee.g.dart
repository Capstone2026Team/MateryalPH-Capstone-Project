// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_assignee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentAssignee extends FulfillmentAssignee {
  @override
  final int userId;
  @override
  final String displayName;
  @override
  final bool assigned;

  factory _$FulfillmentAssignee(
          [void Function(FulfillmentAssigneeBuilder)? updates]) =>
      (FulfillmentAssigneeBuilder()..update(updates))._build();

  _$FulfillmentAssignee._(
      {required this.userId, required this.displayName, required this.assigned})
      : super._();
  @override
  FulfillmentAssignee rebuild(
          void Function(FulfillmentAssigneeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentAssigneeBuilder toBuilder() =>
      FulfillmentAssigneeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentAssignee &&
        userId == other.userId &&
        displayName == other.displayName &&
        assigned == other.assigned;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, assigned.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentAssignee')
          ..add('userId', userId)
          ..add('displayName', displayName)
          ..add('assigned', assigned))
        .toString();
  }
}

class FulfillmentAssigneeBuilder
    implements Builder<FulfillmentAssignee, FulfillmentAssigneeBuilder> {
  _$FulfillmentAssignee? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  bool? _assigned;
  bool? get assigned => _$this._assigned;
  set assigned(bool? assigned) => _$this._assigned = assigned;

  FulfillmentAssigneeBuilder() {
    FulfillmentAssignee._defaults(this);
  }

  FulfillmentAssigneeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _displayName = $v.displayName;
      _assigned = $v.assigned;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentAssignee other) {
    _$v = other as _$FulfillmentAssignee;
  }

  @override
  void update(void Function(FulfillmentAssigneeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentAssignee build() => _build();

  _$FulfillmentAssignee _build() {
    final _$result = _$v ??
        _$FulfillmentAssignee._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'FulfillmentAssignee', 'userId'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'FulfillmentAssignee', 'displayName'),
          assigned: BuiltValueNullFieldError.checkNotNull(
              assigned, r'FulfillmentAssignee', 'assigned'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
