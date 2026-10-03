// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_preferences_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RankingPreferencesUpdate extends RankingPreferencesUpdate {
  @override
  final RankingWeightSet weights;
  @override
  final int version;

  factory _$RankingPreferencesUpdate(
          [void Function(RankingPreferencesUpdateBuilder)? updates]) =>
      (RankingPreferencesUpdateBuilder()..update(updates))._build();

  _$RankingPreferencesUpdate._({required this.weights, required this.version})
      : super._();
  @override
  RankingPreferencesUpdate rebuild(
          void Function(RankingPreferencesUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingPreferencesUpdateBuilder toBuilder() =>
      RankingPreferencesUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingPreferencesUpdate &&
        weights == other.weights &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weights.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RankingPreferencesUpdate')
          ..add('weights', weights)
          ..add('version', version))
        .toString();
  }
}

class RankingPreferencesUpdateBuilder
    implements
        Builder<RankingPreferencesUpdate, RankingPreferencesUpdateBuilder> {
  _$RankingPreferencesUpdate? _$v;

  RankingWeightSetBuilder? _weights;
  RankingWeightSetBuilder get weights =>
      _$this._weights ??= RankingWeightSetBuilder();
  set weights(RankingWeightSetBuilder? weights) => _$this._weights = weights;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  RankingPreferencesUpdateBuilder() {
    RankingPreferencesUpdate._defaults(this);
  }

  RankingPreferencesUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weights = $v.weights.toBuilder();
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankingPreferencesUpdate other) {
    _$v = other as _$RankingPreferencesUpdate;
  }

  @override
  void update(void Function(RankingPreferencesUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingPreferencesUpdate build() => _build();

  _$RankingPreferencesUpdate _build() {
    _$RankingPreferencesUpdate _$result;
    try {
      _$result = _$v ??
          _$RankingPreferencesUpdate._(
            weights: weights.build(),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'RankingPreferencesUpdate', 'version'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weights';
        weights.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RankingPreferencesUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
