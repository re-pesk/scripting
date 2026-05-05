[Grįžti &#x2BA2;](../readme.md "Grįžti")

# [JavaScript <sup>&#x2B67;</sup>](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

## Vadovai

* [Learn web development <sup>&#x2B67;</sup>](https://developer.mozilla.org/en-US/docs/Learn)
* [The Modern JavaScript Tutorial <sup>&#x2B67;</sup>](https://javascript.info/)

## Vykdymas

JavaScript vykdomas *Bun*, *Deno* arba *Node* aplinkoje.

### Diegimas

Apie Bun diegimą [žiūrėti <sup>&#x2B67;</sup>](../../install/proglangs/bun/bun_readme.md).
Apie Deno diegimą [žiūrėti <sup>&#x2B67;</sup>](../../install/proglangs/deno/deno_readme.md).
Apie Node diegimą [žiūrėti <sup>&#x2B67;</sup>](../../install/proglangs/node/node_readme.md).

### Paleistis

* Bun

  ```bash
  bun run bun_sys-upgrade.mjs
  ```

* Deno

  ```bash
  deno run --allow-run --allow-env deno_sys-upgrade-deno.mjs
  ```

* Node

  ```bash
  node node_sys-upgrade.mjs
  ```

### Vykdymo instrukcija (shebang)

* Bun

  ```bash
  #!/usr/bin/env -S bun run
  # arba
  ///usr/bin/env -S bun run "$0" "$@"; exit $?
  ```

* Deno

  ```bash
  #!/usr/bin/env -S deno run --allow-run --allow-env
  #arba
  ///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?
  ```

* Node

  ```bash
  #!/usr/bin/env -S node
  # arba
  ///usr/bin/env -S node "$0" "$@"; exit $?
  ```

### Kompiliavimas

* Deno

  ```bash
  deno compile --allow-run --allow-env --output deno_sys-upgrade.bin deno_sys-upgrade.mjs
  ./deno_sys-upgrade.bin
  ```

## Skriptai

* [bun_sys-upgrade <sup>&#x2B67;</sup>](./bun_sys-upgrade.mjs "sys-upgrade")
* [deno_sys-upgrade <sup>&#x2B67;</sup>](./deno_sys-upgrade.mjs "sys-upgrade")
* [node_sys-upgrade <sup>&#x2B67;</sup>](./node_sys-upgrade.mjs "sys-upgrade")
