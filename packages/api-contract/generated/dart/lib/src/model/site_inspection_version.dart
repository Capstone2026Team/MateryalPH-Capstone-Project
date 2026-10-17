//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_version.g.dart';

/// SiteInspectionVersion
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class SiteInspectionVersion implements Built<SiteInspectionVersion, SiteInspectionVersionBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  SiteInspectionVersion._();

  factory SiteInspectionVersion([void updates(SiteInspectionVersionBuilder b)]) = _$SiteInspectionVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionVersion> get serializer => _$SiteInspectionVersionSerializer();
}

class _$SiteInspectionVersionSerializer implements PrimitiveSerializer<SiteInspectionVersion> {
  @override
  final Iterable<Type> types = const [SiteInspectionVersion, _$SiteInspectionVersion];

  @override
  final String wireName = r'SiteInspectionVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionVersionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionVersionBuilder();
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


