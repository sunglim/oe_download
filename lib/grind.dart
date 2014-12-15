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
  task('set_m14tv_atsc', set_m14tv_atsc);
  task('set_m14tv_dvb', set_m14tv_dvb);
  task('set_h15_atsc', set_h15_atsc);
  task('set_h15_dvb', set_h15_dvb);
  task('set_lm15u_atsc', set_lm15u_atsc);
  task('set_lm15u_dvb', set_lm15u_dvb);

  task('set_version', set_version);
  
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

class BroadcastType {
  final _value;
  const BroadcastType._internal(this._value);
  String toString() => '$_value';
  
  static const ATSC = const Chips._internal('atsc');
  static const DVB = const Chips._internal('dvb');
  static const ARIB = const Chips._internal('arib');
}

final String SNAPSHOT_URL = 'http://webos-ci.lge.com/download/starfish/';
String _deploy_version = '';

// |chipName| should be one of Chips._
Future<String> _getLatestVersion(String chipName) {
  return http.get("${SNAPSHOT_URL}starfish-beehive4tv-official-${chipName}/")
      .then((response) {
    dom.Document document = parse(response.body);     
    List<dom.Element> atags = document.querySelectorAll('a');
    return atags.last.nodes.first.toString().replaceFirst(new RegExp(r'/'),'').replaceAll(new RegExp(r'"'), '');
  });
}

// |chipName| should be one of Chips._
// type = {atsc, dvb, arib}
Future<String> _getTarUrl(String chipName, String version, String type) {
  var url = "${SNAPSHOT_URL}starfish-beehive4tv-official-${chipName}/${version}/${chipName}/starfish-${type}-nfs/";
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

Future _deploy_latest_image(String deployDir, String chipName, String type, GrinderContext context) {
  return _getLatestVersion(chipName).then((versionString) {
    if (_deploy_version.isNotEmpty) versionString = _deploy_version;
    return _getTarUrl(chipName, versionString, type).then((epkurl) {
      new Directory(deployDir).createSync(recursive: true);
      return runProcessAsync(context, 'wget', arguments: [epkurl], workingDirectory: deployDir).then((_) {
        _runBashCommandSync(context, 'tar xvf *', cwd: deployDir);
        String source = new File('tools/deploy_hybridtv.sh').readAsStringSync();;
        source = source.replaceFirst(new RegExp('{chip}'), chipName)
                       .replaceAll(new RegExp('{type}'), type);
        new File('${deployDir}/ex.sh').writeAsStringSync(source);
        _runBashCommandSync(context, 'chmod 777 ex.sh', cwd: deployDir);
        new File('tools/brow.sh').copySync('${deployDir}/brow.sh');
      });
    });
  });
}

// Download atsc tarball and extract to ./m14tv
Future set_m14tv_atsc(GrinderContext context) {
  final String DEPLOY_DIR = "m14tv_atsc";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _deploy_latest_image(DEPLOY_DIR, Chips.M14.toString(),
                              BroadcastType.ATSC.toString(), context);
}

Future set_m14tv_dvb(GrinderContext context) {
  final String DEPLOY_DIR = "m14tv_dvb";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _deploy_latest_image(DEPLOY_DIR, Chips.M14.toString(),
                              BroadcastType.DVB.toString(), context);
}

Future set_h15_atsc(GrinderContext context) {
  final String DEPLOY_DIR = "h15_atsc";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _deploy_latest_image(DEPLOY_DIR, Chips.H15.toString(),
                              BroadcastType.ATSC.toString(), context);
}

Future set_h15_dvb(GrinderContext context) {
  final String DEPLOY_DIR = "h15_dvb";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _deploy_latest_image(DEPLOY_DIR, Chips.H15.toString(),
                              BroadcastType.DVB.toString(), context);
}

Future set_lm15u_atsc(GrinderContext context) {
  final String DEPLOY_DIR = "lm15u_atsc";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _deploy_latest_image(DEPLOY_DIR, Chips.LM15U.toString(),
                              BroadcastType.ATSC.toString(), context);
}

Future set_lm15u_dvb(GrinderContext context) {
  final String DEPLOY_DIR = "lm15u_dvb";
  deleteEntity(getDir(DEPLOY_DIR), context);
  return _deploy_latest_image(DEPLOY_DIR, Chips.LM15U.toString(),
                              BroadcastType.DVB.toString(), context);
}

void set_version(GrinderContext context) {
  print('Enter version : ');
  _deploy_version = stdin.readLineSync().trim();
}
