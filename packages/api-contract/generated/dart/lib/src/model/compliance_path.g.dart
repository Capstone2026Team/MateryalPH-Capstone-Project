// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_path.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CompliancePath _$PHOTO_OCR = const CompliancePath._('PHOTO_OCR');
const CompliancePath _$QR = const CompliancePath._('QR');
const CompliancePath _$MANUAL = const CompliancePath._('MANUAL');

CompliancePath _$valueOf(String name) {
  switch (name) {
    case 'PHOTO_OCR':
      return _$PHOTO_OCR;
    case 'QR':
      return _$QR;
    case 'MANUAL':
      return _$MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CompliancePath> _$values =
    BuiltSet<CompliancePath>(const <CompliancePath>[
  _$PHOTO_OCR,
  _$QR,
  _$MANUAL,
]);

class _$CompliancePathMeta {
  const _$CompliancePathMeta();
  CompliancePath get PHOTO_OCR => _$PHOTO_OCR;
  CompliancePath get QR => _$QR;
  CompliancePath get MANUAL => _$MANUAL;
  CompliancePath valueOf(String name) => _$valueOf(name);
  BuiltSet<CompliancePath> get values => _$values;
}

abstract class _$CompliancePathMixin {
  // ignore: non_constant_identifier_names
  _$CompliancePathMeta get CompliancePath => const _$CompliancePathMeta();
}

Serializer<CompliancePath> _$compliancePathSerializer =
    _$CompliancePathSerializer();

class _$CompliancePathSerializer
    implements PrimitiveSerializer<CompliancePath> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHOTO_OCR': 'PHOTO_OCR',
    'QR': 'QR',
    'MANUAL': 'MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHOTO_OCR': 'PHOTO_OCR',
    'QR': 'QR',
    'MANUAL': 'MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[CompliancePath];
  @override
  final String wireName = 'CompliancePath';

  @override
  Object serialize(Serializers serializers, CompliancePath object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CompliancePath deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CompliancePath.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
