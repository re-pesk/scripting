[Grįžti &#x2BA2;](../readme.md "Grįžti")

# [TypeScript <sup>&#x2B67;</sup>](https://www.typescriptlang.org/)

## Vadovai

* [TypeScript Handbook <sup>&#x2B67;</sup>](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes.html)
* [TypeScript Deep Dive <sup>&#x2B67;</sup>](https://basarat.gitbook.io/typescript/)

## Diegimas

TypeScriptas vykdomas tiesiogiai *Bun* arba *Deno* aplinkose arba sukompiliuotas į Javascriptą.

Apie Bun diegimą [diegimą <sup>&#x2B67;</sup>](../../install/proglangs/bun/bun_readme.md)
Apie Deno [diegimą <sup>&#x2B67;</sup>](../../install/proglangs/deno/deno_readme.md)

## Paleistis

```bash
deno run --allow-run --allow-env deno_sys-upgrade-deno.mts
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S deno run --allow-run --allow-env
```

arba

```bash
///usr/bin/env -S deno run --allow-run --allow-env "$0" "$@"; exit $?
```

## Kompiliavimas

```bash
deno compile --allow-run --allow-env --output deno_sys-upgrade.bin deno_sys-upgrade.mts
./deno_sys-upgrade.bin
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./deno_sys-upgrade.mts "sys-upgrade")
