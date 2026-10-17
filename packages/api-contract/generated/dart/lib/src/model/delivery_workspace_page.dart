//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/delivery_workspace_page_meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/order_detail.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delivery_workspace_page.g.dart';

/// DeliveryWorkspacePage
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class DeliveryWorkspacePage implements Built<DeliveryWorkspacePage, DeliveryWorkspacePageBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<OrderDetail> get data;

  @BuiltValueField(wireName: r'meta')
  DeliveryWorkspacePageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError>? get errors;

  DeliveryWorkspacePage._();

  factory DeliveryWorkspacePage([void updates(DeliveryWorkspacePageBuilder b)]) = _$DeliveryWorkspacePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeliveryWorkspacePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeliveryWorkspacePage> get serializer => _$DeliveryWorkspacePageSerializer();
}

class _$DeliveryWorkspacePageSerializer implements PrimitiveSerializer<DeliveryWorkspacePage> {
  @override
  final Iterable<Type> types = const [DeliveryWorkspacePage, _$DeliveryWorkspacePage];

  @override
  final String wireName = r'DeliveryWorkspacePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeliveryWorkspacePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(OrderDetail)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(DeliveryWorkspacePageMeta),
    );
    if (object.errors != null) {
      yield r'errors';
      yield serializers.serialize(
        object.errors,
        specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeliveryWorkspacePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeliveryWorkspacePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(OrderDetail)]),
          ) as BuiltList<OrderDetail>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeliveryWorkspacePageMeta),
          ) as DeliveryWorkspacePageMeta;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>?;
          if (valueDes == null) continue;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeliveryWorkspacePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeliveryWorkspacePageBuilder();
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


