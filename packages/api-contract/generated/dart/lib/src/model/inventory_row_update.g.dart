// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_row_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InventoryRowUpdateReasonCodeEnum
    _$inventoryRowUpdateReasonCodeEnum_COUNT =
    const InventoryRowUpdateReasonCodeEnum._('COUNT');
const InventoryRowUpdateReasonCodeEnum
    _$inventoryRowUpdateReasonCodeEnum_RECEIVED =
    const InventoryRowUpdateReasonCodeEnum._('RECEIVED');
const InventoryRowUpdateReasonCodeEnum
    _$inventoryRowUpdateReasonCodeEnum_RETURNED =
    const InventoryRowUpdateReasonCodeEnum._('RETURNED');
const InventoryRowUpdateReasonCodeEnum
    _$inventoryRowUpdateReasonCodeEnum_DAMAGED =
    const InventoryRowUpdateReasonCodeEnum._('DAMAGED');
const InventoryRowUpdateReasonCodeEnum _$inventoryRowUpdateReasonCodeEnum_LOST =
    const InventoryRowUpdateReasonCodeEnum._('LOST');
const InventoryRowUpdateReasonCodeEnum
    _$inventoryRowUpdateReasonCodeEnum_CORRECTION =
    const InventoryRowUpdateReasonCodeEnum._('CORRECTION');

InventoryRowUpdateReasonCodeEnum _$inventoryRowUpdateReasonCodeEnumValueOf(
    String name) {
  switch (name) {
    case 'COUNT':
      return _$inventoryRowUpdateReasonCodeEnum_COUNT;
    case 'RECEIVED':
      return _$inventoryRowUpdateReasonCodeEnum_RECEIVED;
    case 'RETURNED':
      return _$inventoryRowUpdateReasonCodeEnum_RETURNED;
    case 'DAMAGED':
      return _$inventoryRowUpdateReasonCodeEnum_DAMAGED;
    case 'LOST':
      return _$inventoryRowUpdateReasonCodeEnum_LOST;
    case 'CORRECTION':
      return _$inventoryRowUpdateReasonCodeEnum_CORRECTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InventoryRowUpdateReasonCodeEnum>
    _$inventoryRowUpdateReasonCodeEnumValues = BuiltSet<
        InventoryRowUpdateReasonCodeEnum>(const <InventoryRowUpdateReasonCodeEnum>[
  _$inventoryRowUpdateReasonCodeEnum_COUNT,
  _$inventoryRowUpdateReasonCodeEnum_RECEIVED,
  _$inventoryRowUpdateReasonCodeEnum_RETURNED,
  _$inventoryRowUpdateReasonCodeEnum_DAMAGED,
  _$inventoryRowUpdateReasonCodeEnum_LOST,
  _$inventoryRowUpdateReasonCodeEnum_CORRECTION,
]);

Serializer<InventoryRowUpdateReasonCodeEnum>
    _$inventoryRowUpdateReasonCodeEnumSerializer =
    _$InventoryRowUpdateReasonCodeEnumSerializer();

class _$InventoryRowUpdateReasonCodeEnumSerializer
    implements PrimitiveSerializer<InventoryRowUpdateReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COUNT': 'COUNT',
    'RECEIVED': 'RECEIVED',
    'RETURNED': 'RETURNED',
    'DAMAGED': 'DAMAGED',
    'LOST': 'LOST',
    'CORRECTION': 'CORRECTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COUNT': 'COUNT',
    'RECEIVED': 'RECEIVED',
    'RETURNED': 'RETURNED',
    'DAMAGED': 'DAMAGED',
    'LOST': 'LOST',
    'CORRECTION': 'CORRECTION',
  };

  @override
  final Iterable<Type> types = const <Type>[InventoryRowUpdateReasonCodeEnum];
  @override
  final String wireName = 'InventoryRowUpdateReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, InventoryRowUpdateReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InventoryRowUpdateReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InventoryRowUpdateReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InventoryRowUpdate extends InventoryRowUpdate {
  @override
  final int lockVersion;
  @override
  final String? quantityOnHand;
  @override
  final String? reorderLevel;
  @override
  final InventoryRowUpdateReasonCodeEnum? reasonCode;
  @override
  final String? note;
  @override
  final InventoryPriceChange? price;

  factory _$InventoryRowUpdate(
          [void Function(InventoryRowUpdateBuilder)? updates]) =>
      (InventoryRowUpdateBuilder()..update(updates))._build();

  _$InventoryRowUpdate._(
      {required this.lockVersion,
      this.quantityOnHand,
      this.reorderLevel,
      this.reasonCode,
      this.note,
      this.price})
      : super._();
  @override
  InventoryRowUpdate rebuild(
          void Function(InventoryRowUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryRowUpdateBuilder toBuilder() =>
      InventoryRowUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryRowUpdate &&
        lockVersion == other.lockVersion &&
        quantityOnHand == other.quantityOnHand &&
        reorderLevel == other.reorderLevel &&
        reasonCode == other.reasonCode &&
        note == other.note &&
        price == other.price;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, quantityOnHand.hashCode);
    _$hash = $jc(_$hash, reorderLevel.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryRowUpdate')
          ..add('lockVersion', lockVersion)
          ..add('quantityOnHand', quantityOnHand)
          ..add('reorderLevel', reorderLevel)
          ..add('reasonCode', reasonCode)
          ..add('note', note)
          ..add('price', price))
        .toString();
  }
}

class InventoryRowUpdateBuilder
    implements Builder<InventoryRowUpdate, InventoryRowUpdateBuilder> {
  _$InventoryRowUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _quantityOnHand;
  String? get quantityOnHand => _$this._quantityOnHand;
  set quantityOnHand(String? quantityOnHand) =>
      _$this._quantityOnHand = quantityOnHand;

  String? _reorderLevel;
  String? get reorderLevel => _$this._reorderLevel;
  set reorderLevel(String? reorderLevel) => _$this._reorderLevel = reorderLevel;

  InventoryRowUpdateReasonCodeEnum? _reasonCode;
  InventoryRowUpdateReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(InventoryRowUpdateReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  InventoryPriceChangeBuilder? _price;
  InventoryPriceChangeBuilder get price =>
      _$this._price ??= InventoryPriceChangeBuilder();
  set price(InventoryPriceChangeBuilder? price) => _$this._price = price;

  InventoryRowUpdateBuilder() {
    InventoryRowUpdate._defaults(this);
  }

  InventoryRowUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _quantityOnHand = $v.quantityOnHand;
      _reorderLevel = $v.reorderLevel;
      _reasonCode = $v.reasonCode;
      _note = $v.note;
      _price = $v.price?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryRowUpdate other) {
    _$v = other as _$InventoryRowUpdate;
  }

  @override
  void update(void Function(InventoryRowUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryRowUpdate build() => _build();

  _$InventoryRowUpdate _build() {
    _$InventoryRowUpdate _$result;
    try {
      _$result = _$v ??
          _$InventoryRowUpdate._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'InventoryRowUpdate', 'lockVersion'),
            quantityOnHand: quantityOnHand,
            reorderLevel: reorderLevel,
            reasonCode: reasonCode,
            note: note,
            price: _price?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        _price?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InventoryRowUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
