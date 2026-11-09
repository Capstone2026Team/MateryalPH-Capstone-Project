// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_account_deletion_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorAccountDeletionPreviewConfirmationPhraseEnum
    _$vendorAccountDeletionPreviewConfirmationPhraseEnum_DELETE =
    const VendorAccountDeletionPreviewConfirmationPhraseEnum._('DELETE');

VendorAccountDeletionPreviewConfirmationPhraseEnum
    _$vendorAccountDeletionPreviewConfirmationPhraseEnumValueOf(String name) {
  switch (name) {
    case 'DELETE':
      return _$vendorAccountDeletionPreviewConfirmationPhraseEnum_DELETE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorAccountDeletionPreviewConfirmationPhraseEnum>
    _$vendorAccountDeletionPreviewConfirmationPhraseEnumValues = BuiltSet<
        VendorAccountDeletionPreviewConfirmationPhraseEnum>(const <VendorAccountDeletionPreviewConfirmationPhraseEnum>[
  _$vendorAccountDeletionPreviewConfirmationPhraseEnum_DELETE,
]);

Serializer<VendorAccountDeletionPreviewConfirmationPhraseEnum>
    _$vendorAccountDeletionPreviewConfirmationPhraseEnumSerializer =
    _$VendorAccountDeletionPreviewConfirmationPhraseEnumSerializer();

class _$VendorAccountDeletionPreviewConfirmationPhraseEnumSerializer
    implements
        PrimitiveSerializer<
            VendorAccountDeletionPreviewConfirmationPhraseEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELETE': 'DELETE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELETE': 'DELETE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VendorAccountDeletionPreviewConfirmationPhraseEnum
  ];
  @override
  final String wireName = 'VendorAccountDeletionPreviewConfirmationPhraseEnum';

  @override
  Object serialize(Serializers serializers,
          VendorAccountDeletionPreviewConfirmationPhraseEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorAccountDeletionPreviewConfirmationPhraseEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorAccountDeletionPreviewConfirmationPhraseEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorAccountDeletionPreview extends VendorAccountDeletionPreview {
  @override
  final bool canDelete;
  @override
  final VendorAccountDeletionBlockers blockers;
  @override
  final BuiltList<VendorAccountRetainedRecord> retainedRecords;
  @override
  final VendorAccountDeletionPreviewConfirmationPhraseEnum confirmationPhrase;

  factory _$VendorAccountDeletionPreview(
          [void Function(VendorAccountDeletionPreviewBuilder)? updates]) =>
      (VendorAccountDeletionPreviewBuilder()..update(updates))._build();

  _$VendorAccountDeletionPreview._(
      {required this.canDelete,
      required this.blockers,
      required this.retainedRecords,
      required this.confirmationPhrase})
      : super._();
  @override
  VendorAccountDeletionPreview rebuild(
          void Function(VendorAccountDeletionPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorAccountDeletionPreviewBuilder toBuilder() =>
      VendorAccountDeletionPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorAccountDeletionPreview &&
        canDelete == other.canDelete &&
        blockers == other.blockers &&
        retainedRecords == other.retainedRecords &&
        confirmationPhrase == other.confirmationPhrase;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canDelete.hashCode);
    _$hash = $jc(_$hash, blockers.hashCode);
    _$hash = $jc(_$hash, retainedRecords.hashCode);
    _$hash = $jc(_$hash, confirmationPhrase.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorAccountDeletionPreview')
          ..add('canDelete', canDelete)
          ..add('blockers', blockers)
          ..add('retainedRecords', retainedRecords)
          ..add('confirmationPhrase', confirmationPhrase))
        .toString();
  }
}

class VendorAccountDeletionPreviewBuilder
    implements
        Builder<VendorAccountDeletionPreview,
            VendorAccountDeletionPreviewBuilder> {
  _$VendorAccountDeletionPreview? _$v;

  bool? _canDelete;
  bool? get canDelete => _$this._canDelete;
  set canDelete(bool? canDelete) => _$this._canDelete = canDelete;

  VendorAccountDeletionBlockersBuilder? _blockers;
  VendorAccountDeletionBlockersBuilder get blockers =>
      _$this._blockers ??= VendorAccountDeletionBlockersBuilder();
  set blockers(VendorAccountDeletionBlockersBuilder? blockers) =>
      _$this._blockers = blockers;

  ListBuilder<VendorAccountRetainedRecord>? _retainedRecords;
  ListBuilder<VendorAccountRetainedRecord> get retainedRecords =>
      _$this._retainedRecords ??= ListBuilder<VendorAccountRetainedRecord>();
  set retainedRecords(
          ListBuilder<VendorAccountRetainedRecord>? retainedRecords) =>
      _$this._retainedRecords = retainedRecords;

  VendorAccountDeletionPreviewConfirmationPhraseEnum? _confirmationPhrase;
  VendorAccountDeletionPreviewConfirmationPhraseEnum? get confirmationPhrase =>
      _$this._confirmationPhrase;
  set confirmationPhrase(
          VendorAccountDeletionPreviewConfirmationPhraseEnum?
              confirmationPhrase) =>
      _$this._confirmationPhrase = confirmationPhrase;

  VendorAccountDeletionPreviewBuilder() {
    VendorAccountDeletionPreview._defaults(this);
  }

  VendorAccountDeletionPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canDelete = $v.canDelete;
      _blockers = $v.blockers.toBuilder();
      _retainedRecords = $v.retainedRecords.toBuilder();
      _confirmationPhrase = $v.confirmationPhrase;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorAccountDeletionPreview other) {
    _$v = other as _$VendorAccountDeletionPreview;
  }

  @override
  void update(void Function(VendorAccountDeletionPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorAccountDeletionPreview build() => _build();

  _$VendorAccountDeletionPreview _build() {
    _$VendorAccountDeletionPreview _$result;
    try {
      _$result = _$v ??
          _$VendorAccountDeletionPreview._(
            canDelete: BuiltValueNullFieldError.checkNotNull(
                canDelete, r'VendorAccountDeletionPreview', 'canDelete'),
            blockers: blockers.build(),
            retainedRecords: retainedRecords.build(),
            confirmationPhrase: BuiltValueNullFieldError.checkNotNull(
                confirmationPhrase,
                r'VendorAccountDeletionPreview',
                'confirmationPhrase'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockers';
        blockers.build();
        _$failedField = 'retainedRecords';
        retainedRecords.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorAccountDeletionPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
