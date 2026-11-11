// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_acknowledgment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TutorialAcknowledgmentStatusEnum
    _$tutorialAcknowledgmentStatusEnum_COMPLETED =
    const TutorialAcknowledgmentStatusEnum._('COMPLETED');
const TutorialAcknowledgmentStatusEnum
    _$tutorialAcknowledgmentStatusEnum_SKIPPED =
    const TutorialAcknowledgmentStatusEnum._('SKIPPED');

TutorialAcknowledgmentStatusEnum _$tutorialAcknowledgmentStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'COMPLETED':
      return _$tutorialAcknowledgmentStatusEnum_COMPLETED;
    case 'SKIPPED':
      return _$tutorialAcknowledgmentStatusEnum_SKIPPED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TutorialAcknowledgmentStatusEnum>
    _$tutorialAcknowledgmentStatusEnumValues = BuiltSet<
        TutorialAcknowledgmentStatusEnum>(const <TutorialAcknowledgmentStatusEnum>[
  _$tutorialAcknowledgmentStatusEnum_COMPLETED,
  _$tutorialAcknowledgmentStatusEnum_SKIPPED,
]);

Serializer<TutorialAcknowledgmentStatusEnum>
    _$tutorialAcknowledgmentStatusEnumSerializer =
    _$TutorialAcknowledgmentStatusEnumSerializer();

class _$TutorialAcknowledgmentStatusEnumSerializer
    implements PrimitiveSerializer<TutorialAcknowledgmentStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPLETED': 'COMPLETED',
    'SKIPPED': 'SKIPPED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPLETED': 'COMPLETED',
    'SKIPPED': 'SKIPPED',
  };

  @override
  final Iterable<Type> types = const <Type>[TutorialAcknowledgmentStatusEnum];
  @override
  final String wireName = 'TutorialAcknowledgmentStatusEnum';

  @override
  Object serialize(
          Serializers serializers, TutorialAcknowledgmentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TutorialAcknowledgmentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TutorialAcknowledgmentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TutorialAcknowledgment extends TutorialAcknowledgment {
  @override
  final TutorialAcknowledgmentStatusEnum status;

  factory _$TutorialAcknowledgment(
          [void Function(TutorialAcknowledgmentBuilder)? updates]) =>
      (TutorialAcknowledgmentBuilder()..update(updates))._build();

  _$TutorialAcknowledgment._({required this.status}) : super._();
  @override
  TutorialAcknowledgment rebuild(
          void Function(TutorialAcknowledgmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TutorialAcknowledgmentBuilder toBuilder() =>
      TutorialAcknowledgmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TutorialAcknowledgment && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TutorialAcknowledgment')
          ..add('status', status))
        .toString();
  }
}

class TutorialAcknowledgmentBuilder
    implements Builder<TutorialAcknowledgment, TutorialAcknowledgmentBuilder> {
  _$TutorialAcknowledgment? _$v;

  TutorialAcknowledgmentStatusEnum? _status;
  TutorialAcknowledgmentStatusEnum? get status => _$this._status;
  set status(TutorialAcknowledgmentStatusEnum? status) =>
      _$this._status = status;

  TutorialAcknowledgmentBuilder() {
    TutorialAcknowledgment._defaults(this);
  }

  TutorialAcknowledgmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TutorialAcknowledgment other) {
    _$v = other as _$TutorialAcknowledgment;
  }

  @override
  void update(void Function(TutorialAcknowledgmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TutorialAcknowledgment build() => _build();

  _$TutorialAcknowledgment _build() {
    final _$result = _$v ??
        _$TutorialAcknowledgment._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TutorialAcknowledgment', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
