[\[&nbsp;&uarr;&nbsp;\]](../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# Helper Functions `split-string.sh`

## split_string

Splits a string by a given delimiter and returns its parts joined by the delimiter specified in `join_with`.

Arguments:

```text
(-d=*|-delim=*|--delim=*)
: string used to split the text

(-j=*|-join_with=*|--join_with=*)
: string used to join the text parts (default value is `""`)

positional argument
: text to be processed
```

## normalize_indexes

Splits a set of comma-separated indexes. Negative indexes, which indicate the offset from one plus the maximum possible index, are converted into positive ones. The indexes are returned joined by the specified delimiter.

Arguments:

```text
(-m=*|-max=*|--max=*)
: maximum possible index value.

(-j=*|-join_with=*|--join_with=*)
: delimiter for the returned string of indexes (default is `" "`)

positional argument
: string of comma-separated indexes to be processed
```

## filter_text

Splits a string by a given delimiter, selects the parts with the specified indexes, and returns them joined by the specified characters.

Arguments:

```text
(-d=*|-delim=*|--delim=*)
: string used to split the text; if empty, the text is split character by character

(-i=*|-incl=*|--incl=*)
: comma-separated indexes of the text parts to be returned

(-e=*|-excl=*|--excl=*)
: comma-separated indexes of the text parts to be excluded

(-j=*|-join_with=*|--join_with=*)
: string used to join the text parts (default value is `""`)

positional argument
: text to be processed
```
