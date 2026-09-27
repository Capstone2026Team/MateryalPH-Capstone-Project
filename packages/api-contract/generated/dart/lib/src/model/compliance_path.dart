//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_path.g.dart';

class CompliancePath extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PHOTO_OCR')
  static const CompliancePath PHOTO_OCR = _$PHOTO_OCR;
  @BuiltValueEnumConst(wireName: r'QR')
  static const CompliancePath QR = _$QR;
  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const CompliancePath MANUAL = _$MANUAL;

  static Serializer<CompliancePath> get serializer => _$compliancePathSerializer;

  const CompliancePath._(String name): super(name);

  static BuiltSet<CompliancePath> get values => _$values;
  static CompliancePath valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CompliancePathMixin = Object with _$CompliancePathMixin;

