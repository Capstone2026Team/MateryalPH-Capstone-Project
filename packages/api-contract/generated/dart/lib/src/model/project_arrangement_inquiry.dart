//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement_inquiry.g.dart';

/// ProjectArrangementInquiry
///
/// Properties:
/// * [version]
@BuiltValue()
abstract class ProjectArrangementInquiry implements Built<ProjectArrangementInquiry, ProjectArrangementInquiryBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  ProjectArrangementInquiry._();

  factory ProjectArrangementInquiry([void updates(ProjectArrangementInquiryBuilder b)]) = _$ProjectArrangementInquiry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementInquiryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangementInquiry> get serializer => _$ProjectArrangementInquirySerializer();
}

class _$ProjectArrangementInquirySerializer implements PrimitiveSerializer<ProjectArrangementInquiry> {
  @override
  final Iterable<Type> types = const [ProjectArrangementInquiry, _$ProjectArrangementInquiry];

  @override
  final String wireName = r'ProjectArrangementInquiry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangementInquiry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangementInquiry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementInquiryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangementInquiry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementInquiryBuilder();
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


