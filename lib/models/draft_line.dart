/// One editable text line (a method step) in the recipe editor.
class DraftLine {
  DraftLine(this.id, [this.text = '']);

  final int id;
  String text;
}

/// One editable ingredient row in the recipe editor.
class DraftIngredient {
  DraftIngredient(this.id, {this.name = '', this.measure = ''});

  final int id;
  String name;
  String measure;
}
