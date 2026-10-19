// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_buyer_profile_ratings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryBuyerProfileRatings extends DirectoryBuyerProfileRatings {
  @override
  final DirectoryBuyerProfileRatingsReceived received;
  @override
  final DirectoryBuyerProfileRatingsWritten written;

  factory _$DirectoryBuyerProfileRatings(
          [void Function(DirectoryBuyerProfileRatingsBuilder)? updates]) =>
      (DirectoryBuyerProfileRatingsBuilder()..update(updates))._build();

  _$DirectoryBuyerProfileRatings._(
      {required this.received, required this.written})
      : super._();
  @override
  DirectoryBuyerProfileRatings rebuild(
          void Function(DirectoryBuyerProfileRatingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryBuyerProfileRatingsBuilder toBuilder() =>
      DirectoryBuyerProfileRatingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryBuyerProfileRatings &&
        received == other.received &&
        written == other.written;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, written.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryBuyerProfileRatings')
          ..add('received', received)
          ..add('written', written))
        .toString();
  }
}

class DirectoryBuyerProfileRatingsBuilder
    implements
        Builder<DirectoryBuyerProfileRatings,
            DirectoryBuyerProfileRatingsBuilder> {
  _$DirectoryBuyerProfileRatings? _$v;

  DirectoryBuyerProfileRatingsReceivedBuilder? _received;
  DirectoryBuyerProfileRatingsReceivedBuilder get received =>
      _$this._received ??= DirectoryBuyerProfileRatingsReceivedBuilder();
  set received(DirectoryBuyerProfileRatingsReceivedBuilder? received) =>
      _$this._received = received;

  DirectoryBuyerProfileRatingsWrittenBuilder? _written;
  DirectoryBuyerProfileRatingsWrittenBuilder get written =>
      _$this._written ??= DirectoryBuyerProfileRatingsWrittenBuilder();
  set written(DirectoryBuyerProfileRatingsWrittenBuilder? written) =>
      _$this._written = written;

  DirectoryBuyerProfileRatingsBuilder() {
    DirectoryBuyerProfileRatings._defaults(this);
  }

  DirectoryBuyerProfileRatingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received.toBuilder();
      _written = $v.written.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryBuyerProfileRatings other) {
    _$v = other as _$DirectoryBuyerProfileRatings;
  }

  @override
  void update(void Function(DirectoryBuyerProfileRatingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryBuyerProfileRatings build() => _build();

  _$DirectoryBuyerProfileRatings _build() {
    _$DirectoryBuyerProfileRatings _$result;
    try {
      _$result = _$v ??
          _$DirectoryBuyerProfileRatings._(
            received: received.build(),
            written: written.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'received';
        received.build();
        _$failedField = 'written';
        written.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryBuyerProfileRatings', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
