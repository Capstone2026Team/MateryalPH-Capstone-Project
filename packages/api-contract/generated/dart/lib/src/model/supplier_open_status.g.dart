// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_open_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupplierOpenStatusStatusEnum _$supplierOpenStatusStatusEnum_OPEN =
    const SupplierOpenStatusStatusEnum._('OPEN');
const SupplierOpenStatusStatusEnum _$supplierOpenStatusStatusEnum_CLOSED =
    const SupplierOpenStatusStatusEnum._('CLOSED');
const SupplierOpenStatusStatusEnum _$supplierOpenStatusStatusEnum_UNAVAILABLE =
    const SupplierOpenStatusStatusEnum._('UNAVAILABLE');

SupplierOpenStatusStatusEnum _$supplierOpenStatusStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'OPEN':
      return _$supplierOpenStatusStatusEnum_OPEN;
    case 'CLOSED':
      return _$supplierOpenStatusStatusEnum_CLOSED;
    case 'UNAVAILABLE':
      return _$supplierOpenStatusStatusEnum_UNAVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupplierOpenStatusStatusEnum>
    _$supplierOpenStatusStatusEnumValues =
    BuiltSet<SupplierOpenStatusStatusEnum>(const <SupplierOpenStatusStatusEnum>[
  _$supplierOpenStatusStatusEnum_OPEN,
  _$supplierOpenStatusStatusEnum_CLOSED,
  _$supplierOpenStatusStatusEnum_UNAVAILABLE,
]);

const SupplierOpenStatusBasisEnum _$supplierOpenStatusBasisEnum_SAVED_SCHEDULE =
    const SupplierOpenStatusBasisEnum._('SAVED_SCHEDULE');
const SupplierOpenStatusBasisEnum _$supplierOpenStatusBasisEnum_DATE_OVERRIDE =
    const SupplierOpenStatusBasisEnum._('DATE_OVERRIDE');

SupplierOpenStatusBasisEnum _$supplierOpenStatusBasisEnumValueOf(String name) {
  switch (name) {
    case 'SAVED_SCHEDULE':
      return _$supplierOpenStatusBasisEnum_SAVED_SCHEDULE;
    case 'DATE_OVERRIDE':
      return _$supplierOpenStatusBasisEnum_DATE_OVERRIDE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupplierOpenStatusBasisEnum>
    _$supplierOpenStatusBasisEnumValues =
    BuiltSet<SupplierOpenStatusBasisEnum>(const <SupplierOpenStatusBasisEnum>[
  _$supplierOpenStatusBasisEnum_SAVED_SCHEDULE,
  _$supplierOpenStatusBasisEnum_DATE_OVERRIDE,
]);

Serializer<SupplierOpenStatusStatusEnum>
    _$supplierOpenStatusStatusEnumSerializer =
    _$SupplierOpenStatusStatusEnumSerializer();
Serializer<SupplierOpenStatusBasisEnum>
    _$supplierOpenStatusBasisEnumSerializer =
    _$SupplierOpenStatusBasisEnumSerializer();

class _$SupplierOpenStatusStatusEnumSerializer
    implements PrimitiveSerializer<SupplierOpenStatusStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
    'UNAVAILABLE': 'UNAVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'CLOSED': 'CLOSED',
    'UNAVAILABLE': 'UNAVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[SupplierOpenStatusStatusEnum];
  @override
  final String wireName = 'SupplierOpenStatusStatusEnum';

  @override
  Object serialize(Serializers serializers, SupplierOpenStatusStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupplierOpenStatusStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupplierOpenStatusStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SupplierOpenStatusBasisEnumSerializer
    implements PrimitiveSerializer<SupplierOpenStatusBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SAVED_SCHEDULE': 'SAVED_SCHEDULE',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SAVED_SCHEDULE': 'SAVED_SCHEDULE',
    'DATE_OVERRIDE': 'DATE_OVERRIDE',
  };

  @override
  final Iterable<Type> types = const <Type>[SupplierOpenStatusBasisEnum];
  @override
  final String wireName = 'SupplierOpenStatusBasisEnum';

  @override
  Object serialize(Serializers serializers, SupplierOpenStatusBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupplierOpenStatusBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupplierOpenStatusBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SupplierOpenStatus extends SupplierOpenStatus {
  @override
  final SupplierOpenStatusStatusEnum status;
  @override
  final String? opensAt;
  @override
  final String? closesAt;
  @override
  final SupplierOpenStatusBasisEnum basis;

  factory _$SupplierOpenStatus(
          [void Function(SupplierOpenStatusBuilder)? updates]) =>
      (SupplierOpenStatusBuilder()..update(updates))._build();

  _$SupplierOpenStatus._(
      {required this.status, this.opensAt, this.closesAt, required this.basis})
      : super._();
  @override
  SupplierOpenStatus rebuild(
          void Function(SupplierOpenStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupplierOpenStatusBuilder toBuilder() =>
      SupplierOpenStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupplierOpenStatus &&
        status == other.status &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt &&
        basis == other.basis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, basis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupplierOpenStatus')
          ..add('status', status)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt)
          ..add('basis', basis))
        .toString();
  }
}

class SupplierOpenStatusBuilder
    implements Builder<SupplierOpenStatus, SupplierOpenStatusBuilder> {
  _$SupplierOpenStatus? _$v;

  SupplierOpenStatusStatusEnum? _status;
  SupplierOpenStatusStatusEnum? get status => _$this._status;
  set status(SupplierOpenStatusStatusEnum? status) => _$this._status = status;

  String? _opensAt;
  String? get opensAt => _$this._opensAt;
  set opensAt(String? opensAt) => _$this._opensAt = opensAt;

  String? _closesAt;
  String? get closesAt => _$this._closesAt;
  set closesAt(String? closesAt) => _$this._closesAt = closesAt;

  SupplierOpenStatusBasisEnum? _basis;
  SupplierOpenStatusBasisEnum? get basis => _$this._basis;
  set basis(SupplierOpenStatusBasisEnum? basis) => _$this._basis = basis;

  SupplierOpenStatusBuilder() {
    SupplierOpenStatus._defaults(this);
  }

  SupplierOpenStatusBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _basis = $v.basis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupplierOpenStatus other) {
    _$v = other as _$SupplierOpenStatus;
  }

  @override
  void update(void Function(SupplierOpenStatusBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupplierOpenStatus build() => _build();

  _$SupplierOpenStatus _build() {
    final _$result = _$v ??
        _$SupplierOpenStatus._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SupplierOpenStatus', 'status'),
          opensAt: opensAt,
          closesAt: closesAt,
          basis: BuiltValueNullFieldError.checkNotNull(
              basis, r'SupplierOpenStatus', 'basis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
