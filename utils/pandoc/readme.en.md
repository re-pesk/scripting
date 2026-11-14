[\[&nbsp;&uarr;&nbsp;\]](../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# Using the Pandoc Converter

## Usage

Arguments

```bash
./pandoc-bun.mjs --opt=input-format/output-format filename-without-extension
```

Example:

```bash
./pandoc-bun.mjs --opt=markdown/asciidoc readme
```

Input and output formats

| Name | File extension | Default extensions |
| -- | -- | :--: |
| asciidoc | adoc | - |
| context | ctex | - |
| djot | dj | - |
| docx | docx | - |
| haddock | hie | - |
| html | html | - |
| ipynb | ipynb | - |
| jats | jats | - |
| json | json | - |
| latex | tex | - |
| markdown | md | +abbreviations+emoji+mark |
| muse | muse | - |
| native | hs | - |
| pdf | pdf | - |
| odt | odt | - |
| rst | rst | - |
| texinfo | txi | - |
| textile | textile | - |
| typst | typ | - |
