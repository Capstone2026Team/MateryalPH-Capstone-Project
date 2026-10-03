// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_destination_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CartDestinationUpdateHeavyVehicleRestrictionEnum
    _$cartDestinationUpdateHeavyVehicleRestrictionEnum_UNANSWERED =
    const CartDestinationUpdateHeavyVehicleRestrictionEnum._('UNANSWERED');
const CartDestinationUpdateHeavyVehicleRestrictionEnum
    _$cartDestinationUpdateHeavyVehicleRestrictionEnum_NO =
    const CartDestinationUpdateHeavyVehicleRestrictionEnum._('NO');
const CartDestinationUpdateHeavyVehicleRestrictionEnum
    _$cartDestinationUpdateHeavyVehicleRestrictionEnum_YES =
    const CartDestinationUpdateHeavyVehicleRestrictionEnum._('YES');

CartDestinationUpdateHeavyVehicleRestrictionEnum
    _$cartDestinationUpdateHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'UNANSWERED':
      return _$cartDestinationUpdateHeavyVehicleRestrictionEnum_UNANSWERED;
    case 'NO':
      return _$cartDestinationUpdateHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$cartDestinationUpdateHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CartDestinationUpdateHeavyVehicleRestrictionEnum>
    _$cartDestinationUpdateHeavyVehicleRestrictionEnumValues = BuiltSet<
        CartDestinationUpdateHeavyVehicleRestrictionEnum>(const <CartDestinationUpdateHeavyVehicleRestrictionEnum>[
  _$cartDestinationUpdateHeavyVehicleRestrictionEnum_UNANSWERED,
  _$cartDestinationUpdateHeavyVehicleRestrictionEnum_NO,
  _$cartDestinationUpdateHeavyVehicleRestrictionEnum_YES,
]);

Serializer<CartDestinationUpdateHeavyVehicleRestrictionEnum>
    _$cartDestinationUpdateHeavyVehicleRestrictionEnumSerializer =
    _$CartDestinationUpdateHeavyVehicleRestrictionEnumSerializer();

class _$CartDestinationUpdateHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<CartDestinationUpdateHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNANSWERED': 'UNANSWERED',
    'NO': 'NO',
    'YES': 'YES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNANSWERED': 'UNANSWERED',
    'NO': 'NO',
    'YES': 'YES',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CartDestinationUpdateHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'CartDestinationUpdateHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          CartDestinationUpdateHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CartDestinationUpdateHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CartDestinationUpdateHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CartDestinationUpdate extends CartDestinationUpdate {
  @override
  final int lockVersion;
  @override
  final String? intendedLocationId;
  @override
  final CartDestinationUpdateHeavyVehicleRestrictionEnum
      heavyVehicleRestriction;
  @override
  final String? alternateDropOffLocationId;
  @override
  final String? accessInstructions;

  factory _$CartDestinationUpdate(
          [void Function(CartDestinationUpdateBuilder)? updates]) =>
      (CartDestinationUpdateBuilder()..update(updates))._build();

  _$CartDestinationUpdate._(
      {required this.lockVersion,
      this.intendedLocationId,
      required this.heavyVehicleRestriction,
      this.alternateDropOffLocationId,
      this.accessInstructions})
      : super._();
  @override
  CartDestinationUpdate rebuild(
          void Function(CartDestinationUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CartDestinationUpdateBuilder toBuilder() =>
      CartDestinationUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CartDestinationUpdate &&
        lockVersion == other.lockVersion &&
        intendedLocationId == other.intendedLocationId &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOffLocationId == other.alternateDropOffLocationId &&
        accessInstructions == other.accessInstructions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, intendedLocationId.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOffLocationId.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CartDestinationUpdate')
          ..add('lockVersion', lockVersion)
          ..add('intendedLocationId', intendedLocationId)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOffLocationId', alternateDropOffLocationId)
          ..add('accessInstructions', accessInstructions))
        .toString();
  }
}

class CartDestinationUpdateBuilder
    implements Builder<CartDestinationUpdate, CartDestinationUpdateBuilder> {
  _$CartDestinationUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _intendedLocationId;
  String? get intendedLocationId => _$this._intendedLocationId;
  set intendedLocationId(String? intendedLocationId) =>
      _$this._intendedLocationId = intendedLocationId;

  CartDestinationUpdateHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  CartDestinationUpdateHeavyVehicleRestrictionEnum?
      get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          CartDestinationUpdateHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  String? _alternateDropOffLocationId;
  String? get alternateDropOffLocationId => _$this._alternateDropOffLocationId;
  set alternateDropOffLocationId(String? alternateDropOffLocationId) =>
      _$this._alternateDropOffLocationId = alternateDropOffLocationId;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  CartDestinationUpdateBuilder() {
    CartDestinationUpdate._defaults(this);
  }

  CartDestinationUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _intendedLocationId = $v.intendedLocationId;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOffLocationId = $v.alternateDropOffLocationId;
      _accessInstructions = $v.accessInstructions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CartDestinationUpdate other) {
    _$v = other as _$CartDestinationUpdate;
  }

  @override
  void update(void Function(CartDestinationUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CartDestinationUpdate build() => _build();

  _$CartDestinationUpdate _build() {
    final _$result = _$v ??
        _$CartDestinationUpdate._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CartDestinationUpdate', 'lockVersion'),
          intendedLocationId: intendedLocationId,
          heavyVehicleRestriction: BuiltValueNullFieldError.checkNotNull(
              heavyVehicleRestriction,
              r'CartDestinationUpdate',
              'heavyVehicleRestriction'),
          alternateDropOffLocationId: alternateDropOffLocationId,
          accessInstructions: accessInstructions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
