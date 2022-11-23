import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
void main() {
  DataConnectionChecker dataConnectionChecker = MockDataConnectionChecker();
  NetworkInfo networkInfo = NetworkInfoImpl(dataConnectionChecker);
  
  group('is connected', () {
    test('should forward the call to DataConnectionChecker.hasConnection', () async {
      // arrange
      final hasConnectionFuture = Future.value(true);
      when(dataConnectionChecker.hasConnection).thenAnswer((_) => hasConnectionFuture);

      // act
      final actual = networkInfo.isConnected;

      // assert
      verify(dataConnectionChecker.hasConnection);
      expect(actual, hasConnectionFuture);

    });
  });
}