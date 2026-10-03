// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset_label.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DatasetLabelKindEnum _$datasetLabelKindEnum_TEST =
    const DatasetLabelKindEnum._('TEST');
const DatasetLabelKindEnum _$datasetLabelKindEnum_LIVE =
    const DatasetLabelKindEnum._('LIVE');

DatasetLabelKindEnum _$datasetLabelKindEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$datasetLabelKindEnum_TEST;
    case 'LIVE':
      return _$datasetLabelKindEnum_LIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DatasetLabelKindEnum> _$datasetLabelKindEnumValues =
    BuiltSet<DatasetLabelKindEnum>(const <DatasetLabelKindEnum>[
  _$datasetLabelKindEnum_TEST,
  _$datasetLabelKindEnum_LIVE,
]);

Serializer<DatasetLabelKindEnum> _$datasetLabelKindEnumSerializer =
    _$DatasetLabelKindEnumSerializer();

class _$DatasetLabelKindEnumSerializer
    implements PrimitiveSerializer<DatasetLabelKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
    'LIVE': 'LIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
    'LIVE': 'LIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[DatasetLabelKindEnum];
  @override
  final String wireName = 'DatasetLabelKindEnum';

  @override
  Object serialize(Serializers serializers, DatasetLabelKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DatasetLabelKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DatasetLabelKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DatasetLabel extends DatasetLabel {
  @override
  final DatasetLabelKindEnum kind;
  @override
  final String? label;

  factory _$DatasetLabel([void Function(DatasetLabelBuilder)? updates]) =>
      (DatasetLabelBuilder()..update(updates))._build();

  _$DatasetLabel._({required this.kind, this.label}) : super._();
  @override
  DatasetLabel rebuild(void Function(DatasetLabelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatasetLabelBuilder toBuilder() => DatasetLabelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatasetLabel && kind == other.kind && label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DatasetLabel')
          ..add('kind', kind)
          ..add('label', label))
        .toString();
  }
}

class DatasetLabelBuilder
    implements Builder<DatasetLabel, DatasetLabelBuilder> {
  _$DatasetLabel? _$v;

  DatasetLabelKindEnum? _kind;
  DatasetLabelKindEnum? get kind => _$this._kind;
  set kind(DatasetLabelKindEnum? kind) => _$this._kind = kind;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  DatasetLabelBuilder() {
    DatasetLabel._defaults(this);
  }

  DatasetLabelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatasetLabel other) {
    _$v = other as _$DatasetLabel;
  }

  @override
  void update(void Function(DatasetLabelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatasetLabel build() => _build();

  _$DatasetLabel _build() {
    final _$result = _$v ??
        _$DatasetLabel._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'DatasetLabel', 'kind'),
          label: label,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
