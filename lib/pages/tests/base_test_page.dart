
import 'package:itry/database/models/test_interface.dart';
import 'package:itry/services/notifications_service.dart';
import 'package:itry/services/settings_service.dart';
import 'package:itry/services/test_service_interface.dart';

class BaseTestPage<T extends TestServiceInterface, S extends TestInterface>{

  BaseTestPage(T testService){
    _testService = testService;
  }

  T _testService;

  void commitResult(S result){
    SettingsService().getTestTimeBlocking().then((value) async {
      if (value) {
        if(await _testService.isActive(result.date)){
          _testService.insert(result);
          NotificationsService().scheduleTestNotification(result.getTestInterval());
        }
      } else {
        _testService.insert(result);
      }
    });
  }
}