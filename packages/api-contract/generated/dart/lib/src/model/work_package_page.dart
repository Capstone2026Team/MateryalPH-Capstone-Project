//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/work_package_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_page.g.dart';

/// WorkPackagePage
///
/// Properties:
/// * [items]
/// * [page]
/// * [hasMore]
@BuiltValue()
abstract class WorkPackagePage implements Built<WorkPackagePage, WorkPackagePageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<WorkPackageSummary> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  WorkPackagePage._();

  factory WorkPackagePage([void updates(WorkPackagePageBuilder b)]) = _$WorkPackagePage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackagePageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackagePage> get serializer => _$WorkPackagePageSerializer();
}

class _$WorkPackagePageSerializer implements PrimitiveSerializer<WorkPackagePage> {
  @override
  final Iterable<Type> types = const [WorkPackagePage, _$WorkPackagePage];

  @override
  final String wireName = r'WorkPackagePage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackagePage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(WorkPackageSummary)]),
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
    WorkPackagePage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackagePageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WorkPackageSummary)]),
          ) as BuiltList<WorkPackageSummary>;
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
  WorkPackagePage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackagePageBuilder();
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


