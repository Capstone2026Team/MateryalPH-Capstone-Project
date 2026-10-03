// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_nrpc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MoneyNrpcWithinOrderValueEnum _$moneyNrpcWithinOrderValueEnum_true_ =
    const MoneyNrpcWithinOrderValueEnum._('true_');

MoneyNrpcWithinOrderValueEnum _$moneyNrpcWithinOrderValueEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$moneyNrpcWithinOrderValueEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyNrpcWithinOrderValueEnum>
    _$moneyNrpcWithinOrderValueEnumValues = BuiltSet<
        MoneyNrpcWithinOrderValueEnum>(const <MoneyNrpcWithinOrderValueEnum>[
  _$moneyNrpcWithinOrderValueEnum_true_,
]);

const MoneyNrpcStatusEnum _$moneyNrpcStatusEnum_PROPOSED =
    const MoneyNrpcStatusEnum._('PROPOSED');
const MoneyNrpcStatusEnum _$moneyNrpcStatusEnum_ACCEPTED =
    const MoneyNrpcStatusEnum._('ACCEPTED');
const MoneyNrpcStatusEnum _$moneyNrpcStatusEnum_REJECTED =
    const MoneyNrpcStatusEnum._('REJECTED');

MoneyNrpcStatusEnum _$moneyNrpcStatusEnumValueOf(String name) {
  switch (name) {
    case 'PROPOSED':
      return _$moneyNrpcStatusEnum_PROPOSED;
    case 'ACCEPTED':
      return _$moneyNrpcStatusEnum_ACCEPTED;
    case 'REJECTED':
      return _$moneyNrpcStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MoneyNrpcStatusEnum> _$moneyNrpcStatusEnumValues =
    BuiltSet<MoneyNrpcStatusEnum>(const <MoneyNrpcStatusEnum>[
  _$moneyNrpcStatusEnum_PROPOSED,
  _$moneyNrpcStatusEnum_ACCEPTED,
  _$moneyNrpcStatusEnum_REJECTED,
]);

Serializer<MoneyNrpcWithinOrderValueEnum>
    _$moneyNrpcWithinOrderValueEnumSerializer =
    _$MoneyNrpcWithinOrderValueEnumSerializer();
Serializer<MoneyNrpcStatusEnum> _$moneyNrpcStatusEnumSerializer =
    _$MoneyNrpcStatusEnumSerializer();

class _$MoneyNrpcWithinOrderValueEnumSerializer
    implements PrimitiveSerializer<MoneyNrpcWithinOrderValueEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyNrpcWithinOrderValueEnum];
  @override
  final String wireName = 'MoneyNrpcWithinOrderValueEnum';

  @override
  Object serialize(
          Serializers serializers, MoneyNrpcWithinOrderValueEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyNrpcWithinOrderValueEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyNrpcWithinOrderValueEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyNrpcStatusEnumSerializer
    implements PrimitiveSerializer<MoneyNrpcStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROPOSED': 'PROPOSED',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROPOSED': 'PROPOSED',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[MoneyNrpcStatusEnum];
  @override
  final String wireName = 'MoneyNrpcStatusEnum';

  @override
  Object serialize(Serializers serializers, MoneyNrpcStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MoneyNrpcStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MoneyNrpcStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MoneyNrpc extends MoneyNrpc {
  @override
  final int amountCentavos;
  @override
  final MoneyNrpcWithinOrderValueEnum withinOrderValue;
  @override
  final MoneyNrpcStatusEnum? status;

  factory _$MoneyNrpc([void Function(MoneyNrpcBuilder)? updates]) =>
      (MoneyNrpcBuilder()..update(updates))._build();

  _$MoneyNrpc._(
      {required this.amountCentavos,
      required this.withinOrderValue,
      this.status})
      : super._();
  @override
  MoneyNrpc rebuild(void Function(MoneyNrpcBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoneyNrpcBuilder toBuilder() => MoneyNrpcBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoneyNrpc &&
        amountCentavos == other.amountCentavos &&
        withinOrderValue == other.withinOrderValue &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, withinOrderValue.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MoneyNrpc')
          ..add('amountCentavos', amountCentavos)
          ..add('withinOrderValue', withinOrderValue)
          ..add('status', status))
        .toString();
  }
}

class MoneyNrpcBuilder implements Builder<MoneyNrpc, MoneyNrpcBuilder> {
  _$MoneyNrpc? _$v;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  MoneyNrpcWithinOrderValueEnum? _withinOrderValue;
  MoneyNrpcWithinOrderValueEnum? get withinOrderValue =>
      _$this._withinOrderValue;
  set withinOrderValue(MoneyNrpcWithinOrderValueEnum? withinOrderValue) =>
      _$this._withinOrderValue = withinOrderValue;

  MoneyNrpcStatusEnum? _status;
  MoneyNrpcStatusEnum? get status => _$this._status;
  set status(MoneyNrpcStatusEnum? status) => _$this._status = status;

  MoneyNrpcBuilder() {
    MoneyNrpc._defaults(this);
  }

  MoneyNrpcBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amountCentavos = $v.amountCentavos;
      _withinOrderValue = $v.withinOrderValue;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MoneyNrpc other) {
    _$v = other as _$MoneyNrpc;
  }

  @override
  void update(void Function(MoneyNrpcBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MoneyNrpc build() => _build();

  _$MoneyNrpc _build() {
    final _$result = _$v ??
        _$MoneyNrpc._(
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'MoneyNrpc', 'amountCentavos'),
          withinOrderValue: BuiltValueNullFieldError.checkNotNull(
              withinOrderValue, r'MoneyNrpc', 'withinOrderValue'),
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
