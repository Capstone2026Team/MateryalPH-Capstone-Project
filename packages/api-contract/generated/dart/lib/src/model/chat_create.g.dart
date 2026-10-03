// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatCreateContextTypeEnum _$chatCreateContextTypeEnum_ITEM_BASED =
    const ChatCreateContextTypeEnum._('ITEM_BASED');
const ChatCreateContextTypeEnum _$chatCreateContextTypeEnum_PROJECT_BASED =
    const ChatCreateContextTypeEnum._('PROJECT_BASED');

ChatCreateContextTypeEnum _$chatCreateContextTypeEnumValueOf(String name) {
  switch (name) {
    case 'ITEM_BASED':
      return _$chatCreateContextTypeEnum_ITEM_BASED;
    case 'PROJECT_BASED':
      return _$chatCreateContextTypeEnum_PROJECT_BASED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatCreateContextTypeEnum> _$chatCreateContextTypeEnumValues =
    BuiltSet<ChatCreateContextTypeEnum>(const <ChatCreateContextTypeEnum>[
  _$chatCreateContextTypeEnum_ITEM_BASED,
  _$chatCreateContextTypeEnum_PROJECT_BASED,
]);

Serializer<ChatCreateContextTypeEnum> _$chatCreateContextTypeEnumSerializer =
    _$ChatCreateContextTypeEnumSerializer();

class _$ChatCreateContextTypeEnumSerializer
    implements PrimitiveSerializer<ChatCreateContextTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatCreateContextTypeEnum];
  @override
  final String wireName = 'ChatCreateContextTypeEnum';

  @override
  Object serialize(Serializers serializers, ChatCreateContextTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatCreateContextTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatCreateContextTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatCreate extends ChatCreate {
  @override
  final String vendorId;
  @override
  final String? listingVariantId;
  @override
  final String? locationId;
  @override
  final String? heavyVehicleRestriction;
  @override
  final String? alternateDropOffLocationId;
  @override
  final String? accessInstructions;
  @override
  final ChatCreateContextTypeEnum? contextType;

  factory _$ChatCreate([void Function(ChatCreateBuilder)? updates]) =>
      (ChatCreateBuilder()..update(updates))._build();

  _$ChatCreate._(
      {required this.vendorId,
      this.listingVariantId,
      this.locationId,
      this.heavyVehicleRestriction,
      this.alternateDropOffLocationId,
      this.accessInstructions,
      this.contextType})
      : super._();
  @override
  ChatCreate rebuild(void Function(ChatCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatCreateBuilder toBuilder() => ChatCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatCreate &&
        vendorId == other.vendorId &&
        listingVariantId == other.listingVariantId &&
        locationId == other.locationId &&
        heavyVehicleRestriction == other.heavyVehicleRestriction &&
        alternateDropOffLocationId == other.alternateDropOffLocationId &&
        accessInstructions == other.accessInstructions &&
        contextType == other.contextType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, heavyVehicleRestriction.hashCode);
    _$hash = $jc(_$hash, alternateDropOffLocationId.hashCode);
    _$hash = $jc(_$hash, accessInstructions.hashCode);
    _$hash = $jc(_$hash, contextType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatCreate')
          ..add('vendorId', vendorId)
          ..add('listingVariantId', listingVariantId)
          ..add('locationId', locationId)
          ..add('heavyVehicleRestriction', heavyVehicleRestriction)
          ..add('alternateDropOffLocationId', alternateDropOffLocationId)
          ..add('accessInstructions', accessInstructions)
          ..add('contextType', contextType))
        .toString();
  }
}

class ChatCreateBuilder implements Builder<ChatCreate, ChatCreateBuilder> {
  _$ChatCreate? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  String? _heavyVehicleRestriction;
  String? get heavyVehicleRestriction => _$this._heavyVehicleRestriction;
  set heavyVehicleRestriction(String? heavyVehicleRestriction) =>
      _$this._heavyVehicleRestriction = heavyVehicleRestriction;

  String? _alternateDropOffLocationId;
  String? get alternateDropOffLocationId => _$this._alternateDropOffLocationId;
  set alternateDropOffLocationId(String? alternateDropOffLocationId) =>
      _$this._alternateDropOffLocationId = alternateDropOffLocationId;

  String? _accessInstructions;
  String? get accessInstructions => _$this._accessInstructions;
  set accessInstructions(String? accessInstructions) =>
      _$this._accessInstructions = accessInstructions;

  ChatCreateContextTypeEnum? _contextType;
  ChatCreateContextTypeEnum? get contextType => _$this._contextType;
  set contextType(ChatCreateContextTypeEnum? contextType) =>
      _$this._contextType = contextType;

  ChatCreateBuilder() {
    ChatCreate._defaults(this);
  }

  ChatCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _listingVariantId = $v.listingVariantId;
      _locationId = $v.locationId;
      _heavyVehicleRestriction = $v.heavyVehicleRestriction;
      _alternateDropOffLocationId = $v.alternateDropOffLocationId;
      _accessInstructions = $v.accessInstructions;
      _contextType = $v.contextType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatCreate other) {
    _$v = other as _$ChatCreate;
  }

  @override
  void update(void Function(ChatCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatCreate build() => _build();

  _$ChatCreate _build() {
    final _$result = _$v ??
        _$ChatCreate._(
          vendorId: BuiltValueNullFieldError.checkNotNull(
              vendorId, r'ChatCreate', 'vendorId'),
          listingVariantId: listingVariantId,
          locationId: locationId,
          heavyVehicleRestriction: heavyVehicleRestriction,
          alternateDropOffLocationId: alternateDropOffLocationId,
          accessInstructions: accessInstructions,
          contextType: contextType,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
