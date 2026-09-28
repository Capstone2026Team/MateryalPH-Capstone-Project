//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_location_kind.g.dart';

class BuyerLocationKind extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const BuyerLocationKind DELIVERY = _$DELIVERY;
  @BuiltValueEnumConst(wireName: r'BUSINESS')
  static const BuyerLocationKind BUSINESS = _$BUSINESS;
  @BuiltValueEnumConst(wireName: r'PROJECT_SITE')
  static const BuyerLocationKind PROJECT_SITE = _$PROJECT_SITE;
  @BuiltValueEnumConst(wireName: r'PICKUP_REFERENCE')
  static const BuyerLocationKind PICKUP_REFERENCE = _$PICKUP_REFERENCE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const BuyerLocationKind OTHER = _$OTHER;

  static Serializer<BuyerLocationKind> get serializer => _$buyerLocationKindSerializer;

  const BuyerLocationKind._(String name): super(name);

  static BuiltSet<BuyerLocationKind> get values => _$values;
  static BuyerLocationKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class BuyerLocationKindMixin = Object with _$BuyerLocationKindMixin;

