import 'package:change_notifier_base/change_notifier_base.dart';

/// `BaseChangeNotifier<T, E>` where:
///
/// [T]: is the data type of the state, and
/// [E]: is the data type of the error
class CounterProvider extends BaseChangeNotifier<int, void> {
  Future<void> increment() async {
    await run(() async {
      await Future.delayed(const Duration(seconds: 2));
      data = (data ?? 0) + 1;
    });
  }
}
