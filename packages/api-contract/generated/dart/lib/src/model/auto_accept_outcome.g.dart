// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_accept_outcome.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AutoAcceptOutcomeRoutedToEnum
    _$autoAcceptOutcomeRoutedToEnum_MANUAL_REVIEW =
    const AutoAcceptOutcomeRoutedToEnum._('MANUAL_REVIEW');

AutoAcceptOutcomeRoutedToEnum _$autoAcceptOutcomeRoutedToEnumValueOf(
    String name) {
  switch (name) {
    case 'MANUAL_REVIEW':
      return _$autoAcceptOutcomeRoutedToEnum_MANUAL_REVIEW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AutoAcceptOutcomeRoutedToEnum>
    _$autoAcceptOutcomeRoutedToEnumValues = BuiltSet<
        AutoAcceptOutcomeRoutedToEnum>(const <AutoAcceptOutcomeRoutedToEnum>[
  _$autoAcceptOutcomeRoutedToEnum_MANUAL_REVIEW,
]);

Serializer<AutoAcceptOutcomeRoutedToEnum>
    _$autoAcceptOutcomeRoutedToEnumSerializer =
    _$AutoAcceptOutcomeRoutedToEnumSerializer();

class _$AutoAcceptOutcomeRoutedToEnumSerializer
    implements PrimitiveSerializer<AutoAcceptOutcomeRoutedToEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MANUAL_REVIEW': 'MANUAL_REVIEW',
  };

  @override
  final Iterable<Type> types = const <Type>[AutoAcceptOutcomeRoutedToEnum];
  @override
  final String wireName = 'AutoAcceptOutcomeRoutedToEnum';

  @override
  Object serialize(
          Serializers serializers, AutoAcceptOutcomeRoutedToEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AutoAcceptOutcomeRoutedToEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AutoAcceptOutcomeRoutedToEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AutoAcceptOutcome extends AutoAcceptOutcome {
  @override
  final bool accepted;
  @override
  final AutoAcceptOutcomeRoutedToEnum? routedTo;
  @override
  final BuiltList<AutoAcceptReason> reasons;
  @override
  final String ruleVersion;
  @override
  final DateTime evaluatedAt;

  factory _$AutoAcceptOutcome(
          [void Function(AutoAcceptOutcomeBuilder)? updates]) =>
      (AutoAcceptOutcomeBuilder()..update(updates))._build();

  _$AutoAcceptOutcome._(
      {required this.accepted,
      this.routedTo,
      required this.reasons,
      required this.ruleVersion,
      required this.evaluatedAt})
      : super._();
  @override
  AutoAcceptOutcome rebuild(void Function(AutoAcceptOutcomeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AutoAcceptOutcomeBuilder toBuilder() =>
      AutoAcceptOutcomeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AutoAcceptOutcome &&
        accepted == other.accepted &&
        routedTo == other.routedTo &&
        reasons == other.reasons &&
        ruleVersion == other.ruleVersion &&
        evaluatedAt == other.evaluatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, routedTo.hashCode);
    _$hash = $jc(_$hash, reasons.hashCode);
    _$hash = $jc(_$hash, ruleVersion.hashCode);
    _$hash = $jc(_$hash, evaluatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AutoAcceptOutcome')
          ..add('accepted', accepted)
          ..add('routedTo', routedTo)
          ..add('reasons', reasons)
          ..add('ruleVersion', ruleVersion)
          ..add('evaluatedAt', evaluatedAt))
        .toString();
  }
}

class AutoAcceptOutcomeBuilder
    implements Builder<AutoAcceptOutcome, AutoAcceptOutcomeBuilder> {
  _$AutoAcceptOutcome? _$v;

  bool? _accepted;
  bool? get accepted => _$this._accepted;
  set accepted(bool? accepted) => _$this._accepted = accepted;

  AutoAcceptOutcomeRoutedToEnum? _routedTo;
  AutoAcceptOutcomeRoutedToEnum? get routedTo => _$this._routedTo;
  set routedTo(AutoAcceptOutcomeRoutedToEnum? routedTo) =>
      _$this._routedTo = routedTo;

  ListBuilder<AutoAcceptReason>? _reasons;
  ListBuilder<AutoAcceptReason> get reasons =>
      _$this._reasons ??= ListBuilder<AutoAcceptReason>();
  set reasons(ListBuilder<AutoAcceptReason>? reasons) =>
      _$this._reasons = reasons;

  String? _ruleVersion;
  String? get ruleVersion => _$this._ruleVersion;
  set ruleVersion(String? ruleVersion) => _$this._ruleVersion = ruleVersion;

  DateTime? _evaluatedAt;
  DateTime? get evaluatedAt => _$this._evaluatedAt;
  set evaluatedAt(DateTime? evaluatedAt) => _$this._evaluatedAt = evaluatedAt;

  AutoAcceptOutcomeBuilder() {
    AutoAcceptOutcome._defaults(this);
  }

  AutoAcceptOutcomeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _routedTo = $v.routedTo;
      _reasons = $v.reasons.toBuilder();
      _ruleVersion = $v.ruleVersion;
      _evaluatedAt = $v.evaluatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AutoAcceptOutcome other) {
    _$v = other as _$AutoAcceptOutcome;
  }

  @override
  void update(void Function(AutoAcceptOutcomeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AutoAcceptOutcome build() => _build();

  _$AutoAcceptOutcome _build() {
    _$AutoAcceptOutcome _$result;
    try {
      _$result = _$v ??
          _$AutoAcceptOutcome._(
            accepted: BuiltValueNullFieldError.checkNotNull(
                accepted, r'AutoAcceptOutcome', 'accepted'),
            routedTo: routedTo,
            reasons: reasons.build(),
            ruleVersion: BuiltValueNullFieldError.checkNotNull(
                ruleVersion, r'AutoAcceptOutcome', 'ruleVersion'),
            evaluatedAt: BuiltValueNullFieldError.checkNotNull(
                evaluatedAt, r'AutoAcceptOutcome', 'evaluatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reasons';
        reasons.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AutoAcceptOutcome', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
