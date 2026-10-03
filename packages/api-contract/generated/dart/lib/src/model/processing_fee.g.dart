// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_fee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProcessingFeeStatusEnum
    _$processingFeeStatusEnum_PENDING_PAYMENT_CHANNEL =
    const ProcessingFeeStatusEnum._('PENDING_PAYMENT_CHANNEL');
const ProcessingFeeStatusEnum _$processingFeeStatusEnum_QUOTED =
    const ProcessingFeeStatusEnum._('QUOTED');
const ProcessingFeeStatusEnum _$processingFeeStatusEnum_NOT_APPLICABLE =
    const ProcessingFeeStatusEnum._('NOT_APPLICABLE');
const ProcessingFeeStatusEnum _$processingFeeStatusEnum_PAID =
    const ProcessingFeeStatusEnum._('PAID');

ProcessingFeeStatusEnum _$processingFeeStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING_PAYMENT_CHANNEL':
      return _$processingFeeStatusEnum_PENDING_PAYMENT_CHANNEL;
    case 'QUOTED':
      return _$processingFeeStatusEnum_QUOTED;
    case 'NOT_APPLICABLE':
      return _$processingFeeStatusEnum_NOT_APPLICABLE;
    case 'PAID':
      return _$processingFeeStatusEnum_PAID;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProcessingFeeStatusEnum> _$processingFeeStatusEnumValues =
    BuiltSet<ProcessingFeeStatusEnum>(const <ProcessingFeeStatusEnum>[
  _$processingFeeStatusEnum_PENDING_PAYMENT_CHANNEL,
  _$processingFeeStatusEnum_QUOTED,
  _$processingFeeStatusEnum_NOT_APPLICABLE,
  _$processingFeeStatusEnum_PAID,
]);

Serializer<ProcessingFeeStatusEnum> _$processingFeeStatusEnumSerializer =
    _$ProcessingFeeStatusEnumSerializer();

class _$ProcessingFeeStatusEnumSerializer
    implements PrimitiveSerializer<ProcessingFeeStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING_PAYMENT_CHANNEL': 'PENDING_PAYMENT_CHANNEL',
    'QUOTED': 'QUOTED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'PAID': 'PAID',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING_PAYMENT_CHANNEL': 'PENDING_PAYMENT_CHANNEL',
    'QUOTED': 'QUOTED',
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'PAID': 'PAID',
  };

  @override
  final Iterable<Type> types = const <Type>[ProcessingFeeStatusEnum];
  @override
  final String wireName = 'ProcessingFeeStatusEnum';

  @override
  Object serialize(Serializers serializers, ProcessingFeeStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProcessingFeeStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProcessingFeeStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProcessingFee extends ProcessingFee {
  @override
  final ProcessingFeeStatusEnum status;
  @override
  final int? amountCentavos;

  factory _$ProcessingFee([void Function(ProcessingFeeBuilder)? updates]) =>
      (ProcessingFeeBuilder()..update(updates))._build();

  _$ProcessingFee._({required this.status, this.amountCentavos}) : super._();
  @override
  ProcessingFee rebuild(void Function(ProcessingFeeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProcessingFeeBuilder toBuilder() => ProcessingFeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProcessingFee &&
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
    return (newBuiltValueToStringHelper(r'ProcessingFee')
          ..add('status', status)
          ..add('amountCentavos', amountCentavos))
        .toString();
  }
}

class ProcessingFeeBuilder
    implements Builder<ProcessingFee, ProcessingFeeBuilder> {
  _$ProcessingFee? _$v;

  ProcessingFeeStatusEnum? _status;
  ProcessingFeeStatusEnum? get status => _$this._status;
  set status(ProcessingFeeStatusEnum? status) => _$this._status = status;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  ProcessingFeeBuilder() {
    ProcessingFee._defaults(this);
  }

  ProcessingFeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _amountCentavos = $v.amountCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProcessingFee other) {
    _$v = other as _$ProcessingFee;
  }

  @override
  void update(void Function(ProcessingFeeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProcessingFee build() => _build();

  _$ProcessingFee _build() {
    final _$result = _$v ??
        _$ProcessingFee._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProcessingFee', 'status'),
          amountCentavos: amountCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
