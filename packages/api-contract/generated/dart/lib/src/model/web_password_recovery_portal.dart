//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'web_password_recovery_portal.g.dart';

class WebPasswordRecoveryPortal extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const WebPasswordRecoveryPortal VENDOR = _$VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const WebPasswordRecoveryPortal ADMIN = _$ADMIN;

  static Serializer<WebPasswordRecoveryPortal> get serializer => _$webPasswordRecoveryPortalSerializer;

  const WebPasswordRecoveryPortal._(String name): super(name);

  static BuiltSet<WebPasswordRecoveryPortal> get values => _$values;
  static WebPasswordRecoveryPortal valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class WebPasswordRecoveryPortalMixin = Object with _$WebPasswordRecoveryPortalMixin;

