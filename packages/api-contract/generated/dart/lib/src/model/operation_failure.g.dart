// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_failure.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OperationFailureKindEnum _$operationFailureKindEnum_FAILED_JOB =
    const OperationFailureKindEnum._('FAILED_JOB');
const OperationFailureKindEnum _$operationFailureKindEnum_OUTBOX_EVENT =
    const OperationFailureKindEnum._('OUTBOX_EVENT');

OperationFailureKindEnum _$operationFailureKindEnumValueOf(String name) {
  switch (name) {
    case 'FAILED_JOB':
      return _$operationFailureKindEnum_FAILED_JOB;
    case 'OUTBOX_EVENT':
      return _$operationFailureKindEnum_OUTBOX_EVENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OperationFailureKindEnum> _$operationFailureKindEnumValues =
    BuiltSet<OperationFailureKindEnum>(const <OperationFailureKindEnum>[
  _$operationFailureKindEnum_FAILED_JOB,
  _$operationFailureKindEnum_OUTBOX_EVENT,
]);

Serializer<OperationFailureKindEnum> _$operationFailureKindEnumSerializer =
    _$OperationFailureKindEnumSerializer();

class _$OperationFailureKindEnumSerializer
    implements PrimitiveSerializer<OperationFailureKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FAILED_JOB': 'FAILED_JOB',
    'OUTBOX_EVENT': 'OUTBOX_EVENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FAILED_JOB': 'FAILED_JOB',
    'OUTBOX_EVENT': 'OUTBOX_EVENT',
  };

  @override
  final Iterable<Type> types = const <Type>[OperationFailureKindEnum];
  @override
  final String wireName = 'OperationFailureKindEnum';

  @override
  Object serialize(Serializers serializers, OperationFailureKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OperationFailureKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OperationFailureKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OperationFailure extends OperationFailure {
  @override
  final OperationFailureKindEnum kind;
  @override
  final String reference;
  @override
  final String label;
  @override
  final String queue;
  @override
  final String failure;
  @override
  final int? attempts;
  @override
  final DateTime failedAt;
  @override
  final bool retryable;
  @override
  final String? retryNote;

  factory _$OperationFailure(
          [void Function(OperationFailureBuilder)? updates]) =>
      (OperationFailureBuilder()..update(updates))._build();

  _$OperationFailure._(
      {required this.kind,
      required this.reference,
      required this.label,
      required this.queue,
      required this.failure,
      this.attempts,
      required this.failedAt,
      required this.retryable,
      this.retryNote})
      : super._();
  @override
  OperationFailure rebuild(void Function(OperationFailureBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationFailureBuilder toBuilder() =>
      OperationFailureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationFailure &&
        kind == other.kind &&
        reference == other.reference &&
        label == other.label &&
        queue == other.queue &&
        failure == other.failure &&
        attempts == other.attempts &&
        failedAt == other.failedAt &&
        retryable == other.retryable &&
        retryNote == other.retryNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, queue.hashCode);
    _$hash = $jc(_$hash, failure.hashCode);
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jc(_$hash, failedAt.hashCode);
    _$hash = $jc(_$hash, retryable.hashCode);
    _$hash = $jc(_$hash, retryNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperationFailure')
          ..add('kind', kind)
          ..add('reference', reference)
          ..add('label', label)
          ..add('queue', queue)
          ..add('failure', failure)
          ..add('attempts', attempts)
          ..add('failedAt', failedAt)
          ..add('retryable', retryable)
          ..add('retryNote', retryNote))
        .toString();
  }
}

class OperationFailureBuilder
    implements Builder<OperationFailure, OperationFailureBuilder> {
  _$OperationFailure? _$v;

  OperationFailureKindEnum? _kind;
  OperationFailureKindEnum? get kind => _$this._kind;
  set kind(OperationFailureKindEnum? kind) => _$this._kind = kind;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _queue;
  String? get queue => _$this._queue;
  set queue(String? queue) => _$this._queue = queue;

  String? _failure;
  String? get failure => _$this._failure;
  set failure(String? failure) => _$this._failure = failure;

  int? _attempts;
  int? get attempts => _$this._attempts;
  set attempts(int? attempts) => _$this._attempts = attempts;

  DateTime? _failedAt;
  DateTime? get failedAt => _$this._failedAt;
  set failedAt(DateTime? failedAt) => _$this._failedAt = failedAt;

  bool? _retryable;
  bool? get retryable => _$this._retryable;
  set retryable(bool? retryable) => _$this._retryable = retryable;

  String? _retryNote;
  String? get retryNote => _$this._retryNote;
  set retryNote(String? retryNote) => _$this._retryNote = retryNote;

  OperationFailureBuilder() {
    OperationFailure._defaults(this);
  }

  OperationFailureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _reference = $v.reference;
      _label = $v.label;
      _queue = $v.queue;
      _failure = $v.failure;
      _attempts = $v.attempts;
      _failedAt = $v.failedAt;
      _retryable = $v.retryable;
      _retryNote = $v.retryNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperationFailure other) {
    _$v = other as _$OperationFailure;
  }

  @override
  void update(void Function(OperationFailureBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationFailure build() => _build();

  _$OperationFailure _build() {
    final _$result = _$v ??
        _$OperationFailure._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'OperationFailure', 'kind'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'OperationFailure', 'reference'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'OperationFailure', 'label'),
          queue: BuiltValueNullFieldError.checkNotNull(
              queue, r'OperationFailure', 'queue'),
          failure: BuiltValueNullFieldError.checkNotNull(
              failure, r'OperationFailure', 'failure'),
          attempts: attempts,
          failedAt: BuiltValueNullFieldError.checkNotNull(
              failedAt, r'OperationFailure', 'failedAt'),
          retryable: BuiltValueNullFieldError.checkNotNull(
              retryable, r'OperationFailure', 'retryable'),
          retryNote: retryNote,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
