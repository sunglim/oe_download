// Sungguk Lim all rights reserved.

import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:grinder/grinder_files.dart';
import 'package:grinder/grinder_tools.dart';
import 'package:html5lib/dom.dart' as dom;
import 'package:html5lib/parser.dart' show parse;
import 'package:http/http.dart' as http;

void main([List<String> args]) {
  task('set_m14tv', set_m14tv);
  
  startGrinder(args);
}

class Chips {
  final _value;
  const Chips._internal(this._value);
  String toString() => '$_value';
  
  static const M14 = const Chips._internal('m14tv');
  static const H15 = const Chips._internal('h15');
  static const LM15U = const Chips._internal('lm15u');
}

String SNAPSHOT_URL = "http://webos-ci.lge.com/download/starfish/";

// |chipName| should be one of Chips._
Future<String> _getLatestVersion(String chipName) {
  return http.get(SNAPSHOT_URL + "starfish-beehive4tv-official-" + chipName + "/")
      .then((response) {
    dom.Document document = parse(response.body);     
    List<dom.Element> atags = document.querySelectorAll('a');
    return atags.last.nodes.first.toString().replaceFirst(new RegExp(r'/'),'').replaceAll(new RegExp(r'"'), '');
  });
}

// |chipName| should be one of Chips._
// type = {atsc, dvb, arib}
Future<String> _getTarUrl(String chipName, String version, String type) {
  var url = SNAPSHOT_URL + "starfish-beehive4tv-official-" + chipName + "/" + version + "/" + chipName + "/starfish-" + type + "-nfs/";
  return http.get(url).then((response) {
    dom.Document document = parse(response.body);
    var epkurl = "";
    document.querySelectorAll('a').forEach((elem){
      var href = elem.attributes['href']; 
      if (href.contains(new RegExp('tar.gz')) && !href.contains(new RegExp('md5'))) {
        epkurl = url + href;
      }
    });
    return epkurl;
  });
}

void _runBashCommandSync(GrinderContext context, String command, {String cwd}) {
  context.log(command);
  ProcessResult result =
    Process.runSync('/bin/bash', ['-c', command], workingDirectory: cwd);
  if (result.stdout.isNotEmpty) {
    context.log(result.stdout);
  }
  if (result.stderr.isNotEmpty) {
    context.log(result.stderr);
  }
  if (result.exitCode > 0) {
    context.fail("exit code ${result.exitCode}");
  }
}

// Download tarball and extract to ./m14tv
Future set_m14tv(GrinderContext context) {
  String DEPLOY_DIR = "m14tv";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _getLatestVersion(Chips.M14.toString()).then((versionString) {
    return _getTarUrl(Chips.M14.toString(), versionString, 'atsc').then((epkurl) {
      new Directory(DEPLOY_DIR).createSync(recursive: true);
      return runProcessAsync(context, 'wget', arguments: [epkurl], workingDirectory: DEPLOY_DIR).then((_) {
        _runBashCommandSync(context, 'tar xvf *', cwd: DEPLOY_DIR);
      });
    });
  });
}
