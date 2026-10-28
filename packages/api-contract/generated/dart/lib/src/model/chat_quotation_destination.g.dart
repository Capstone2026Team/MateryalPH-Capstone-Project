// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_destination.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatQuotationDestinationHeavyVehicleRestrictionEnum
    _$chatQuotationDestinationHeavyVehicleRestrictionEnum_UNANSWERED =
    const ChatQuotationDestinationHeavyVehicleRestrictionEnum._('UNANSWERED');
const ChatQuotationDestinationHeavyVehicleRestrictionEnum
    _$chatQuotationDestinationHeavyVehicleRestrictionEnum_NO =
    const ChatQuotationDestinationHeavyVehicleRestrictionEnum._('NO');
const ChatQuotationDestinationHeavyVehicleRestrictionEnum
    _$chatQuotationDestinationHeavyVehicleRestrictionEnum_YES =
    const ChatQuotationDestinationHeavyVehicleRestrictionEnum._('YES');

ChatQuotationDestinationHeavyVehicleRestrictionEnum
    _$chatQuotationDestinationHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'UNANSWERED':
      return _$chatQuotationDestinationHeavyVehicleRestrictionEnum_UNANSWERED;
    case 'NO':
      return _$chatQuotationDestinationHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$chatQuotationDestinationHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatQuotationDestinationHeavyVehicleRestrictionEnum>
    _$chatQuotationDestinationHeavyVehicleRestrictionEnumValues = BuiltSet<
        ChatQuotationDestinationHeavyVehicleRestrictionEnum>(const <ChatQuotationDestinationHeavyVehicleRestrictionEnum>[
  _$chatQuotationDestinationHeavyVehicleRestrictionEnum_UNANSWERED,
  _$chatQuotationDestinationHeavyVehicleRestrictionEnum_NO,
  _$chatQuotationDestinationHeavyVehicleRestrictionEnum_YES,
]);

Serializer<ChatQuotationDestinationHeavyVehicleRestrictionEnum>
    _$chatQuotationDestinationHeavyVehicleRestrictionEnumSerializer =
    _$ChatQuotationDestinationHeavyVehicleRestrictionEnumSerializer();

class _$ChatQuotationDestinationHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<
            ChatQuotationDestinationHeavyVehicleRestrictionEnum> {
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
    ChatQuotationDestinationHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'ChatQuotationDestinationHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          ChatQuotationDestinationHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatQuotationDestinationHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatQuotationDestinationHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatQuotationDestination extends ChatQuotationDestination {
  @override
  final String? intendedAddress;
  @override
  final String? alternateAddress;
  @override
  final String? intendedAddressId;
  @override
  final String? alternateAddressId;
  @override
  final ChatQuotationDestinationHeavyVehicleRestrictionEnum?
      heavyVehicleRestriction;
  @override
  final String? accessInstructions;

  factory _$ChatQuotationDestination(
          [void Function(ChatQuotationDestinationBuilder)? updates]) =>
      (ChatQuotationDestinationBuilder()..update(updates))._build();

  _$ChatQuotationDestination._(
      {this.intendedAddress,
      this.alternateAddress,
      this.intendedAddressId,
      this.alternateAddressId,
      this.heavyVehicleRestriction,
      this.accessInstructions})
      : super._();
  @override
  ChatQuotationDestination rebuild(
          void Function(ChatQuotationDestinationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationDestinationBuilder toBuilder() =>
      ChatQuotationDestinationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationDestination &&
        intendedAddress == other.intendedAddress &&
        alternateAddress == other.alternateAddress &&
        intendedAddressId == other.intendedAddressId &&
        alternateAddressId == other.alternateAddressId &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        accessInstructions == other.accessInstructions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, intendedAddress.hashCode);
    _$hash = $jc(_$hash, alternateAddress.hashCode);
    _$hash = $jc(_$hash, intendedAddressId.hashCode);
    _$hash = $jc(_$hash, alternateAddressId.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationDestination')
          ..add('intendedAddress', intendedAddress)
          ..add('alternateAddress', alternateAddress)
          ..add('intendedAddressId', intendedAddressId)
          ..add('alternateAddressId', alternateAddressId)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('accessInstructions', accessInstructions))
        .toString();
  }
}

class ChatQuotationDestinationBuilder
    implements
        Builder<ChatQuotationDestination, ChatQuotationDestinationBuilder> {
  _$ChatQuotationDestination? _$v;

  String? _intendedAddress;
  String? get intendedAddress => _$this._intendedAddress;
  set intendedAddress(String? intendedAddress) =>
      _$this._intendedAddress = intendedAddress;

  String? _alternateAddress;
  String? get alternateAddress => _$this._alternateAddress;
  set alternateAddress(String? alternateAddress) =>
      _$this._alternateAddress = alternateAddress;

  String? _intendedAddressId;
  String? get intendedAddressId => _$this._intendedAddressId;
  set intendedAddressId(String? intendedAddressId) =>
      _$this._intendedAddressId = intendedAddressId;

  String? _alternateAddressId;
  String? get alternateAddressId => _$this._alternateAddressId;
  set alternateAddressId(String? alternateAddressId) =>
      _$this._alternateAddressId = alternateAddressId;

  ChatQuotationDestinationHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  ChatQuotationDestinationHeavyVehicleRestrictionEnum?
      get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          ChatQuotationDestinationHeavyVehicleRestrictionEnum?
              heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  ChatQuotationDestinationBuilder() {
    ChatQuotationDestination._defaults(this);
  }

  ChatQuotationDestinationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _intendedAddress = $v.intendedAddress;
      _alternateAddress = $v.alternateAddress;
      _intendedAddressId = $v.intendedAddressId;
      _alternateAddressId = $v.alternateAddressId;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _accessInstructions = $v.accessInstructions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationDestination other) {
    _$v = other as _$ChatQuotationDestination;
  }

  @override
  void update(void Function(ChatQuotationDestinationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationDestination build() => _build();

  _$ChatQuotationDestination _build() {
    final _$result = _$v ??
        _$ChatQuotationDestination._(
          intendedAddress: intendedAddress,
          alternateAddress: alternateAddress,
          intendedAddressId: intendedAddressId,
          alternateAddressId: alternateAddressId,
          heavyVehicleRestriction: heavyVehicleRestriction,
          accessInstructions: accessInstructions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
