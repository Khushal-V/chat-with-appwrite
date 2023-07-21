import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc() : super(ConnectionInitial()) {
    on<ConnectionEvent>((event, emit) {});
    on<ListenInternetConnectionEvent>(_listenInternetConnection);
    on<ConnectionRestoreEvent>((event, emit) => emit(ConnectionRestoreState()));
    on<ConnectionGoneEvent>((event, emit) => emit(ConnectionGoneState()));
  }

  _listenInternetConnection(
      ListenInternetConnectionEvent event, Emitter<ConnectionState> emit) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        add(ConnectionRestoreEvent());
      } else {
        add(ConnectionGoneEvent());
      }
    });
  }
}
