import 'dart:async';

import 'package:grinder/grinder.dart';
import 'package:http/http.dart' as http;
import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart' as dom;

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

// |chipName| should be one of Chips._
Future<String> _getLatestVersion(String chipName) {
  return http.get("http://webos-ci.lge.com/download/starfish/starfish-beehive4tv-official-" + chipName + "/")
      .then((response) {
    dom.Document document = parse(response.body);     
    List<dom.Element> atags = document.querySelectorAll('a');
    return atags.last.nodes.first.toString().replaceFirst(new RegExp(r'/'),'');
  });
}

void _getTarUrl(String chipName, String version) {
  //http://webos-ci.lge.com/download/starfish/starfish-beehive4tv-official-m14tv/121/m14tv/starfish-atsc-nfs/
  /*<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
  <html>
   <head>
    <title>Index of /download/starfish/starfish-beehive4tv-official-m14tv/121/m14tv/starfish-atsc-nfs</title>
   </head>
   <body>
  <h1>Index of /download/starfish/starfish-beehive4tv-official-m14tv/121/m14tv/starfish-atsc-nfs</h1>
  <table><tr><th><img src="/icons/blank.gif" alt="[ICO]"></th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th><a href="?C=D;O=A">Description</a></th></tr><tr><th colspan="5"><hr></th></tr>
  <tr><td valign="top"><img src="/icons/back.gif" alt="[DIR]"></td><td><a href="/download/starfish/starfish-beehive4tv-official-m14tv/121/m14tv/">Parent Directory</a></td><td>&nbsp;</td><td align="right">  - </td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="bom.txt">bom.txt</a></td><td align="right">06-Nov-2014 15:29  </td><td align="right">104K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="build-id.txt">build-id.txt</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right">1.1K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="files-in-image.txt">files-in-image.txt</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right">6.8M</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="image-info.txt">image-info.txt</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right">1.2K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="installed-package-file-sizes.txt">installed-package-file-sizes.txt</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right"> 18K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="installed-package-sizes.txt">installed-package-sizes.txt</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right"> 18K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="installed-packages.txt">installed-packages.txt</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right"> 30K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/compressed.gif" alt="[   ]"></td><td><a href="starfish-atsc-nfs-m14tv-beehive4tv-121-02.01.21.rootfs.tar.gz">starfish-atsc-nfs-m14tv-beehive4tv-121-02.01.21.rootfs.tar.gz</a></td><td align="right">06-Nov-2014 17:17  </td><td align="right">647M</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/unknown.gif" alt="[   ]"></td><td><a href="starfish-atsc-nfs-m14tv-beehive4tv-121-02.01.21.rootfs.tar.gz.md5">starfish-atsc-nfs-m14tv-beehive4tv-121-02.01.21.rootfs.tar.gz.md5</a></td><td align="right">06-Nov-2014 17:26  </td><td align="right"> 96 </td><td>&nbsp;</td></tr>
  <tr><th colspan="5"><hr></th></tr>
  </table>
  <address>Apache/2.2.22 (Ubuntu) Server at webos-ci.lge.com Port 80</address>
  </body></html>
*/
  return http.get(url)  
}

void set_m14tv(GrinderContext context) {
  _getLatestVersion(Chips.M14.toString()).then(print);
}

class OeType {
}

