import 'package:equatable/equatable.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

var url = 'https://guspoliteh.ru/studentu/raspisanie-zanyatiy/';

class ContentList{
  ContentList({
    required this.status,
    required this.body,
});

  int status;
  List<String> body;
}


class FormPost {
  const FormPost({required this.date, required this.option});

  final DateTime date;
  final Option option;
}

class Option extends Equatable{
  String value;
  String name;
  Option({
    required this.value,
    required this.name,
  });

  @override
  String toString() => name;

  @override
  List<Object?> get props => [value, name];
}

class ContentGroup {
  int? status;
  List<Option> group = [];
  List<Option> teacher = [];
  ContentGroup({
    this.status,
    required this.group,
    required this.teacher,
  });
}

Future<ContentGroup> getListSchedules() async {
  http.Response response;
  try {
    response = await http.get(Uri.parse(url));
  }catch(e){
    return ContentGroup(
        status: 500,
        group: [],
        teacher: []
    );
  }
  List<Option> teacher = <Option>[];
  List<Option> group = <Option>[];

  if (response.statusCode == 200) {
    var document = parse(response.body);

    var contentTeacher = document.getElementById("sel_teacher");
    for (var element in contentTeacher!.children) {
      teacher.add(
        Option(
            value: element.attributes['value'].toString(),
            name: element.text
        )
      );
    }

    var contentGroup = document.getElementById("sel_group");
    for (var element in contentGroup!.children) {
      group.add(
          Option(
              value: element.attributes['value'].toString(),
              name: element.text
          )
      );
    }
  }
  return ContentGroup(
    status: response.statusCode,
    teacher: teacher,
    group: group,
  );
}


Future<ContentList> getSchedules(FormPost formPost, int modal) async {
  http.StreamedResponse response;
  try {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(url)
    )
        ..fields['id'] = formPost.option.value
        ..fields['date'] = '${formPost.date.year}-'
            '${formPost.date.month}-${formPost.date.day}'
        ..fields['modal$modal'] = 'true';
    response = await request.send();

  }catch(e){
    return ContentList(
        status: 500,
        body: [],
    );
  }

  String content = await response.stream.bytesToString();

  if ('нет данных' == content){
    return ContentList(
      status: 200,
      body: <String>[content],
    );
  }
  var document = parse(content);

  var rPanel = document.getElementsByClassName('rpanel');
  rPanel.removeRange(0, 2);

  
  // var rLarge = document.getElementsByClassName('rlarge');
  // var rTextMuted = document.getElementsByClassName('rtext-muted');
  // var rSmall = document.getElementsByClassName('rsmall');

  List<String> contentNew = [];

  for (var panel in rPanel) {
    for(var item in panel.children){
      contentNew.add(item.text);
    }
    contentNew.add('');
  }
  // for(int i = 0;i<4;i++){
  //   contentNew.add(rTextMuted[i].text);
  //   contentNew.add(rLarge[i].text);
  //   contentNew.add(rSmall[i].text);
  //   contentNew.add('');
  // }

  return ContentList(
    status: 200,
    body: contentNew,
  );
}
