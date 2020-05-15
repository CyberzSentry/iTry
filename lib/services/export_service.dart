import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class ExportService {

  void ExportToXLSX() async {
    //var excel = Excel.createExcel();

    var directoryPath = await getDatabasesPath();

    final params = SaveFileDialogParams(
        sourceFilePath: path.join(directoryPath, "iTry.db"));
    final filePath = await FlutterFileDialog.saveFile(params: params);
    print(filePath);
  }
}
