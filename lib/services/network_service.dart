class NetworkService {
  Future<bool> isConnected() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<bool> connectionStatus() async* {
    yield true;
  }
}
