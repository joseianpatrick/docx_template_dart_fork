import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:docx_template/src/template.dart';
import 'package:test/test.dart';

void main() {
  test('generate word', () async {
    final fileGenerated = File('generated.docx');
    if (fileGenerated.existsSync()) {
      await fileGenerated.delete();
    }
    final f = File("template.docx");
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    final testFileContent = await File('test.jpg').readAsBytes();
    final test2FileContent = await File('test2.jpg').readAsBytes();

    final listNormal = ['Foo', 'Bar', 'Baz'];
    final listBold = ['ooF', 'raB', 'zaB'];

    final contentList = <Content>[];

    final b = listBold.iterator;
    for (var n in listNormal) {
      b.moveNext();

      final c = PlainContent("value")
        ..add(TextContent("normal", n))
        ..add(TextContent("bold", b.current));
      contentList.add(c);
    }

    Content c = Content();
    c
      ..add(HyperlinkContent(
        key: "link",
        text: "My new link",
        url: "https://www.youtube.com/",
      ))
      // ..add(TextContent("header", "Nice header"))
      // ..add(TextContent("footer", "Nice footer"))
      ..add(TextContent("docname", "Simple docname"))
      ..add(TextContent("passport", "Passport NE0323 4456673"))
      ..add(TableContent("table", [
        RowContent()
          ..add(TextContent("key1", "Paul"))
          ..add(TextContent("key2", "Viberg"))
          ..add(TextContent("key3", "Engineer")),
        //..add(ImageContent('img', testFileContent)),
        RowContent()
          ..add(TextContent("key1", "Alex"))
          ..add(TextContent("key2", "Houser"))
          ..add(TextContent("key3", "CEO & Founder"))
          ..add(ListContent("tablelist", [
            TextContent("value", "Mercedes-Benz C-Class S205"),
            TextContent("value", "Lexus LX 570")
          ]))
          ..add(ImageContent('img', testFileContent))
      ]))
      ..add(ListContent("list", [
        TextContent("value", "Engine")
          ..add(ListContent("listnested", contentList)),
        TextContent("value", "Gearbox"),
        TextContent("value", "Chassis")
      ]))
      ..add(ListContent("plainlist", [
        PlainContent("plainview")
          ..add(TableContent("table", [
            RowContent()
              ..add(TextContent("key1", "Paul"))
              ..add(TextContent("key2", "Viberg"))
              ..add(TextContent("key3", "Engineer")),
            RowContent()
              ..add(TextContent("key1", "Alex"))
              ..add(TextContent("key2", "Houser"))
              ..add(TextContent("key3", "CEO & Founder"))
              ..add(ListContent("tablelist", [
                TextContent("value", "Mercedes-Benz C-Class S205"),
                TextContent("value", "Lexus LX 570")
              ]))
          ])),
        PlainContent("plainview")
          ..add(TableContent("table", [
            RowContent()
              ..add(TextContent("key1", "Nathan"))
              ..add(TextContent("key2", "Anceaux"))
              ..add(TextContent("key3", "Music artist"))
              ..add(ListContent(
                  "tablelist", [TextContent("value", "Peugeot 508")])),
            RowContent()
              ..add(TextContent("key1", "Louis"))
              ..add(TextContent("key2", "Houplain"))
              ..add(TextContent("key3", "Music artist"))
              ..add(ListContent("tablelist", [
                TextContent("value", "Range Rover Velar"),
                TextContent("value", "Lada Vesta SW Sport")
              ]))
          ])),
      ]))
      ..add(ListContent("multilineList", [
        PlainContent("multilinePlain")
          ..add(TextContent('multilineText', 'line 1')),
        PlainContent("multilinePlain")
          ..add(TextContent('multilineText', 'line 2')),
        PlainContent("multilinePlain")
          ..add(TextContent('multilineText', 'line 3'))
      ]))
      ..add(TextContent('multilineText2', 'line 1\nline 2\n line 3'))
      ..add(ImageContent('logo', testFileContent))
      ..add(ImageContent('imgFirst', test2FileContent))
      ..add(ImageContent('img', testFileContent));
    final d = await docx.generate(c, imagePolicy: ImagePolicy.remove);
    if (d != null) await fileGenerated.writeAsBytes(d);
    expect(await fileGenerated.exists(), true);
  });

  test('generate dox test2', () async {
    final fileGenerated = File('generated2.docx');
    if (fileGenerated.existsSync()) {
      await fileGenerated.delete();
    }
    final f = File("test2.docx");
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    // Build comprehensive Content object for docx_template
    final content = Content();

    // --- Build table for work instructions ---
    final List<Map<String, String>> workInstructions = [
      {
        'title': 'Work Instruction 1',
        'id': '123456',
        'description':
            'Description of work instruction 1', // This might not exist in template
        'asset': 'Asset 1'
      },
      {
        'title': 'Work Instruction 2',
        'id': '789012',
        'description':
            'Description of work instruction 2', // This might not exist in template
        'asset': 'Asset 2'
      }
    ];

    final table = TableContent('table', []);
    for (int i = 0; i < workInstructions.length; i++) {
      final wi = workInstructions[i];
      final row = RowContent();

      // Add all fields - the system will handle missing tags gracefully by rendering empty content
      row.add(TextContent('title', wi['title'] ?? ''));
      row.add(TextContent('id', wi['id'] ?? ''));
      row.add(TextContent('description',
          wi['description'] ?? '')); // Will be handled gracefully if missing
      row.add(TextContent('asset', wi['asset'] ?? ''));

      print(
          'Row $i: title="${wi['title']}", id="${wi['id']}", description="${wi['description']}", asset="${wi['asset']}"');
      table.addRow(row);
    }

    print('Total rows added: ${table.rows.length}');

    // Add the table to content
    content.add(table);

    final d = await docx.generate(content,
        imagePolicy: ImagePolicy.remove, tagPolicy: TagPolicy.saveText);
    if (d != null) await fileGenerated.writeAsBytes(d);
    expect(await fileGenerated.exists(), true);
  });
}
