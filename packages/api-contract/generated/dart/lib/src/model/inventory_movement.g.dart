// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_movement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_INITIAL_COUNT =
    const InventoryMovementMovementTypeEnum._('INITIAL_COUNT');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_COUNT_ADJUSTMENT =
    const InventoryMovementMovementTypeEnum._('COUNT_ADJUSTMENT');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_RECEIVED =
    const InventoryMovementMovementTypeEnum._('RECEIVED');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_DAMAGED =
    const InventoryMovementMovementTypeEnum._('DAMAGED');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_LOST =
    const InventoryMovementMovementTypeEnum._('LOST');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_RETURNED =
    const InventoryMovementMovementTypeEnum._('RETURNED');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_CORRECTION =
    const InventoryMovementMovementTypeEnum._('CORRECTION');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_HARD_RESERVE =
    const InventoryMovementMovementTypeEnum._('HARD_RESERVE');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_HARD_RELEASE =
    const InventoryMovementMovementTypeEnum._('HARD_RELEASE');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_SOFT_HOLD =
    const InventoryMovementMovementTypeEnum._('SOFT_HOLD');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_SOFT_RELEASE =
    const InventoryMovementMovementTypeEnum._('SOFT_RELEASE');
const InventoryMovementMovementTypeEnum
    _$inventoryMovementMovementTypeEnum_FULFILLED =
    const InventoryMovementMovementTypeEnum._('FULFILLED');

InventoryMovementMovementTypeEnum _$inventoryMovementMovementTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'INITIAL_COUNT':
      return _$inventoryMovementMovementTypeEnum_INITIAL_COUNT;
    case 'COUNT_ADJUSTMENT':
      return _$inventoryMovementMovementTypeEnum_COUNT_ADJUSTMENT;
    case 'RECEIVED':
      return _$inventoryMovementMovementTypeEnum_RECEIVED;
    case 'DAMAGED':
      return _$inventoryMovementMovementTypeEnum_DAMAGED;
    case 'LOST':
      return _$inventoryMovementMovementTypeEnum_LOST;
    case 'RETURNED':
      return _$inventoryMovementMovementTypeEnum_RETURNED;
    case 'CORRECTION':
      return _$inventoryMovementMovementTypeEnum_CORRECTION;
    case 'HARD_RESERVE':
      return _$inventoryMovementMovementTypeEnum_HARD_RESERVE;
    case 'HARD_RELEASE':
      return _$inventoryMovementMovementTypeEnum_HARD_RELEASE;
    case 'SOFT_HOLD':
      return _$inventoryMovementMovementTypeEnum_SOFT_HOLD;
    case 'SOFT_RELEASE':
      return _$inventoryMovementMovementTypeEnum_SOFT_RELEASE;
    case 'FULFILLED':
      return _$inventoryMovementMovementTypeEnum_FULFILLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventoryMovementMovementTypeEnum>
    _$inventoryMovementMovementTypeEnumValues = BuiltSet<
        InventoryMovementMovementTypeEnum>(const <InventoryMovementMovementTypeEnum>[
  _$inventoryMovementMovementTypeEnum_INITIAL_COUNT,
  _$inventoryMovementMovementTypeEnum_COUNT_ADJUSTMENT,
  _$inventoryMovementMovementTypeEnum_RECEIVED,
  _$inventoryMovementMovementTypeEnum_DAMAGED,
  _$inventoryMovementMovementTypeEnum_LOST,
  _$inventoryMovementMovementTypeEnum_RETURNED,
  _$inventoryMovementMovementTypeEnum_CORRECTION,
  _$inventoryMovementMovementTypeEnum_HARD_RESERVE,
  _$inventoryMovementMovementTypeEnum_HARD_RELEASE,
  _$inventoryMovementMovementTypeEnum_SOFT_HOLD,
  _$inventoryMovementMovementTypeEnum_SOFT_RELEASE,
  _$inventoryMovementMovementTypeEnum_FULFILLED,
]);

Serializer<InventoryMovementMovementTypeEnum>
    _$inventoryMovementMovementTypeEnumSerializer =
    _$InventoryMovementMovementTypeEnumSerializer();

class _$InventoryMovementMovementTypeEnumSerializer
    implements PrimitiveSerializer<InventoryMovementMovementTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INITIAL_COUNT': 'INITIAL_COUNT',
    'COUNT_ADJUSTMENT': 'COUNT_ADJUSTMENT',
    'RECEIVED': 'RECEIVED',
    'DAMAGED': 'DAMAGED',
    'LOST': 'LOST',
    'RETURNED': 'RETURNED',
    'CORRECTION': 'CORRECTION',
    'HARD_RESERVE': 'HARD_RESERVE',
    'HARD_RELEASE': 'HARD_RELEASE',
    'SOFT_HOLD': 'SOFT_HOLD',
    'SOFT_RELEASE': 'SOFT_RELEASE',
    'FULFILLED': 'FULFILLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INITIAL_COUNT': 'INITIAL_COUNT',
    'COUNT_ADJUSTMENT': 'COUNT_ADJUSTMENT',
    'RECEIVED': 'RECEIVED',
    'DAMAGED': 'DAMAGED',
    'LOST': 'LOST',
    'RETURNED': 'RETURNED',
    'CORRECTION': 'CORRECTION',
    'HARD_RESERVE': 'HARD_RESERVE',
    'HARD_RELEASE': 'HARD_RELEASE',
    'SOFT_HOLD': 'SOFT_HOLD',
    'SOFT_RELEASE': 'SOFT_RELEASE',
    'FULFILLED': 'FULFILLED',
  };

  @override
  final Iterable<Type> types = const <Type>[InventoryMovementMovementTypeEnum];
  @override
  final String wireName = 'InventoryMovementMovementTypeEnum';

  @override
  Object serialize(
          Serializers serializers, InventoryMovementMovementTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventoryMovementMovementTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventoryMovementMovementTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventoryMovement extends InventoryMovement {
  @override
  final String id;
  @override
  final InventoryMovementMovementTypeEnum movementType;
  @override
  final String quantityDelta;
  @override
  final String? quantityOnHandBefore;
  @override
  final String quantityOnHandAfter;
  @override
  final String? hardReservedAfter;
  @override
  final String? reasonCode;
  @override
  final String? note;
  @override
  final String sourceType;
  @override
  final String actor;
  @override
  final String recordedAt;

  factory _$InventoryMovement(
          [void Function(InventoryMovementBuilder)? updates]) =>
      (InventoryMovementBuilder()..update(updates))._build();

  _$InventoryMovement._(
      {required this.id,
      required this.movementType,
      required this.quantityDelta,
      this.quantityOnHandBefore,
      required this.quantityOnHandAfter,
      this.hardReservedAfter,
      this.reasonCode,
      this.note,
      required this.sourceType,
      required this.actor,
      required this.recordedAt})
      : super._();
  @override
  InventoryMovement rebuild(void Function(InventoryMovementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryMovementBuilder toBuilder() =>
      InventoryMovementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryMovement &&
        id == other.id &&
        movementType == other.movementType &&
        quantityDelta == other.quantityDelta &&
        quantityOnHandBefore == other.quantityOnHandBefore &&
        quantityOnHandAfter == other.quantityOnHandAfter &&
        hardReservedAfter == other.hardReservedAfter &&
        reasonCode == other.reasonCode &&
        note == other.note &&
        sourceType == other.sourceType &&
        actor == other.actor &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, movementType.hashCode);
    _$hash = $jc(_$hash, quantityDelta.hashCode);
    _$hash = $jc(_$hash, quantityOnHandBefore.hashCode);
    _$hash = $jc(_$hash, quantityOnHandAfter.hashCode);
    _$hash = $jc(_$hash, hardReservedAfter.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, sourceType.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryMovement')
          ..add('id', id)
          ..add('movementType', movementType)
          ..add('quantityDelta', quantityDelta)
          ..add('quantityOnHandBefore', quantityOnHandBefore)
          ..add('quantityOnHandAfter', quantityOnHandAfter)
          ..add('hardReservedAfter', hardReservedAfter)
          ..add('reasonCode', reasonCode)
          ..add('note', note)
          ..add('sourceType', sourceType)
          ..add('actor', actor)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class InventoryMovementBuilder
    implements Builder<InventoryMovement, InventoryMovementBuilder> {
  _$InventoryMovement? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  InventoryMovementMovementTypeEnum? _movementType;
  InventoryMovementMovementTypeEnum? get movementType => _$this._movementType;
  set movementType(InventoryMovementMovementTypeEnum? movementType) =>
      _$this._movementType = movementType;

  String? _quantityDelta;
  String? get quantityDelta => _$this._quantityDelta;
  set quantityDelta(String? quantityDelta) =>
      _$this._quantityDelta = quantityDelta;

  String? _quantityOnHandBefore;
  String? get quantityOnHandBefore => _$this._quantityOnHandBefore;
  set quantityOnHandBefore(String? quantityOnHandBefore) =>
      _$this._quantityOnHandBefore = quantityOnHandBefore;

  String? _quantityOnHandAfter;
  String? get quantityOnHandAfter => _$this._quantityOnHandAfter;
  set quantityOnHandAfter(String? quantityOnHandAfter) =>
      _$this._quantityOnHandAfter = quantityOnHandAfter;

  String? _hardReservedAfter;
  String? get hardReservedAfter => _$this._hardReservedAfter;
  set hardReservedAfter(String? hardReservedAfter) =>
      _$this._hardReservedAfter = hardReservedAfter;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _sourceType;
  String? get sourceType => _$this._sourceType;
  set sourceType(String? sourceType) => _$this._sourceType = sourceType;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  String? _recordedAt;
  String? get recordedAt => _$this._recordedAt;
  set recordedAt(String? recordedAt) => _$this._recordedAt = recordedAt;

  InventoryMovementBuilder() {
    InventoryMovement._defaults(this);
  }

  InventoryMovementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _movementType = $v.movementType;
      _quantityDelta = $v.quantityDelta;
      _quantityOnHandBefore = $v.quantityOnHandBefore;
      _quantityOnHandAfter = $v.quantityOnHandAfter;
      _hardReservedAfter = $v.hardReservedAfter;
      _reasonCode = $v.reasonCode;
      _note = $v.note;
      _sourceType = $v.sourceType;
      _actor = $v.actor;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryMovement other) {
    _$v = other as _$InventoryMovement;
  }

  @override
  void update(void Function(InventoryMovementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryMovement build() => _build();

  _$InventoryMovement _build() {
    final _$result = _$v ??
        _$InventoryMovement._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'InventoryMovement', 'id'),
          movementType: BuiltValueNullFieldError.checkNotNull(
              movementType, r'InventoryMovement', 'movementType'),
          quantityDelta: BuiltValueNullFieldError.checkNotNull(
              quantityDelta, r'InventoryMovement', 'quantityDelta'),
          quantityOnHandBefore: quantityOnHandBefore,
          quantityOnHandAfter: BuiltValueNullFieldError.checkNotNull(
              quantityOnHandAfter, r'InventoryMovement', 'quantityOnHandAfter'),
          hardReservedAfter: hardReservedAfter,
          reasonCode: reasonCode,
          note: note,
          sourceType: BuiltValueNullFieldError.checkNotNull(
              sourceType, r'InventoryMovement', 'sourceType'),
          actor: BuiltValueNullFieldError.checkNotNull(
              actor, r'InventoryMovement', 'actor'),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt, r'InventoryMovement', 'recordedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
