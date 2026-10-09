//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_team_activity_envelope_meta_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_activity_envelope_meta.g.dart';

/// VendorTeamActivityEnvelopeMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
/// * [total]
/// * [totalEvents]
/// * [succeededEvents]
/// * [failedEvents]
/// * [categories]
@BuiltValue()
abstract class VendorTeamActivityEnvelopeMeta implements Built<VendorTeamActivityEnvelopeMeta, VendorTeamActivityEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'total_events')
  int get totalEvents;

  @BuiltValueField(wireName: r'succeeded_events')
  int get succeededEvents;

  @BuiltValueField(wireName: r'failed_events')
  int get failedEvents;

  @BuiltValueField(wireName: r'categories')
  BuiltList<VendorTeamActivityEnvelopeMetaCategoriesInner> get categories;

  VendorTeamActivityEnvelopeMeta._();

  factory VendorTeamActivityEnvelopeMeta([void updates(VendorTeamActivityEnvelopeMetaBuilder b)]) = _$VendorTeamActivityEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamActivityEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamActivityEnvelopeMeta> get serializer => _$VendorTeamActivityEnvelopeMetaSerializer();
}

class _$VendorTeamActivityEnvelopeMetaSerializer implements PrimitiveSerializer<VendorTeamActivityEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [VendorTeamActivityEnvelopeMeta, _$VendorTeamActivityEnvelopeMeta];

  @override
  final String wireName = r'VendorTeamActivityEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamActivityEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current_page';
    yield serializers.serialize(
      object.currentPage,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'total_events';
    yield serializers.serialize(
      object.totalEvents,
      specifiedType: const FullType(int),
    );
    yield r'succeeded_events';
    yield serializers.serialize(
      object.succeededEvents,
      specifiedType: const FullType(int),
    );
    yield r'failed_events';
    yield serializers.serialize(
      object.failedEvents,
      specifiedType: const FullType(int),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(VendorTeamActivityEnvelopeMetaCategoriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamActivityEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamActivityEnvelopeMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentPage = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'total_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalEvents = valueDes;
          break;
        case r'succeeded_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.succeededEvents = valueDes;
          break;
        case r'failed_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.failedEvents = valueDes;
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTeamActivityEnvelopeMetaCategoriesInner)]),
          ) as BuiltList<VendorTeamActivityEnvelopeMetaCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamActivityEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamActivityEnvelopeMetaBuilder();
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


