// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_preferences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DiscoveryPreferences extends DiscoveryPreferences {
  @override
  final int radiusKm;

  factory _$DiscoveryPreferences(
          [void Function(DiscoveryPreferencesBuilder)? updates]) =>
      (DiscoveryPreferencesBuilder()..update(updates))._build();

  _$DiscoveryPreferences._({required this.radiusKm}) : super._();
  @override
  DiscoveryPreferences rebuild(
          void Function(DiscoveryPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscoveryPreferencesBuilder toBuilder() =>
      DiscoveryPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscoveryPreferences && radiusKm == other.radiusKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscoveryPreferences')
          ..add('radiusKm', radiusKm))
        .toString();
  }
}

class DiscoveryPreferencesBuilder
    implements Builder<DiscoveryPreferences, DiscoveryPreferencesBuilder> {
  _$DiscoveryPreferences? _$v;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  DiscoveryPreferencesBuilder() {
    DiscoveryPreferences._defaults(this);
  }

  DiscoveryPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _radiusKm = $v.radiusKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscoveryPreferences other) {
    _$v = other as _$DiscoveryPreferences;
  }

  @override
  void update(void Function(DiscoveryPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscoveryPreferences build() => _build();

  _$DiscoveryPreferences _build() {
    final _$result = _$v ??
        _$DiscoveryPreferences._(
          radiusKm: BuiltValueNullFieldError.checkNotNull(
              radiusKm, r'DiscoveryPreferences', 'radiusKm'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
