import 'dart:io';

import 'package:process_run/shell.dart';

extension AdvShell on Shell {
  Future<ProcessResult> singleRun(String script, [Iterable<String> args = const []]) async {
    final results = await this.run('$script${args.isEmpty ? '' : ' ${args.join(' ')}'}');
    return results.first;
  }
}
