//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'dart:core';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'directory_review_ratings_value.g.dart';

/// DirectoryReviewRatingsValue
@BuiltValue()
abstract class DirectoryReviewRatingsValue implements Built<DirectoryReviewRatingsValue, DirectoryReviewRatingsValueBuilder> {
  /// Any Of [String], [int]
  AnyOf get anyOf;

  DirectoryReviewRatingsValue._();

  factory DirectoryReviewRatingsValue([void updates(DirectoryReviewRatingsValueBuilder b)]) = _$DirectoryReviewRatingsValue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryReviewRatingsValueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryReviewRatingsValue> get serializer => _$DirectoryReviewRatingsValueSerializer();
}

class _$DirectoryReviewRatingsValueSerializer implements PrimitiveSerializer<DirectoryReviewRatingsValue> {
  @override
  final Iterable<Type> types = const [DirectoryReviewRatingsValue, _$DirectoryReviewRatingsValue];

  @override
  final String wireName = r'DirectoryReviewRatingsValue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryReviewRatingsValue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryReviewRatingsValue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf, specifiedType: FullType(AnyOf, anyOf.types.map((type) => FullType(type)).toList()))!;
  }

  @override
  DirectoryReviewRatingsValue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryReviewRatingsValueBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [FullType(int), FullType(String), ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc, specifiedType: targetType) as AnyOf;
    return result.build();
  }
}


