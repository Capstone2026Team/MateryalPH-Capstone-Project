//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_category.g.dart';

class SupportCategory extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GENERAL_INQUIRY')
  static const SupportCategory GENERAL_INQUIRY = _$GENERAL_INQUIRY;
  @BuiltValueEnumConst(wireName: r'TECHNICAL_ISSUE')
  static const SupportCategory TECHNICAL_ISSUE = _$TECHNICAL_ISSUE;
  @BuiltValueEnumConst(wireName: r'ACCOUNT_CONCERN')
  static const SupportCategory ACCOUNT_CONCERN = _$ACCOUNT_CONCERN;
  @BuiltValueEnumConst(wireName: r'VERIFICATION_ISSUE')
  static const SupportCategory VERIFICATION_ISSUE = _$VERIFICATION_ISSUE;
  @BuiltValueEnumConst(wireName: r'PAYMENT_CONCERN')
  static const SupportCategory PAYMENT_CONCERN = _$PAYMENT_CONCERN;
  @BuiltValueEnumConst(wireName: r'ORDER_CONCERN')
  static const SupportCategory ORDER_CONCERN = _$ORDER_CONCERN;
  @BuiltValueEnumConst(wireName: r'COMPLAINT')
  static const SupportCategory COMPLAINT = _$COMPLAINT;
  @BuiltValueEnumConst(wireName: r'FEEDBACK_SUGGESTION')
  static const SupportCategory FEEDBACK_SUGGESTION = _$FEEDBACK_SUGGESTION;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const SupportCategory OTHER = _$OTHER;

  static Serializer<SupportCategory> get serializer => _$supportCategorySerializer;

  const SupportCategory._(String name): super(name);

  static BuiltSet<SupportCategory> get values => _$values;
  static SupportCategory valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SupportCategoryMixin = Object with _$SupportCategoryMixin;

