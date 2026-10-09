// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_retry_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperationRetryResultOutcomeEnum _$operationRetryResultOutcomeEnum_QUEUED =
    const OperationRetryResultOutcomeEnum._('QUEUED');

OperationRetryResultOutcomeEnum _$operationRetryResultOutcomeEnumValueOf(
    String name) {
  switch (name) {
    case 'QUEUED':
      return _$operationRetryResultOutcomeEnum_QUEUED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperationRetryResultOutcomeEnum>
    _$operationRetryResultOutcomeEnumValues = BuiltSet<
        OperationRetryResultOutcomeEnum>(const <OperationRetryResultOutcomeEnum>[
  _$operationRetryResultOutcomeEnum_QUEUED,
]);

Serializer<OperationRetryResultOutcomeEnum>
    _$operationRetryResultOutcomeEnumSerializer =
    _$OperationRetryResultOutcomeEnumSerializer();

class _$OperationRetryResultOutcomeEnumSerializer
    implements PrimitiveSerializer<OperationRetryResultOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'QUEUED': 'QUEUED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'QUEUED': 'QUEUED',
  };

  @override
  final Iterable<Type> types = const <Type>[OperationRetryResultOutcomeEnum];
  @override
  final String wireName = 'OperationRetryResultOutcomeEnum';

  @override
  Object serialize(
          Serializers serializers, OperationRetryResultOutcomeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperationRetryResultOutcomeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperationRetryResultOutcomeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperationRetryResult extends OperationRetryResult {
  @override
  final String targetType;
  @override
  final String reference;
  @override
  final String label;
  @override
  final OperationRetryResultOutcomeEnum outcome;
  @override
  final String correlationId;

  factory _$OperationRetryResult(
          [void Function(OperationRetryResultBuilder)? updates]) =>
      (OperationRetryResultBuilder()..update(updates))._build();

  _$OperationRetryResult._(
      {required this.targetType,
      required this.reference,
      required this.label,
      required this.outcome,
      required this.correlationId})
      : super._();
  @override
  OperationRetryResult rebuild(
          void Function(OperationRetryResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationRetryResultBuilder toBuilder() =>
      OperationRetryResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationRetryResult &&
        targetType == other.targetType &&
        reference == other.reference &&
        label == other.label &&
        outcome == other.outcome &&
        correlationId == other.correlationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperationRetryResult')
          ..add('targetType', targetType)
          ..add('reference', reference)
          ..add('label', label)
          ..add('outcome', outcome)
          ..add('correlationId', correlationId))
        .toString();
  }
}

class OperationRetryResultBuilder
    implements Builder<OperationRetryResult, OperationRetryResultBuilder> {
  _$OperationRetryResult? _$v;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  OperationRetryResultOutcomeEnum? _outcome;
  OperationRetryResultOutcomeEnum? get outcome => _$this._outcome;
  set outcome(OperationRetryResultOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  OperationRetryResultBuilder() {
    OperationRetryResult._defaults(this);
  }

  OperationRetryResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetType = $v.targetType;
      _reference = $v.reference;
      _label = $v.label;
      _outcome = $v.outcome;
      _correlationId = $v.correlationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperationRetryResult other) {
    _$v = other as _$OperationRetryResult;
  }

  @override
  void update(void Function(OperationRetryResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationRetryResult build() => _build();

  _$OperationRetryResult _build() {
    final _$result = _$v ??
        _$OperationRetryResult._(
          targetType: BuiltValueNullFieldError.checkNotNull(
              targetType, r'OperationRetryResult', 'targetType'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'OperationRetryResult', 'reference'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'OperationRetryResult', 'label'),
          outcome: BuiltValueNullFieldError.checkNotNull(
              outcome, r'OperationRetryResult', 'outcome'),
          correlationId: BuiltValueNullFieldError.checkNotNull(
              correlationId, r'OperationRetryResult', 'correlationId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
