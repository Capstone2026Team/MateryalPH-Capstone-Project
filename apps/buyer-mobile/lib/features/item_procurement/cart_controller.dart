import 'package:flutter/foundation.dart';

import '../map_discovery/discovery_models.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

/// Cart state. Every change sends the cart lock_version; a 409 reloads the latest cart and keeps
/// the Buyer's message visible instead of overwriting another device's edit. Nothing here reserves
/// stock or submits an order.
class CartController extends ChangeNotifier {
  CartController({required ProcurementRepository repository})
    : _repository = repository;

  final ProcurementRepository _repository;

  CartView? cart;
  LoadPhase phase = LoadPhase.loading;
  DiscoveryFailure? failure;

  /// A non-blocking message about the last action (for example a version conflict).
  String? notice;
  String? busyLineId;
  bool busy = false;

  CheckoutPreviewView? preview;
  DiscoveryFailure? previewFailure;
  bool previewLoading = false;
  int _previewSequence = 0;
  bool _disposed = false;

  int get lineCount => cart?.lineCount ?? 0;

  Future<void> load() async {
    phase = cart == null ? LoadPhase.loading : phase;
    failure = null;
    _notify();
    try {
      cart = await _repository.cart();
      phase = LoadPhase.ready;
    } on DiscoveryFailure catch (error) {
      failure = error;
      phase = cart == null ? LoadPhase.failed : LoadPhase.ready;
    }
    _notify();
  }

  void replace(CartView next) {
    cart = next;
    phase = LoadPhase.ready;
    _notify();
  }

  Future<void> changeQuantity(CartLineView line, String quantity) => _mutate(
    line.id,
    (version) => _repository.updateLine(
      line,
      cartLockVersion: version,
      quantity: quantity,
    ),
  );

  Future<void> acceptCurrentPrice(CartLineView line) => _mutate(
    line.id,
    (version) => _repository.updateLine(
      line,
      cartLockVersion: version,
      acceptCurrentPrice: true,
    ),
  );

  Future<void> saveForLater(CartLineView line, {required bool saved}) =>
      _mutate(
        line.id,
        (version) => _repository.updateLine(
          line,
          cartLockVersion: version,
          savedForLater: saved,
        ),
      );

  Future<void> remove(CartLineView line) => _mutate(
    line.id,
    (version) => _repository.removeLine(line, cartLockVersion: version),
  );

  Future<void> setFulfillment(String vendorId, String method) => _mutate(
    null,
    (version) =>
        _repository.setFulfillment(vendorId, method, cartLockVersion: version),
  );

  /// Returns field errors from a 422 so the destination form can show them next to each field.
  Future<Map<String, Object?>?> setDestination({
    required String? intendedLocationId,
    required String heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  }) async {
    final current = cart;
    if (current == null) return null;
    busy = true;
    notice = null;
    _notify();
    try {
      cart = await _repository.setDestination(
        cartLockVersion: current.lockVersion,
        intendedLocationId: intendedLocationId,
        heavyVehicleRestriction: heavyVehicleRestriction,
        alternateDropOffLocationId: alternateDropOffLocationId,
        accessInstructions: accessInstructions,
      );
      return null;
    } on DiscoveryFailure catch (error) {
      if (error.kind == DiscoveryFailureKind.validation) {
        notice = error.message;
        return error.details.isEmpty ? {'form': error.message} : error.details;
      }
      await _handle(error);
      return {'form': error.message};
    } finally {
      busy = false;
      _notify();
    }
  }

  /// A preview is valid only for the request that produced it; older replies are discarded.
  Future<void> loadPreview() async {
    final sequence = ++_previewSequence;
    previewLoading = true;
    previewFailure = null;
    _notify();
    try {
      final result = await _repository.checkoutPreview(
        requestVersion: 'preview-$sequence',
      );
      if (_disposed ||
          sequence != _previewSequence ||
          result.requestVersion != 'preview-$sequence') {
        return;
      }
      preview = result;
    } on DiscoveryFailure catch (error) {
      if (_disposed || sequence != _previewSequence) return;
      previewFailure = error;
    } finally {
      if (!_disposed && sequence == _previewSequence) {
        previewLoading = false;
        _notify();
      }
    }
  }

  Future<void> _mutate(
    String? lineId,
    Future<CartView> Function(int version) operation,
  ) async {
    final current = cart;
    if (current == null || busy) return;
    busy = true;
    busyLineId = lineId;
    notice = null;
    _notify();
    try {
      cart = await operation(current.lockVersion);
    } on DiscoveryFailure catch (error) {
      await _handle(error);
    } finally {
      busy = false;
      busyLineId = null;
      _notify();
    }
  }

  Future<void> _handle(DiscoveryFailure error) async {
    notice = error.message;
    if (error.kind == DiscoveryFailureKind.conflict ||
        error.kind == DiscoveryFailureKind.notFound) {
      try {
        cart = await _repository.cart();
      } on DiscoveryFailure catch (reload) {
        failure = reload;
      }
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
