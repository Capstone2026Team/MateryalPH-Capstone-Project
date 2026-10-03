// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_destination_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatDestinationUpdateHeavyVehicleRestrictionEnum
    _$chatDestinationUpdateHeavyVehicleRestrictionEnum_NO =
    const ChatDestinationUpdateHeavyVehicleRestrictionEnum._('NO');
const ChatDestinationUpdateHeavyVehicleRestrictionEnum
    _$chatDestinationUpdateHeavyVehicleRestrictionEnum_YES =
    const ChatDestinationUpdateHeavyVehicleRestrictionEnum._('YES');

ChatDestinationUpdateHeavyVehicleRestrictionEnum
    _$chatDestinationUpdateHeavyVehicleRestrictionEnumValueOf(String name) {
  switch (name) {
    case 'NO':
      return _$chatDestinationUpdateHeavyVehicleRestrictionEnum_NO;
    case 'YES':
      return _$chatDestinationUpdateHeavyVehicleRestrictionEnum_YES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatDestinationUpdateHeavyVehicleRestrictionEnum>
    _$chatDestinationUpdateHeavyVehicleRestrictionEnumValues = BuiltSet<
        ChatDestinationUpdateHeavyVehicleRestrictionEnum>(const <ChatDestinationUpdateHeavyVehicleRestrictionEnum>[
  _$chatDestinationUpdateHeavyVehicleRestrictionEnum_NO,
  _$chatDestinationUpdateHeavyVehicleRestrictionEnum_YES,
]);

Serializer<ChatDestinationUpdateHeavyVehicleRestrictionEnum>
    _$chatDestinationUpdateHeavyVehicleRestrictionEnumSerializer =
    _$ChatDestinationUpdateHeavyVehicleRestrictionEnumSerializer();

class _$ChatDestinationUpdateHeavyVehicleRestrictionEnumSerializer
    implements
        PrimitiveSerializer<ChatDestinationUpdateHeavyVehicleRestrictionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NO': 'NO',
    'YES': 'YES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NO': 'NO',
    'YES': 'YES',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ChatDestinationUpdateHeavyVehicleRestrictionEnum
  ];
  @override
  final String wireName = 'ChatDestinationUpdateHeavyVehicleRestrictionEnum';

  @override
  Object serialize(Serializers serializers,
          ChatDestinationUpdateHeavyVehicleRestrictionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatDestinationUpdateHeavyVehicleRestrictionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatDestinationUpdateHeavyVehicleRestrictionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatDestinationUpdate extends ChatDestinationUpdate {
  @override
  final String locationId;
  @override
  final ChatDestinationUpdateHeavyVehicleRestrictionEnum
      heavyVehicleRestriction;
  @override
  final String? alternateDropOffLocationId;
  @override
  final String? accessInstructions;
  @override
  final int lockVersion;

  factory _$ChatDestinationUpdate(
          [void Function(ChatDestinationUpdateBuilder)? updates]) =>
      (ChatDestinationUpdateBuilder()..update(updates))._build();

  _$ChatDestinationUpdate._(
      {required this.locationId,
      required this.heavyVehicleRestriction,
      this.alternateDropOffLocationId,
      this.accessInstructions,
      required this.lockVersion})
      : super._();
  @override
  ChatDestinationUpdate rebuild(
          void Function(ChatDestinationUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDestinationUpdateBuilder toBuilder() =>
      ChatDestinationUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDestinationUpdate &&
        locationId == other.locationId &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOffLocationId == other.alternateDropOffLocationId &&
        accessInstructions == other.accessInstructions &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOffLocationId.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDestinationUpdate')
          ..add('locationId', locationId)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOffLocationId', alternateDropOffLocationId)
          ..add('accessInstructions', accessInstructions)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class ChatDestinationUpdateBuilder
    implements Builder<ChatDestinationUpdate, ChatDestinationUpdateBuilder> {
  _$ChatDestinationUpdate? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  ChatDestinationUpdateHeavyVehicleRestrictionEnum? _heavyVehicleRestriction;
  ChatDestinationUpdateHeavyVehicleRestrictionEnum?
      get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(
          ChatDestinationUpdateHeavyVehicleRestrictionEnum?
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

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ChatDestinationUpdateBuilder() {
    ChatDestinationUpdate._defaults(this);
  }

  ChatDestinationUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOffLocationId = $v.alternateDropOffLocationId;
      _accessInstructions = $v.accessInstructions;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDestinationUpdate other) {
    _$v = other as _$ChatDestinationUpdate;
  }

  @override
  void update(void Function(ChatDestinationUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDestinationUpdate build() => _build();

  _$ChatDestinationUpdate _build() {
    final _$result = _$v ??
        _$ChatDestinationUpdate._(
          locationId: BuiltValueNullFieldError.checkNotNull(
              locationId, r'ChatDestinationUpdate', 'locationId'),
          heavyVehicleRestriction: BuiltValueNullFieldError.checkNotNull(
              heavyVehicleRestriction,
              r'ChatDestinationUpdate',
              'heavyVehicleRestriction'),
          alternateDropOffLocationId: alternateDropOffLocationId,
          accessInstructions: accessInstructions,
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ChatDestinationUpdate', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
