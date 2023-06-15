import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getNetworkStatusProvider = StreamProvider(
    (ref) => NetworkStatusService().networkStatusController.stream);

final networkStatusController =
    StreamProvider<NetworkStatus>((ref) => NetworkStatusService().networkStatusController.stream);

enum NetworkStatus {
  offline('offile'),
  online('online');

  final String type;
  const NetworkStatus(this.type);
}

class NetworkStatusService {
  late StreamController<NetworkStatus> networkStatusController;

  NetworkStatusService() {
    networkStatusController = StreamController<NetworkStatus>.broadcast();
    Connectivity().onConnectivityChanged.listen((status) {
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  NetworkStatus _getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile ||
            status == ConnectivityResult.wifi
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }
}
