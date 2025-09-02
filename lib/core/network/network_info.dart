abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // For now, we'll assume network is always available
    // In a real app, you'd use connectivity_plus package
    return true;
  }
}
