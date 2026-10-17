//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_actions.g.dart';

/// SiteInspectionActions
///
/// Properties:
/// * [cancel]
/// * [schedule]
/// * [decline]
/// * [complete]
@BuiltValue()
abstract class SiteInspectionActions implements Built<SiteInspectionActions, SiteInspectionActionsBuilder> {
  @BuiltValueField(wireName: r'cancel')
  bool get cancel;

  @BuiltValueField(wireName: r'schedule')
  bool get schedule;

  @BuiltValueField(wireName: r'decline')
  bool get decline;

  @BuiltValueField(wireName: r'complete')
  bool get complete;

  SiteInspectionActions._();

  factory SiteInspectionActions([void updates(SiteInspectionActionsBuilder b)]) = _$SiteInspectionActions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionActionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionActions> get serializer => _$SiteInspectionActionsSerializer();
}

class _$SiteInspectionActionsSerializer implements PrimitiveSerializer<SiteInspectionActions> {
  @override
  final Iterable<Type> types = const [SiteInspectionActions, _$SiteInspectionActions];

  @override
  final String wireName = r'SiteInspectionActions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionActions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cancel';
    yield serializers.serialize(
      object.cancel,
      specifiedType: const FullType(bool),
    );
    yield r'schedule';
    yield serializers.serialize(
      object.schedule,
      specifiedType: const FullType(bool),
    );
    yield r'decline';
    yield serializers.serialize(
      object.decline,
      specifiedType: const FullType(bool),
    );
    yield r'complete';
    yield serializers.serialize(
      object.complete,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionActions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionActionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cancel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cancel = valueDes;
          break;
        case r'schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.schedule = valueDes;
          break;
        case r'decline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.decline = valueDes;
          break;
        case r'complete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.complete = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionActions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionActionsBuilder();
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


