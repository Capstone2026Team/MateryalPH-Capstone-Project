//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auto_accept_status.g.dart';

class AutoAcceptStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISABLED')
  static const AutoAcceptStatus DISABLED = _$DISABLED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AutoAcceptStatus ACTIVE = _$ACTIVE;
  @BuiltValueEnumConst(wireName: r'PAUSED')
  static const AutoAcceptStatus PAUSED = _$PAUSED;

  static Serializer<AutoAcceptStatus> get serializer => _$autoAcceptStatusSerializer;

  const AutoAcceptStatus._(String name): super(name);

  static BuiltSet<AutoAcceptStatus> get values => _$values;
  static AutoAcceptStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AutoAcceptStatusMixin = Object with _$AutoAcceptStatusMixin;

