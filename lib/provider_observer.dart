import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookShelfProviderObserver implements ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    log('didAddProvider: ${provider.name}');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    log('didDisposeProvider: ${provider.name}');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log('didUpdateProvider: ${provider.name}');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    log('providerDidFail: ${provider.name}, error: $error, stackTrace: $stackTrace');
  }
}
