//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_portal.g.dart';

class SupportPortal extends EnumClass {

  @BuiltValueEnumConst(wireName: r'buyers')
  static const SupportPortal buyers = _$buyers;
  @BuiltValueEnumConst(wireName: r'vendors')
  static const SupportPortal vendors = _$vendors;
  @BuiltValueEnumConst(wireName: r'admin')
  static const SupportPortal admin = _$admin;
  @BuiltValueEnumConst(wireName: r'guest')
  static const SupportPortal guest = _$guest;

  static Serializer<SupportPortal> get serializer => _$supportPortalSerializer;

  const SupportPortal._(String name): super(name);

  static BuiltSet<SupportPortal> get values => _$values;
  static SupportPortal valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SupportPortalMixin = Object with _$SupportPortalMixin;

