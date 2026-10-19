//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_entry_details.g.dart';

/// SupportEntryDetails
///
/// Properties:
/// * [fromStatus]
/// * [toStatus]
/// * [previousHandler]
/// * [newHandler]
@BuiltValue()
abstract class SupportEntryDetails implements Built<SupportEntryDetails, SupportEntryDetailsBuilder> {
  @BuiltValueField(wireName: r'from_status')
  String? get fromStatus;

  @BuiltValueField(wireName: r'to_status')
  String? get toStatus;

  @BuiltValueField(wireName: r'previous_handler')
  String? get previousHandler;

  @BuiltValueField(wireName: r'new_handler')
  String? get newHandler;

  SupportEntryDetails._();

  factory SupportEntryDetails([void updates(SupportEntryDetailsBuilder b)]) = _$SupportEntryDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportEntryDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportEntryDetails> get serializer => _$SupportEntryDetailsSerializer();
}

class _$SupportEntryDetailsSerializer implements PrimitiveSerializer<SupportEntryDetails> {
  @override
  final Iterable<Type> types = const [SupportEntryDetails, _$SupportEntryDetails];

  @override
  final String wireName = r'SupportEntryDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportEntryDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fromStatus != null) {
      yield r'from_status';
      yield serializers.serialize(
        object.fromStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.toStatus != null) {
      yield r'to_status';
      yield serializers.serialize(
        object.toStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.previousHandler != null) {
      yield r'previous_handler';
      yield serializers.serialize(
        object.previousHandler,
        specifiedType: const FullType(String),
      );
    }
    if (object.newHandler != null) {
      yield r'new_handler';
      yield serializers.serialize(
        object.newHandler,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportEntryDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportEntryDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'to_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.toStatus = valueDes;
          break;
        case r'previous_handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.previousHandler = valueDes;
          break;
        case r'new_handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.newHandler = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportEntryDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportEntryDetailsBuilder();
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


