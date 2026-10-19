//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_reference_type.g.dart';

class SupportReferenceType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER')
  static const SupportReferenceType ORDER = _$ORDER;
  @BuiltValueEnumConst(wireName: r'PROJECT')
  static const SupportReferenceType PROJECT = _$PROJECT;
  @BuiltValueEnumConst(wireName: r'WORK_PACKAGE')
  static const SupportReferenceType WORK_PACKAGE = _$WORK_PACKAGE;
  @BuiltValueEnumConst(wireName: r'TRANSACTION')
  static const SupportReferenceType TRANSACTION = _$TRANSACTION;

  static Serializer<SupportReferenceType> get serializer => _$supportReferenceTypeSerializer;

  const SupportReferenceType._(String name): super(name);

  static BuiltSet<SupportReferenceType> get values => _$values;
  static SupportReferenceType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SupportReferenceTypeMixin = Object with _$SupportReferenceTypeMixin;

