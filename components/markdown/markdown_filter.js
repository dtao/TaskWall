function MarkdownFilter() {
  return function(markdown) {
    return marked(markdown);
  };
}
