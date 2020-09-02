class FormPageNumber {
  final int pageNumber;
  final int pageCount;
  final int propertyNumber;

  // pageNumber and pageCount are both 0-indexed. They are both used for
  //  showing progress in appbar, as well as ensuring the new fly form
  //  access correct matieral and attributes in the form template
  //  obtained from db and sent into form widgets as stream.
  //  Total number of pages is equal to length of list of materials +
  //  1 (for the page in which we gather general attribute data about fly,
  //  such as name, difficulty, etc).
  FormPageNumber(
      {this.pageNumber = 0, this.pageCount = 0, this.propertyNumber});
}
