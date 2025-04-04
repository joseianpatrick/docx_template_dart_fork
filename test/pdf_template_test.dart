import 'package:docx_template/docx_template.dart';
import 'package:docx_template/src/pdf_template.dart';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Test de génération de PDF', () async {
    // Lire le fichier template.docx
    final templateBytes = await File('template.docx').readAsBytes();

    // Créer le template DOCX
    final docxTemplate = await DocxTemplate.fromBytes(templateBytes);

    // Créer le template PDF
    final pdfTemplate = PdfTemplate(docxTemplate);

    // Générer le PDF
    final pdfBytes = await pdfTemplate.generate();

    // Vérifier que le PDF a été généré
    expect(pdfBytes, isNotNull);
    expect(pdfBytes.length, greaterThan(0));

    // Sauvegarder le PDF pour inspection manuelle
    final file = File('test_output.pdf');
    await file.writeAsBytes(pdfBytes);
    print('PDF généré et sauvegardé dans : ${file.absolute.path}');
  });
}
