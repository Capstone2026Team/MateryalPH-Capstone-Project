//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_user_type.g.dart';

class SupportUserType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const SupportUserType BUYER = _$BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const SupportUserType VENDOR = _$VENDOR;
  @BuiltValueEnumConst(wireName: r'GUEST')
  static const SupportUserType GUEST = _$GUEST;

  static Serializer<SupportUserType> get serializer => _$supportUserTypeSerializer;

  const SupportUserType._(String name): super(name);

  static BuiltSet<SupportUserType> get values => _$values;
  static SupportUserType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SupportUserTypeMixin = Object with _$SupportUserTypeMixin;

