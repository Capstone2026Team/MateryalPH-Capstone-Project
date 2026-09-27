// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_reference_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceReferenceResult _$MATCHED =
    const ComplianceReferenceResult._('MATCHED');
const ComplianceReferenceResult _$UNMATCHED =
    const ComplianceReferenceResult._('UNMATCHED');
const ComplianceReferenceResult _$UNCERTAIN =
    const ComplianceReferenceResult._('UNCERTAIN');
const ComplianceReferenceResult _$UNAVAILABLE =
    const ComplianceReferenceResult._('UNAVAILABLE');

ComplianceReferenceResult _$valueOf(String name) {
  switch (name) {
    case 'MATCHED':
      return _$MATCHED;
    case 'UNMATCHED':
      return _$UNMATCHED;
    case 'UNCERTAIN':
      return _$UNCERTAIN;
    case 'UNAVAILABLE':
      return _$UNAVAILABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceReferenceResult> _$values =
    BuiltSet<ComplianceReferenceResult>(const <ComplianceReferenceResult>[
  _$MATCHED,
  _$UNMATCHED,
  _$UNCERTAIN,
  _$UNAVAILABLE,
]);

class _$ComplianceReferenceResultMeta {
  const _$ComplianceReferenceResultMeta();
  ComplianceReferenceResult get MATCHED => _$MATCHED;
  ComplianceReferenceResult get UNMATCHED => _$UNMATCHED;
  ComplianceReferenceResult get UNCERTAIN => _$UNCERTAIN;
  ComplianceReferenceResult get UNAVAILABLE => _$UNAVAILABLE;
  ComplianceReferenceResult valueOf(String name) => _$valueOf(name);
  BuiltSet<ComplianceReferenceResult> get values => _$values;
}

abstract class _$ComplianceReferenceResultMixin {
  // ignore: non_constant_identifier_names
  _$ComplianceReferenceResultMeta get ComplianceReferenceResult =>
      const _$ComplianceReferenceResultMeta();
}

Serializer<ComplianceReferenceResult> _$complianceReferenceResultSerializer =
    _$ComplianceReferenceResultSerializer();

class _$ComplianceReferenceResultSerializer
    implements PrimitiveSerializer<ComplianceReferenceResult> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MATCHED': 'MATCHED',
    'UNMATCHED': 'UNMATCHED',
    'UNCERTAIN': 'UNCERTAIN',
    'UNAVAILABLE': 'UNAVAILABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MATCHED': 'MATCHED',
    'UNMATCHED': 'UNMATCHED',
    'UNCERTAIN': 'UNCERTAIN',
    'UNAVAILABLE': 'UNAVAILABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceReferenceResult];
  @override
  final String wireName = 'ComplianceReferenceResult';

  @override
  Object serialize(Serializers serializers, ComplianceReferenceResult object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceReferenceResult deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceReferenceResult.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
