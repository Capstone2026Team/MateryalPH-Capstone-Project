//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/work_package_version.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_version_page.g.dart';

/// WorkPackageVersionPage
///
/// Properties:
/// * [items]
/// * [page]
/// * [hasMore]
@BuiltValue()
abstract class WorkPackageVersionPage implements Built<WorkPackageVersionPage, WorkPackageVersionPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<WorkPackageVersion> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  WorkPackageVersionPage._();

  factory WorkPackageVersionPage([void updates(WorkPackageVersionPageBuilder b)]) = _$WorkPackageVersionPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageVersionPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageVersionPage> get serializer => _$WorkPackageVersionPageSerializer();
}

class _$WorkPackageVersionPageSerializer implements PrimitiveSerializer<WorkPackageVersionPage> {
  @override
  final Iterable<Type> types = const [WorkPackageVersionPage, _$WorkPackageVersionPage];

  @override
  final String wireName = r'WorkPackageVersionPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageVersionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageVersion)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageVersionPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageVersionPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageVersion)]),
          ) as BuiltList<WorkPackageVersion>;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageVersionPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageVersionPageBuilder();
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


