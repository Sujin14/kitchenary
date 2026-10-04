import 'package:flutter/material.dart';
import 'package:kitchenary/models/legal_document.dart';
import 'package:kitchenary/views/widgets/legal/legal_document_view.dart';

/// Shows one legal document (Privacy Policy, Terms of Use or About).
class LegalScreen extends StatelessWidget {
  const LegalScreen({required this.document, super.key});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(document.title)),
      body: SafeArea(child: LegalDocumentView(document: document)),
    );
  }
}
