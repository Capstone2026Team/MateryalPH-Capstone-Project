// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_updates.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NavigationUpdates extends NavigationUpdates {
  @override
  final BuiltMap<String, int> sections;
  @override
  final String? cartQuantity;
  @override
  final int? cartVersion;

  factory _$NavigationUpdates(
          [void Function(NavigationUpdatesBuilder)? updates]) =>
      (NavigationUpdatesBuilder()..update(updates))._build();

  _$NavigationUpdates._(
      {required this.sections, this.cartQuantity, this.cartVersion})
      : super._();
  @override
  NavigationUpdates rebuild(void Function(NavigationUpdatesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NavigationUpdatesBuilder toBuilder() =>
      NavigationUpdatesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NavigationUpdates &&
        sections == other.sections &&
        cartQuantity == other.cartQuantity &&
        cartVersion == other.cartVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sections.hashCode);
    _$hash = $jc(_$hash, cartQuantity.hashCode);
    _$hash = $jc(_$hash, cartVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NavigationUpdates')
          ..add('sections', sections)
          ..add('cartQuantity', cartQuantity)
          ..add('cartVersion', cartVersion))
        .toString();
  }
}

class NavigationUpdatesBuilder
    implements Builder<NavigationUpdates, NavigationUpdatesBuilder> {
  _$NavigationUpdates? _$v;

  MapBuilder<String, int>? _sections;
  MapBuilder<String, int> get sections =>
      _$this._sections ??= MapBuilder<String, int>();
  set sections(MapBuilder<String, int>? sections) =>
      _$this._sections = sections;

  String? _cartQuantity;
  String? get cartQuantity => _$this._cartQuantity;
  set cartQuantity(String? cartQuantity) => _$this._cartQuantity = cartQuantity;

  int? _cartVersion;
  int? get cartVersion => _$this._cartVersion;
  set cartVersion(int? cartVersion) => _$this._cartVersion = cartVersion;

  NavigationUpdatesBuilder() {
    NavigationUpdates._defaults(this);
  }

  NavigationUpdatesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sections = $v.sections.toBuilder();
      _cartQuantity = $v.cartQuantity;
      _cartVersion = $v.cartVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NavigationUpdates other) {
    _$v = other as _$NavigationUpdates;
  }

  @override
  void update(void Function(NavigationUpdatesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NavigationUpdates build() => _build();

  _$NavigationUpdates _build() {
    _$NavigationUpdates _$result;
    try {
      _$result = _$v ??
          _$NavigationUpdates._(
            sections: sections.build(),
            cartQuantity: cartQuantity,
            cartVersion: cartVersion,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sections';
        sections.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NavigationUpdates', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
