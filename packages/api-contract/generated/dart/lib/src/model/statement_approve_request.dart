//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statement_approve_request.g.dart';

/// StatementApproveRequest
///
/// Properties:
/// * [lockVersion]
@BuiltValue()
abstract class StatementApproveRequest implements Built<StatementApproveRequest, StatementApproveRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  StatementApproveRequest._();

  factory StatementApproveRequest([void updates(StatementApproveRequestBuilder b)]) = _$StatementApproveRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatementApproveRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatementApproveRequest> get serializer => _$StatementApproveRequestSerializer();
}

class _$StatementApproveRequestSerializer implements PrimitiveSerializer<StatementApproveRequest> {
  @override
  final Iterable<Type> types = const [StatementApproveRequest, _$StatementApproveRequest];

  @override
  final String wireName = r'StatementApproveRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatementApproveRequest object, {
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
    StatementApproveRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatementApproveRequestBuilder result,
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
  StatementApproveRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatementApproveRequestBuilder();
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


