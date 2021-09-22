import 'dart:io';

import 'package:process_run/shell.dart';

extension AdvShell on Shell {
  Future<ProcessResult> singleRun(String script) async {
    final results = await this.run(script);
    return results.first;
  }
}
