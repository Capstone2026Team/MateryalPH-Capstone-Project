// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_handler_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeHandlerRef extends DisputeHandlerRef {
  @override
  final String displayName;
  @override
  final String role;

  factory _$DisputeHandlerRef(
          [void Function(DisputeHandlerRefBuilder)? updates]) =>
      (DisputeHandlerRefBuilder()..update(updates))._build();

  _$DisputeHandlerRef._({required this.displayName, required this.role})
      : super._();
  @override
  DisputeHandlerRef rebuild(void Function(DisputeHandlerRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeHandlerRefBuilder toBuilder() =>
      DisputeHandlerRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeHandlerRef &&
        displayName == other.displayName &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeHandlerRef')
          ..add('displayName', displayName)
          ..add('role', role))
        .toString();
  }
}

class DisputeHandlerRefBuilder
    implements Builder<DisputeHandlerRef, DisputeHandlerRefBuilder> {
  _$DisputeHandlerRef? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  DisputeHandlerRefBuilder() {
    DisputeHandlerRef._defaults(this);
  }

  DisputeHandlerRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeHandlerRef other) {
    _$v = other as _$DisputeHandlerRef;
  }

  @override
  void update(void Function(DisputeHandlerRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeHandlerRef build() => _build();

  _$DisputeHandlerRef _build() {
    final _$result = _$v ??
        _$DisputeHandlerRef._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'DisputeHandlerRef', 'displayName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'DisputeHandlerRef', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
