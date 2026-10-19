// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_handler.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SupportHandler extends SupportHandler {
  @override
  final String id;
  @override
  final String name;

  factory _$SupportHandler([void Function(SupportHandlerBuilder)? updates]) =>
      (SupportHandlerBuilder()..update(updates))._build();

  _$SupportHandler._({required this.id, required this.name}) : super._();
  @override
  SupportHandler rebuild(void Function(SupportHandlerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupportHandlerBuilder toBuilder() => SupportHandlerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportHandler && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupportHandler')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SupportHandlerBuilder
    implements Builder<SupportHandler, SupportHandlerBuilder> {
  _$SupportHandler? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SupportHandlerBuilder() {
    SupportHandler._defaults(this);
  }

  SupportHandlerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupportHandler other) {
    _$v = other as _$SupportHandler;
  }

  @override
  void update(void Function(SupportHandlerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupportHandler build() => _build();

  _$SupportHandler _build() {
    final _$result = _$v ??
        _$SupportHandler._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SupportHandler', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SupportHandler', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
