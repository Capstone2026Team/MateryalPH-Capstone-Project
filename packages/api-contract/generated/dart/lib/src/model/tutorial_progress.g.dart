// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_progress.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TutorialProgressStatusEnum _$tutorialProgressStatusEnum_COMPLETED =
    const TutorialProgressStatusEnum._('COMPLETED');
const TutorialProgressStatusEnum _$tutorialProgressStatusEnum_SKIPPED =
    const TutorialProgressStatusEnum._('SKIPPED');

TutorialProgressStatusEnum _$tutorialProgressStatusEnumValueOf(String name) {
  switch (name) {
    case 'COMPLETED':
      return _$tutorialProgressStatusEnum_COMPLETED;
    case 'SKIPPED':
      return _$tutorialProgressStatusEnum_SKIPPED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TutorialProgressStatusEnum> _$tutorialProgressStatusEnumValues =
    BuiltSet<TutorialProgressStatusEnum>(const <TutorialProgressStatusEnum>[
  _$tutorialProgressStatusEnum_COMPLETED,
  _$tutorialProgressStatusEnum_SKIPPED,
]);

Serializer<TutorialProgressStatusEnum> _$tutorialProgressStatusEnumSerializer =
    _$TutorialProgressStatusEnumSerializer();

class _$TutorialProgressStatusEnumSerializer
    implements PrimitiveSerializer<TutorialProgressStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPLETED': 'COMPLETED',
    'SKIPPED': 'SKIPPED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPLETED': 'COMPLETED',
    'SKIPPED': 'SKIPPED',
  };

  @override
  final Iterable<Type> types = const <Type>[TutorialProgressStatusEnum];
  @override
  final String wireName = 'TutorialProgressStatusEnum';

  @override
  Object serialize(Serializers serializers, TutorialProgressStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TutorialProgressStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TutorialProgressStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TutorialProgress extends TutorialProgress {
  @override
  final String tutorialKey;
  @override
  final TutorialProgressStatusEnum status;
  @override
  final DateTime updatedAt;

  factory _$TutorialProgress(
          [void Function(TutorialProgressBuilder)? updates]) =>
      (TutorialProgressBuilder()..update(updates))._build();

  _$TutorialProgress._(
      {required this.tutorialKey,
      required this.status,
      required this.updatedAt})
      : super._();
  @override
  TutorialProgress rebuild(void Function(TutorialProgressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TutorialProgressBuilder toBuilder() =>
      TutorialProgressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TutorialProgress &&
        tutorialKey == other.tutorialKey &&
        status == other.status &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tutorialKey.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TutorialProgress')
          ..add('tutorialKey', tutorialKey)
          ..add('status', status)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class TutorialProgressBuilder
    implements Builder<TutorialProgress, TutorialProgressBuilder> {
  _$TutorialProgress? _$v;

  String? _tutorialKey;
  String? get tutorialKey => _$this._tutorialKey;
  set tutorialKey(String? tutorialKey) => _$this._tutorialKey = tutorialKey;

  TutorialProgressStatusEnum? _status;
  TutorialProgressStatusEnum? get status => _$this._status;
  set status(TutorialProgressStatusEnum? status) => _$this._status = status;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  TutorialProgressBuilder() {
    TutorialProgress._defaults(this);
  }

  TutorialProgressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tutorialKey = $v.tutorialKey;
      _status = $v.status;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TutorialProgress other) {
    _$v = other as _$TutorialProgress;
  }

  @override
  void update(void Function(TutorialProgressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TutorialProgress build() => _build();

  _$TutorialProgress _build() {
    final _$result = _$v ??
        _$TutorialProgress._(
          tutorialKey: BuiltValueNullFieldError.checkNotNull(
              tutorialKey, r'TutorialProgress', 'tutorialKey'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TutorialProgress', 'status'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'TutorialProgress', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
