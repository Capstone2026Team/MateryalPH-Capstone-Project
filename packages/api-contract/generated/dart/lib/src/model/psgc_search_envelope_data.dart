//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/psgc_area.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'psgc_search_envelope_data.g.dart';

/// PsgcSearchEnvelopeData
///
/// Properties:
/// * [items]
/// * [page]
/// * [hasMore]
/// * [versionId] - Reference provider identifier.
@BuiltValue()
abstract class PsgcSearchEnvelopeData implements Built<PsgcSearchEnvelopeData, PsgcSearchEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PsgcArea> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  /// Reference provider identifier.
  @BuiltValueField(wireName: r'version_id')
  String get versionId;

  PsgcSearchEnvelopeData._();

  factory PsgcSearchEnvelopeData([void updates(PsgcSearchEnvelopeDataBuilder b)]) = _$PsgcSearchEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PsgcSearchEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PsgcSearchEnvelopeData> get serializer => _$PsgcSearchEnvelopeDataSerializer();
}

class _$PsgcSearchEnvelopeDataSerializer implements PrimitiveSerializer<PsgcSearchEnvelopeData> {
  @override
  final Iterable<Type> types = const [PsgcSearchEnvelopeData, _$PsgcSearchEnvelopeData];

  @override
  final String wireName = r'PsgcSearchEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PsgcSearchEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PsgcArea)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    yield r'version_id';
    yield serializers.serialize(
      object.versionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PsgcSearchEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PsgcSearchEnvelopeDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PsgcArea)]),
          ) as BuiltList<PsgcArea>;
          result.items.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.versionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PsgcSearchEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PsgcSearchEnvelopeDataBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


