[\[&nbsp;&uarr;&nbsp;\]](../readme.en.md "Go toward the start page")

*[Lithuanian](readme.lt.md)*

# Script Loaders

## PHP Script Loader

On Linux systems, standard PHP files can be made executable by using a shebang:

```bash
#!/usr/bin/env -S php
```

The loader script *php-script.sh* allows executing PHP code files without the `<?php` tag. If *php-script.sh* is located in a directory included in the system `PATH`, add the following shebang to the file:

```bash
#!/usr/bin/env -S php-script.sh
```

This shebang allows executing PHP code files without the `<?php` tag in the same directory where *php-script.sh* is located:

```bash
#!./php-script.sh
```

### Updated: Running PHP Files Without a Script Loader

PHP files can be executed with the following line at the beginning of the file:

```bash
///usr/bin/env php "\$0" -- "\(@"; exit "\)?"
```

PHP code files without the PHP tag and without a script loader can be executed with the following line at the very beginning of the file:

```bash
///usr/bin/env php -r "\$(tail -n +1 "\$0")" -- "\(@"; exit "\)?"
```

## Odin Script Loader

This shebang allows executing Odin code files in the same directory where *odin-script.sh* is located:

```bash
#!./odin-script.sh
```

### Updated: Running Odin Files Without a Script Loader

Odin code files without a script loader can be executed with the following line at the very beginning of the file:

```bash
///usr/bin/env -S odin run "0" -file -out:"{0%.*}.bin" -- "\(@"; exit \)?
```
