// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marking_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MarkingType _$PS_MARK = const MarkingType._('PS_MARK');
const MarkingType _$ICC_STICKER = const MarkingType._('ICC_STICKER');

MarkingType _$valueOf(String name) {
  switch (name) {
    case 'PS_MARK':
      return _$PS_MARK;
    case 'ICC_STICKER':
      return _$ICC_STICKER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MarkingType> _$values =
    BuiltSet<MarkingType>(const <MarkingType>[
  _$PS_MARK,
  _$ICC_STICKER,
]);

class _$MarkingTypeMeta {
  const _$MarkingTypeMeta();
  MarkingType get PS_MARK => _$PS_MARK;
  MarkingType get ICC_STICKER => _$ICC_STICKER;
  MarkingType valueOf(String name) => _$valueOf(name);
  BuiltSet<MarkingType> get values => _$values;
}

abstract class _$MarkingTypeMixin {
  // ignore: non_constant_identifier_names
  _$MarkingTypeMeta get MarkingType => const _$MarkingTypeMeta();
}

Serializer<MarkingType> _$markingTypeSerializer = _$MarkingTypeSerializer();

class _$MarkingTypeSerializer implements PrimitiveSerializer<MarkingType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PS_MARK': 'PS_MARK',
    'ICC_STICKER': 'ICC_STICKER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PS_MARK': 'PS_MARK',
    'ICC_STICKER': 'ICC_STICKER',
  };

  @override
  final Iterable<Type> types = const <Type>[MarkingType];
  @override
  final String wireName = 'MarkingType';

  @override
  Object serialize(Serializers serializers, MarkingType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MarkingType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MarkingType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
