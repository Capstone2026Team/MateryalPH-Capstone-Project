//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/site_inspection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_list_response_data.g.dart';

/// SiteInspectionListResponseData
///
/// Properties:
/// * [siteInspections]
@BuiltValue()
abstract class SiteInspectionListResponseData implements Built<SiteInspectionListResponseData, SiteInspectionListResponseDataBuilder> {
  @BuiltValueField(wireName: r'site_inspections')
  BuiltList<SiteInspection> get siteInspections;

  SiteInspectionListResponseData._();

  factory SiteInspectionListResponseData([void updates(SiteInspectionListResponseDataBuilder b)]) = _$SiteInspectionListResponseData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionListResponseDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionListResponseData> get serializer => _$SiteInspectionListResponseDataSerializer();
}

class _$SiteInspectionListResponseDataSerializer implements PrimitiveSerializer<SiteInspectionListResponseData> {
  @override
  final Iterable<Type> types = const [SiteInspectionListResponseData, _$SiteInspectionListResponseData];

  @override
  final String wireName = r'SiteInspectionListResponseData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionListResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'site_inspections';
    yield serializers.serialize(
      object.siteInspections,
      specifiedType: const FullType(BuiltList, [FullType(SiteInspection)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionListResponseData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionListResponseDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'site_inspections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SiteInspection)]),
          ) as BuiltList<SiteInspection>;
          result.siteInspections.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionListResponseData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionListResponseDataBuilder();
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


