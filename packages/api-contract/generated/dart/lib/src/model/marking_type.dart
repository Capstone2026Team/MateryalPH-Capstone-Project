//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'marking_type.g.dart';

class MarkingType extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PS_MARK')
  static const MarkingType PS_MARK = _$PS_MARK;
  @BuiltValueEnumConst(wireName: r'ICC_STICKER')
  static const MarkingType ICC_STICKER = _$ICC_STICKER;

  static Serializer<MarkingType> get serializer => _$markingTypeSerializer;

  const MarkingType._(String name): super(name);

  static BuiltSet<MarkingType> get values => _$values;
  static MarkingType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MarkingTypeMixin = Object with _$MarkingTypeMixin;

