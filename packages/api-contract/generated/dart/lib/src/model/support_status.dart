//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_status.g.dart';

class SupportStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const SupportStatus OPEN = _$OPEN;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const SupportStatus IN_PROGRESS = _$IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'WAITING_FOR_USER')
  static const SupportStatus WAITING_FOR_USER = _$WAITING_FOR_USER;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const SupportStatus RESOLVED = _$RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const SupportStatus CLOSED = _$CLOSED;

  static Serializer<SupportStatus> get serializer => _$supportStatusSerializer;

  const SupportStatus._(String name): super(name);

  static BuiltSet<SupportStatus> get values => _$values;
  static SupportStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SupportStatusMixin = Object with _$SupportStatusMixin;

