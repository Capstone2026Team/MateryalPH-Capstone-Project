// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_fee_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProcessingFeeAmountStatusEnum
    _$processingFeeAmountStatusEnum_PENDING_PAYMENT_CHANNEL =
    const ProcessingFeeAmountStatusEnum._('PENDING_PAYMENT_CHANNEL');

ProcessingFeeAmountStatusEnum _$processingFeeAmountStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING_PAYMENT_CHANNEL':
      return _$processingFeeAmountStatusEnum_PENDING_PAYMENT_CHANNEL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProcessingFeeAmountStatusEnum>
    _$processingFeeAmountStatusEnumValues = BuiltSet<
        ProcessingFeeAmountStatusEnum>(const <ProcessingFeeAmountStatusEnum>[
  _$processingFeeAmountStatusEnum_PENDING_PAYMENT_CHANNEL,
]);

Serializer<ProcessingFeeAmountStatusEnum>
    _$processingFeeAmountStatusEnumSerializer =
    _$ProcessingFeeAmountStatusEnumSerializer();

class _$ProcessingFeeAmountStatusEnumSerializer
    implements PrimitiveSerializer<ProcessingFeeAmountStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_PAYMENT_CHANNEL': 'PENDING_PAYMENT_CHANNEL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_PAYMENT_CHANNEL': 'PENDING_PAYMENT_CHANNEL',
  };

  @override
  final Iterable<Type> types = const <Type>[ProcessingFeeAmountStatusEnum];
  @override
  final String wireName = 'ProcessingFeeAmountStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProcessingFeeAmountStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProcessingFeeAmountStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProcessingFeeAmountStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProcessingFeeAmount extends ProcessingFeeAmount {
  @override
  final ProcessingFeeAmountStatusEnum status;
  @override
  final int? amountCentavos;

  factory _$ProcessingFeeAmount(
          [void Function(ProcessingFeeAmountBuilder)? updates]) =>
      (ProcessingFeeAmountBuilder()..update(updates))._build();

  _$ProcessingFeeAmount._({required this.status, this.amountCentavos})
      : super._();
  @override
  ProcessingFeeAmount rebuild(
          void Function(ProcessingFeeAmountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProcessingFeeAmountBuilder toBuilder() =>
      ProcessingFeeAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProcessingFeeAmount &&
        status == other.status &&
        amountCentavos == other.amountCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProcessingFeeAmount')
          ..add('status', status)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class ProcessingFeeAmountBuilder
    implements Builder<ProcessingFeeAmount, ProcessingFeeAmountBuilder> {
  _$ProcessingFeeAmount? _$v;

  ProcessingFeeAmountStatusEnum? _status;
  ProcessingFeeAmountStatusEnum? get status => _$this._status;
  set status(ProcessingFeeAmountStatusEnum? status) => _$this._status = status;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  ProcessingFeeAmountBuilder() {
    ProcessingFeeAmount._defaults(this);
  }

  ProcessingFeeAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _amountCentavos = $v.amountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProcessingFeeAmount other) {
    _$v = other as _$ProcessingFeeAmount;
  }

  @override
  void update(void Function(ProcessingFeeAmountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProcessingFeeAmount build() => _build();

  _$ProcessingFeeAmount _build() {
    final _$result = _$v ??
        _$ProcessingFeeAmount._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProcessingFeeAmount', 'status'),
          amountCentavos: amountCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
