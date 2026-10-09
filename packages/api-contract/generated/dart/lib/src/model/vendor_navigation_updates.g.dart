// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_navigation_updates.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorNavigationUpdates extends VendorNavigationUpdates {
  @override
  final BuiltMap<String, int> sections;

  factory _$VendorNavigationUpdates(
          [void Function(VendorNavigationUpdatesBuilder)? updates]) =>
      (VendorNavigationUpdatesBuilder()..update(updates))._build();

  _$VendorNavigationUpdates._({required this.sections}) : super._();
  @override
  VendorNavigationUpdates rebuild(
          void Function(VendorNavigationUpdatesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorNavigationUpdatesBuilder toBuilder() =>
      VendorNavigationUpdatesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorNavigationUpdates && sections == other.sections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorNavigationUpdates')
          ..add('sections', sections))
        .toString();
  }
}

class VendorNavigationUpdatesBuilder
    implements
        Builder<VendorNavigationUpdates, VendorNavigationUpdatesBuilder> {
  _$VendorNavigationUpdates? _$v;

  MapBuilder<String, int>? _sections;
  MapBuilder<String, int> get sections =>
      _$this._sections ??= MapBuilder<String, int>();
  set sections(MapBuilder<String, int>? sections) =>
      _$this._sections = sections;

  VendorNavigationUpdatesBuilder() {
    VendorNavigationUpdates._defaults(this);
  }

  VendorNavigationUpdatesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sections = $v.sections.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorNavigationUpdates other) {
    _$v = other as _$VendorNavigationUpdates;
  }

  @override
  void update(void Function(VendorNavigationUpdatesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorNavigationUpdates build() => _build();

  _$VendorNavigationUpdates _build() {
    _$VendorNavigationUpdates _$result;
    try {
      _$result = _$v ??
          _$VendorNavigationUpdates._(
            sections: sections.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sections';
        sections.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorNavigationUpdates', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
