// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_step_completion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_V1 =
    const OnboardingStepCompletionKeyEnum._('V1');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_V2 =
    const OnboardingStepCompletionKeyEnum._('V2');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_V3 =
    const OnboardingStepCompletionKeyEnum._('V3');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_V4 =
    const OnboardingStepCompletionKeyEnum._('V4');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_S1 =
    const OnboardingStepCompletionKeyEnum._('S1');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_S2 =
    const OnboardingStepCompletionKeyEnum._('S2');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_S3 =
    const OnboardingStepCompletionKeyEnum._('S3');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_S4 =
    const OnboardingStepCompletionKeyEnum._('S4');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_S5 =
    const OnboardingStepCompletionKeyEnum._('S5');
const OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnum_S6 =
    const OnboardingStepCompletionKeyEnum._('S6');

OnboardingStepCompletionKeyEnum _$onboardingStepCompletionKeyEnumValueOf(
    String name) {
  switch (name) {
    case 'V1':
      return _$onboardingStepCompletionKeyEnum_V1;
    case 'V2':
      return _$onboardingStepCompletionKeyEnum_V2;
    case 'V3':
      return _$onboardingStepCompletionKeyEnum_V3;
    case 'V4':
      return _$onboardingStepCompletionKeyEnum_V4;
    case 'S1':
      return _$onboardingStepCompletionKeyEnum_S1;
    case 'S2':
      return _$onboardingStepCompletionKeyEnum_S2;
    case 'S3':
      return _$onboardingStepCompletionKeyEnum_S3;
    case 'S4':
      return _$onboardingStepCompletionKeyEnum_S4;
    case 'S5':
      return _$onboardingStepCompletionKeyEnum_S5;
    case 'S6':
      return _$onboardingStepCompletionKeyEnum_S6;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OnboardingStepCompletionKeyEnum>
    _$onboardingStepCompletionKeyEnumValues = BuiltSet<
        OnboardingStepCompletionKeyEnum>(const <OnboardingStepCompletionKeyEnum>[
  _$onboardingStepCompletionKeyEnum_V1,
  _$onboardingStepCompletionKeyEnum_V2,
  _$onboardingStepCompletionKeyEnum_V3,
  _$onboardingStepCompletionKeyEnum_V4,
  _$onboardingStepCompletionKeyEnum_S1,
  _$onboardingStepCompletionKeyEnum_S2,
  _$onboardingStepCompletionKeyEnum_S3,
  _$onboardingStepCompletionKeyEnum_S4,
  _$onboardingStepCompletionKeyEnum_S5,
  _$onboardingStepCompletionKeyEnum_S6,
]);

const OnboardingStepCompletionWorkstreamEnum
    _$onboardingStepCompletionWorkstreamEnum_STORE_VERIFICATION =
    const OnboardingStepCompletionWorkstreamEnum._('STORE_VERIFICATION');
const OnboardingStepCompletionWorkstreamEnum
    _$onboardingStepCompletionWorkstreamEnum_STORE_SETUP =
    const OnboardingStepCompletionWorkstreamEnum._('STORE_SETUP');

OnboardingStepCompletionWorkstreamEnum
    _$onboardingStepCompletionWorkstreamEnumValueOf(String name) {
  switch (name) {
    case 'STORE_VERIFICATION':
      return _$onboardingStepCompletionWorkstreamEnum_STORE_VERIFICATION;
    case 'STORE_SETUP':
      return _$onboardingStepCompletionWorkstreamEnum_STORE_SETUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OnboardingStepCompletionWorkstreamEnum>
    _$onboardingStepCompletionWorkstreamEnumValues = BuiltSet<
        OnboardingStepCompletionWorkstreamEnum>(const <OnboardingStepCompletionWorkstreamEnum>[
  _$onboardingStepCompletionWorkstreamEnum_STORE_VERIFICATION,
  _$onboardingStepCompletionWorkstreamEnum_STORE_SETUP,
]);

Serializer<OnboardingStepCompletionKeyEnum>
    _$onboardingStepCompletionKeyEnumSerializer =
    _$OnboardingStepCompletionKeyEnumSerializer();
Serializer<OnboardingStepCompletionWorkstreamEnum>
    _$onboardingStepCompletionWorkstreamEnumSerializer =
    _$OnboardingStepCompletionWorkstreamEnumSerializer();

class _$OnboardingStepCompletionKeyEnumSerializer
    implements PrimitiveSerializer<OnboardingStepCompletionKeyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'V1': 'V1',
    'V2': 'V2',
    'V3': 'V3',
    'V4': 'V4',
    'S1': 'S1',
    'S2': 'S2',
    'S3': 'S3',
    'S4': 'S4',
    'S5': 'S5',
    'S6': 'S6',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'V1': 'V1',
    'V2': 'V2',
    'V3': 'V3',
    'V4': 'V4',
    'S1': 'S1',
    'S2': 'S2',
    'S3': 'S3',
    'S4': 'S4',
    'S5': 'S5',
    'S6': 'S6',
  };

  @override
  final Iterable<Type> types = const <Type>[OnboardingStepCompletionKeyEnum];
  @override
  final String wireName = 'OnboardingStepCompletionKeyEnum';

  @override
  Object serialize(
          Serializers serializers, OnboardingStepCompletionKeyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OnboardingStepCompletionKeyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OnboardingStepCompletionKeyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OnboardingStepCompletionWorkstreamEnumSerializer
    implements PrimitiveSerializer<OnboardingStepCompletionWorkstreamEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STORE_VERIFICATION': 'STORE_VERIFICATION',
    'STORE_SETUP': 'STORE_SETUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STORE_VERIFICATION': 'STORE_VERIFICATION',
    'STORE_SETUP': 'STORE_SETUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    OnboardingStepCompletionWorkstreamEnum
  ];
  @override
  final String wireName = 'OnboardingStepCompletionWorkstreamEnum';

  @override
  Object serialize(Serializers serializers,
          OnboardingStepCompletionWorkstreamEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OnboardingStepCompletionWorkstreamEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OnboardingStepCompletionWorkstreamEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OnboardingStepCompletion extends OnboardingStepCompletion {
  @override
  final OnboardingStepCompletionKeyEnum key;
  @override
  final OnboardingStepCompletionWorkstreamEnum workstream;
  @override
  final bool complete;
  @override
  final bool required_;

  factory _$OnboardingStepCompletion(
          [void Function(OnboardingStepCompletionBuilder)? updates]) =>
      (OnboardingStepCompletionBuilder()..update(updates))._build();

  _$OnboardingStepCompletion._(
      {required this.key,
      required this.workstream,
      required this.complete,
      required this.required_})
      : super._();
  @override
  OnboardingStepCompletion rebuild(
          void Function(OnboardingStepCompletionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OnboardingStepCompletionBuilder toBuilder() =>
      OnboardingStepCompletionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OnboardingStepCompletion &&
        key == other.key &&
        workstream == other.workstream &&
        complete == other.complete &&
        required_ == other.required_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, workstream.hashCode);
    _$hash = $jc(_$hash, complete.hashCode);
    _$hash = $jc(_$hash, required_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OnboardingStepCompletion')
          ..add('key', key)
          ..add('workstream', workstream)
          ..add('complete', complete)
          ..add('required_', required_))
        .toString();
  }
}

class OnboardingStepCompletionBuilder
    implements
        Builder<OnboardingStepCompletion, OnboardingStepCompletionBuilder> {
  _$OnboardingStepCompletion? _$v;

  OnboardingStepCompletionKeyEnum? _key;
  OnboardingStepCompletionKeyEnum? get key => _$this._key;
  set key(OnboardingStepCompletionKeyEnum? key) => _$this._key = key;

  OnboardingStepCompletionWorkstreamEnum? _workstream;
  OnboardingStepCompletionWorkstreamEnum? get workstream => _$this._workstream;
  set workstream(OnboardingStepCompletionWorkstreamEnum? workstream) =>
      _$this._workstream = workstream;

  bool? _complete;
  bool? get complete => _$this._complete;
  set complete(bool? complete) => _$this._complete = complete;

  bool? _required_;
  bool? get required_ => _$this._required_;
  set required_(bool? required_) => _$this._required_ = required_;

  OnboardingStepCompletionBuilder() {
    OnboardingStepCompletion._defaults(this);
  }

  OnboardingStepCompletionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _workstream = $v.workstream;
      _complete = $v.complete;
      _required_ = $v.required_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OnboardingStepCompletion other) {
    _$v = other as _$OnboardingStepCompletion;
  }

  @override
  void update(void Function(OnboardingStepCompletionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OnboardingStepCompletion build() => _build();

  _$OnboardingStepCompletion _build() {
    final _$result = _$v ??
        _$OnboardingStepCompletion._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'OnboardingStepCompletion', 'key'),
          workstream: BuiltValueNullFieldError.checkNotNull(
              workstream, r'OnboardingStepCompletion', 'workstream'),
          complete: BuiltValueNullFieldError.checkNotNull(
              complete, r'OnboardingStepCompletion', 'complete'),
          required_: BuiltValueNullFieldError.checkNotNull(
              required_, r'OnboardingStepCompletion', 'required_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
