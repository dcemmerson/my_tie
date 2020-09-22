class FormPageNumber {
  final int pageNumber;
  final int pageCount;
  final int propertyIndex;

  // Attributes are 0-indexed. pageCount is deprecated. pageNumber and pageCount
  //  are both used for accessing correct material/attribute and property in
  //  materials when user makes edits.
  //  Total number of pages is equal to length of list of materials +
  //  1 (for the page in which we gather general attribute data about fly,
  //  such as name, difficulty, etc).
  FormPageNumber({this.pageNumber = 0, this.pageCount = 0, this.propertyIndex});
}
