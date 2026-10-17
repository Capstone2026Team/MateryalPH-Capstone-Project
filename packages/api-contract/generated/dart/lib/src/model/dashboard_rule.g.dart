// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_rule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DashboardRule extends DashboardRule {
  @override
  final BuiltList<String> antecedent;
  @override
  final BuiltList<String> consequent;
  @override
  final num support;
  @override
  final int supportCount;
  @override
  final num confidence;
  @override
  final num lift;

  factory _$DashboardRule([void Function(DashboardRuleBuilder)? updates]) =>
      (DashboardRuleBuilder()..update(updates))._build();

  _$DashboardRule._(
      {required this.antecedent,
      required this.consequent,
      required this.support,
      required this.supportCount,
      required this.confidence,
      required this.lift})
      : super._();
  @override
  DashboardRule rebuild(void Function(DashboardRuleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardRuleBuilder toBuilder() => DashboardRuleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DashboardRule &&
        antecedent == other.antecedent &&
        consequent == other.consequent &&
        support == other.support &&
        supportCount == other.supportCount &&
        confidence == other.confidence &&
        lift == other.lift;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, antecedent.hashCode);
    _$hash = $jc(_$hash, consequent.hashCode);
    _$hash = $jc(_$hash, support.hashCode);
    _$hash = $jc(_$hash, supportCount.hashCode);
    _$hash = $jc(_$hash, confidence.hashCode);
    _$hash = $jc(_$hash, lift.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DashboardRule')
          ..add('antecedent', antecedent)
          ..add('consequent', consequent)
          ..add('support', support)
          ..add('supportCount', supportCount)
          ..add('confidence', confidence)
          ..add('lift', lift))
        .toString();
  }
}

class DashboardRuleBuilder
    implements Builder<DashboardRule, DashboardRuleBuilder> {
  _$DashboardRule? _$v;

  ListBuilder<String>? _antecedent;
  ListBuilder<String> get antecedent =>
      _$this._antecedent ??= ListBuilder<String>();
  set antecedent(ListBuilder<String>? antecedent) =>
      _$this._antecedent = antecedent;

  ListBuilder<String>? _consequent;
  ListBuilder<String> get consequent =>
      _$this._consequent ??= ListBuilder<String>();
  set consequent(ListBuilder<String>? consequent) =>
      _$this._consequent = consequent;

  num? _support;
  num? get support => _$this._support;
  set support(num? support) => _$this._support = support;

  int? _supportCount;
  int? get supportCount => _$this._supportCount;
  set supportCount(int? supportCount) => _$this._supportCount = supportCount;

  num? _confidence;
  num? get confidence => _$this._confidence;
  set confidence(num? confidence) => _$this._confidence = confidence;

  num? _lift;
  num? get lift => _$this._lift;
  set lift(num? lift) => _$this._lift = lift;

  DashboardRuleBuilder() {
    DashboardRule._defaults(this);
  }

  DashboardRuleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _antecedent = $v.antecedent.toBuilder();
      _consequent = $v.consequent.toBuilder();
      _support = $v.support;
      _supportCount = $v.supportCount;
      _confidence = $v.confidence;
      _lift = $v.lift;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DashboardRule other) {
    _$v = other as _$DashboardRule;
  }

  @override
  void update(void Function(DashboardRuleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DashboardRule build() => _build();

  _$DashboardRule _build() {
    _$DashboardRule _$result;
    try {
      _$result = _$v ??
          _$DashboardRule._(
            antecedent: antecedent.build(),
            consequent: consequent.build(),
            support: BuiltValueNullFieldError.checkNotNull(
                support, r'DashboardRule', 'support'),
            supportCount: BuiltValueNullFieldError.checkNotNull(
                supportCount, r'DashboardRule', 'supportCount'),
            confidence: BuiltValueNullFieldError.checkNotNull(
                confidence, r'DashboardRule', 'confidence'),
            lift: BuiltValueNullFieldError.checkNotNull(
                lift, r'DashboardRule', 'lift'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'antecedent';
        antecedent.build();
        _$failedField = 'consequent';
        consequent.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DashboardRule', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
