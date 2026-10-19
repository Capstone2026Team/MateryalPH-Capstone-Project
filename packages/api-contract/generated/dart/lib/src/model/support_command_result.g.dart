// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_command_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportCommandResult extends SupportCommandResult {
  @override
  final String id;

  factory _$SupportCommandResult(
          [void Function(SupportCommandResultBuilder)? updates]) =>
      (SupportCommandResultBuilder()..update(updates))._build();

  _$SupportCommandResult._({required this.id}) : super._();
  @override
  SupportCommandResult rebuild(
          void Function(SupportCommandResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportCommandResultBuilder toBuilder() =>
      SupportCommandResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportCommandResult && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportCommandResult')..add('id', id))
        .toString();
  }
}

class SupportCommandResultBuilder
    implements Builder<SupportCommandResult, SupportCommandResultBuilder> {
  _$SupportCommandResult? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SupportCommandResultBuilder() {
    SupportCommandResult._defaults(this);
  }

  SupportCommandResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportCommandResult other) {
    _$v = other as _$SupportCommandResult;
  }

  @override
  void update(void Function(SupportCommandResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportCommandResult build() => _build();

  _$SupportCommandResult _build() {
    final _$result = _$v ??
        _$SupportCommandResult._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SupportCommandResult', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
