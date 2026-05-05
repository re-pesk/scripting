[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Zig [<sup>&#x2B67;</sup>](https://ziglang.org/)

## Diegimas Linuxe (Ubuntu 24.04)

[Žiūrėti](../../install/proglangs/zig/zig_readme.md "Diegimas")

## Paleistis

```bash
zig run --name zig_sys-upgrade.bin zig_sys-upgrade.zig
```

### Vykdymo instrukcija (shebang)

```bash
///usr/bin/env -S zig run "$0" -- "$@"; exit $?
```

## Kompiliavimas

```bash
zig build-exe -O ReleaseSmall -static --name zig_sys-upgrade.bin zig_sys-upgrade.zig && rm zig_sys-upgrade.bin.o
```

## Skriptai

* [sys-upgrade <sup>&#x2B67;</sup>](./zig_sys-upgrade.zig "sys-upgrade")
