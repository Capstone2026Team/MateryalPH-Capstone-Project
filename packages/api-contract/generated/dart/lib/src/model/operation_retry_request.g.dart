// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_retry_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperationRetryRequestTargetTypeEnum
    _$operationRetryRequestTargetTypeEnum_FAILED_JOB =
    const OperationRetryRequestTargetTypeEnum._('FAILED_JOB');
const OperationRetryRequestTargetTypeEnum
    _$operationRetryRequestTargetTypeEnum_OUTBOX_EVENT =
    const OperationRetryRequestTargetTypeEnum._('OUTBOX_EVENT');
const OperationRetryRequestTargetTypeEnum
    _$operationRetryRequestTargetTypeEnum_GEO_FACTS_RUN =
    const OperationRetryRequestTargetTypeEnum._('GEO_FACTS_RUN');
const OperationRetryRequestTargetTypeEnum
    _$operationRetryRequestTargetTypeEnum_MATERIAL_SNAPSHOT =
    const OperationRetryRequestTargetTypeEnum._('MATERIAL_SNAPSHOT');

OperationRetryRequestTargetTypeEnum
    _$operationRetryRequestTargetTypeEnumValueOf(String name) {
  switch (name) {
    case 'FAILED_JOB':
      return _$operationRetryRequestTargetTypeEnum_FAILED_JOB;
    case 'OUTBOX_EVENT':
      return _$operationRetryRequestTargetTypeEnum_OUTBOX_EVENT;
    case 'GEO_FACTS_RUN':
      return _$operationRetryRequestTargetTypeEnum_GEO_FACTS_RUN;
    case 'MATERIAL_SNAPSHOT':
      return _$operationRetryRequestTargetTypeEnum_MATERIAL_SNAPSHOT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperationRetryRequestTargetTypeEnum>
    _$operationRetryRequestTargetTypeEnumValues = BuiltSet<
        OperationRetryRequestTargetTypeEnum>(const <OperationRetryRequestTargetTypeEnum>[
  _$operationRetryRequestTargetTypeEnum_FAILED_JOB,
  _$operationRetryRequestTargetTypeEnum_OUTBOX_EVENT,
  _$operationRetryRequestTargetTypeEnum_GEO_FACTS_RUN,
  _$operationRetryRequestTargetTypeEnum_MATERIAL_SNAPSHOT,
]);

Serializer<OperationRetryRequestTargetTypeEnum>
    _$operationRetryRequestTargetTypeEnumSerializer =
    _$OperationRetryRequestTargetTypeEnumSerializer();

class _$OperationRetryRequestTargetTypeEnumSerializer
    implements PrimitiveSerializer<OperationRetryRequestTargetTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FAILED_JOB': 'FAILED_JOB',
    'OUTBOX_EVENT': 'OUTBOX_EVENT',
    'GEO_FACTS_RUN': 'GEO_FACTS_RUN',
    'MATERIAL_SNAPSHOT': 'MATERIAL_SNAPSHOT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FAILED_JOB': 'FAILED_JOB',
    'OUTBOX_EVENT': 'OUTBOX_EVENT',
    'GEO_FACTS_RUN': 'GEO_FACTS_RUN',
    'MATERIAL_SNAPSHOT': 'MATERIAL_SNAPSHOT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OperationRetryRequestTargetTypeEnum
  ];
  @override
  final String wireName = 'OperationRetryRequestTargetTypeEnum';

  @override
  Object serialize(
          Serializers serializers, OperationRetryRequestTargetTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperationRetryRequestTargetTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperationRetryRequestTargetTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperationRetryRequest extends OperationRetryRequest {
  @override
  final OperationRetryRequestTargetTypeEnum targetType;
  @override
  final String reference;
  @override
  final String reason;

  factory _$OperationRetryRequest(
          [void Function(OperationRetryRequestBuilder)? updates]) =>
      (OperationRetryRequestBuilder()..update(updates))._build();

  _$OperationRetryRequest._(
      {required this.targetType, required this.reference, required this.reason})
      : super._();
  @override
  OperationRetryRequest rebuild(
          void Function(OperationRetryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationRetryRequestBuilder toBuilder() =>
      OperationRetryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationRetryRequest &&
        targetType == other.targetType &&
        reference == other.reference &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperationRetryRequest')
          ..add('targetType', targetType)
          ..add('reference', reference)
          ..add('reason', reason))
        .toString();
  }
}

class OperationRetryRequestBuilder
    implements Builder<OperationRetryRequest, OperationRetryRequestBuilder> {
  _$OperationRetryRequest? _$v;

  OperationRetryRequestTargetTypeEnum? _targetType;
  OperationRetryRequestTargetTypeEnum? get targetType => _$this._targetType;
  set targetType(OperationRetryRequestTargetTypeEnum? targetType) =>
      _$this._targetType = targetType;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  OperationRetryRequestBuilder() {
    OperationRetryRequest._defaults(this);
  }

  OperationRetryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetType = $v.targetType;
      _reference = $v.reference;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperationRetryRequest other) {
    _$v = other as _$OperationRetryRequest;
  }

  @override
  void update(void Function(OperationRetryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationRetryRequest build() => _build();

  _$OperationRetryRequest _build() {
    final _$result = _$v ??
        _$OperationRetryRequest._(
          targetType: BuiltValueNullFieldError.checkNotNull(
              targetType, r'OperationRetryRequest', 'targetType'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'OperationRetryRequest', 'reference'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'OperationRetryRequest', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
