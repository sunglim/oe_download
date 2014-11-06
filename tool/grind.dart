import 'package:grinder/grinder.dart';
import 'package:http/http.dart' as http;

void main([List<String> args]) {
  task('set_m14tv', set_m14tv);

  startGrinder(args);
}

void set_m14tv(GrinderContext context) {
  http://webos-ci.lge.com/download/starfish/starfish-beehive4tv-official-m14tv/
  String PARENT_LINK = "http://webos-ci.lge.com/download/starfish/starfish-beehive4tv-official-m14tv/";
  http.post(PARENT_LINK)
	  .then((response) {
			  print("Response status: ${response.statusCode}");
			  print("Response body: ${response.body}");
			  });
  print('test');
}

class OeType {
}

