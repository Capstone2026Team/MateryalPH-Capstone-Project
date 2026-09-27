//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_reference_result.g.dart';

class ComplianceReferenceResult extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MATCHED')
  static const ComplianceReferenceResult MATCHED = _$MATCHED;
  @BuiltValueEnumConst(wireName: r'UNMATCHED')
  static const ComplianceReferenceResult UNMATCHED = _$UNMATCHED;
  @BuiltValueEnumConst(wireName: r'UNCERTAIN')
  static const ComplianceReferenceResult UNCERTAIN = _$UNCERTAIN;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const ComplianceReferenceResult UNAVAILABLE = _$UNAVAILABLE;

  static Serializer<ComplianceReferenceResult> get serializer => _$complianceReferenceResultSerializer;

  const ComplianceReferenceResult._(String name): super(name);

  static BuiltSet<ComplianceReferenceResult> get values => _$values;
  static ComplianceReferenceResult valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ComplianceReferenceResultMixin = Object with _$ComplianceReferenceResultMixin;

