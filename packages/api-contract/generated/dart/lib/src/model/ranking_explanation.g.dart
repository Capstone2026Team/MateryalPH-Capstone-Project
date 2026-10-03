// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_explanation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RankingExplanation extends RankingExplanation {
  @override
  final String srs;
  @override
  final BuiltList<RankingComponent> components;

  factory _$RankingExplanation(
          [void Function(RankingExplanationBuilder)? updates]) =>
      (RankingExplanationBuilder()..update(updates))._build();

  _$RankingExplanation._({required this.srs, required this.components})
      : super._();
  @override
  RankingExplanation rebuild(
          void Function(RankingExplanationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingExplanationBuilder toBuilder() =>
      RankingExplanationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingExplanation &&
        srs == other.srs &&
        components == other.components;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, srs.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RankingExplanation')
          ..add('srs', srs)
          ..add('components', components))
        .toString();
  }
}

class RankingExplanationBuilder
    implements Builder<RankingExplanation, RankingExplanationBuilder> {
  _$RankingExplanation? _$v;

  String? _srs;
  String? get srs => _$this._srs;
  set srs(String? srs) => _$this._srs = srs;

  ListBuilder<RankingComponent>? _components;
  ListBuilder<RankingComponent> get components =>
      _$this._components ??= ListBuilder<RankingComponent>();
  set components(ListBuilder<RankingComponent>? components) =>
      _$this._components = components;

  RankingExplanationBuilder() {
    RankingExplanation._defaults(this);
  }

  RankingExplanationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _srs = $v.srs;
      _components = $v.components.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankingExplanation other) {
    _$v = other as _$RankingExplanation;
  }

  @override
  void update(void Function(RankingExplanationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingExplanation build() => _build();

  _$RankingExplanation _build() {
    _$RankingExplanation _$result;
    try {
      _$result = _$v ??
          _$RankingExplanation._(
            srs: BuiltValueNullFieldError.checkNotNull(
                srs, r'RankingExplanation', 'srs'),
            components: components.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'components';
        components.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RankingExplanation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
