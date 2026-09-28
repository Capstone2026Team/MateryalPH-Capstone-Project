// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_comparability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InventoryComparabilityStatusEnum
    _$inventoryComparabilityStatusEnum_COMPARABLE =
    const InventoryComparabilityStatusEnum._('COMPARABLE');
const InventoryComparabilityStatusEnum
    _$inventoryComparabilityStatusEnum_NOT_YET_COMPARABLE =
    const InventoryComparabilityStatusEnum._('NOT_YET_COMPARABLE');

InventoryComparabilityStatusEnum _$inventoryComparabilityStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'COMPARABLE':
      return _$inventoryComparabilityStatusEnum_COMPARABLE;
    case 'NOT_YET_COMPARABLE':
      return _$inventoryComparabilityStatusEnum_NOT_YET_COMPARABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventoryComparabilityStatusEnum>
    _$inventoryComparabilityStatusEnumValues = BuiltSet<
        InventoryComparabilityStatusEnum>(const <InventoryComparabilityStatusEnum>[
  _$inventoryComparabilityStatusEnum_COMPARABLE,
  _$inventoryComparabilityStatusEnum_NOT_YET_COMPARABLE,
]);

Serializer<InventoryComparabilityStatusEnum>
    _$inventoryComparabilityStatusEnumSerializer =
    _$InventoryComparabilityStatusEnumSerializer();

class _$InventoryComparabilityStatusEnumSerializer
    implements PrimitiveSerializer<InventoryComparabilityStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPARABLE': 'COMPARABLE',
    'NOT_YET_COMPARABLE': 'NOT_YET_COMPARABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPARABLE': 'COMPARABLE',
    'NOT_YET_COMPARABLE': 'NOT_YET_COMPARABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[InventoryComparabilityStatusEnum];
  @override
  final String wireName = 'InventoryComparabilityStatusEnum';

  @override
  Object serialize(
          Serializers serializers, InventoryComparabilityStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventoryComparabilityStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventoryComparabilityStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventoryComparability extends InventoryComparability {
  @override
  final InventoryComparabilityStatusEnum status;
  @override
  final String? groupVersionId;
  @override
  final String ruleVersion;

  factory _$InventoryComparability(
          [void Function(InventoryComparabilityBuilder)? updates]) =>
      (InventoryComparabilityBuilder()..update(updates))._build();

  _$InventoryComparability._(
      {required this.status, this.groupVersionId, required this.ruleVersion})
      : super._();
  @override
  InventoryComparability rebuild(
          void Function(InventoryComparabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryComparabilityBuilder toBuilder() =>
      InventoryComparabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryComparability &&
        status == other.status &&
        groupVersionId == other.groupVersionId &&
        ruleVersion == other.ruleVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, groupVersionId.hashCode);
    _$hash = $jc(_$hash, ruleVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryComparability')
          ..add('status', status)
          ..add('groupVersionId', groupVersionId)
          ..add('ruleVersion', ruleVersion))
        .toString();
  }
}

class InventoryComparabilityBuilder
    implements Builder<InventoryComparability, InventoryComparabilityBuilder> {
  _$InventoryComparability? _$v;

  InventoryComparabilityStatusEnum? _status;
  InventoryComparabilityStatusEnum? get status => _$this._status;
  set status(InventoryComparabilityStatusEnum? status) =>
      _$this._status = status;

  String? _groupVersionId;
  String? get groupVersionId => _$this._groupVersionId;
  set groupVersionId(String? groupVersionId) =>
      _$this._groupVersionId = groupVersionId;

  String? _ruleVersion;
  String? get ruleVersion => _$this._ruleVersion;
  set ruleVersion(String? ruleVersion) => _$this._ruleVersion = ruleVersion;

  InventoryComparabilityBuilder() {
    InventoryComparability._defaults(this);
  }

  InventoryComparabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _groupVersionId = $v.groupVersionId;
      _ruleVersion = $v.ruleVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryComparability other) {
    _$v = other as _$InventoryComparability;
  }

  @override
  void update(void Function(InventoryComparabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryComparability build() => _build();

  _$InventoryComparability _build() {
    final _$result = _$v ??
        _$InventoryComparability._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'InventoryComparability', 'status'),
          groupVersionId: groupVersionId,
          ruleVersion: BuiltValueNullFieldError.checkNotNull(
              ruleVersion, r'InventoryComparability', 'ruleVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
