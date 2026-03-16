[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Skriptinimas skirtingomis programavimo kalbomis (63)

Ubuntu paketų atnaujinimo skriptas skirtingomis programavimo kalbomis ar jų dialektais.

Tikslas - patikrinti, kaip skirtingos kalbos tinka rašyti operacijų sistemos valdymo skriptus.

Naudota operacinė sistema – Ubuntu 24.04

## Diegimas

Apie programavimo kalbų ir vykdymo aplinkų [diegimą <sup>&#x2B67;</sup>](../install/_proglangs/proglangs_readme.md "Diegimas")

## Tipinės apvalkalo scenarijų (Shell scripting) kalbos (7)

* [x] [Bash <sup>&#x2B67;</sup>](bash/sys-upgrade/bash_readme.md) (±)\
  (–) asociatyvieji masyvai netinka medžio tipo struktūroms\
  (+) labai paplitusi, daug informacijos
  * [x] [Brush <sup>&#x2B67;</sup>](brush/sys-upgrade/brush_readme.md) (–)\
    (+) greita ir saugi - parašyta su Rust\
    (+) suderinama su Bash
* [x] [Dash <sup>&#x2B67;</sup>](dash/sys-upgrade/dash_readme.md) (–)\
  (+) greita\
  (–) neturi asociatyviųjų masyvų\
  (–) daug kitų apribojimų
* [x] [Yash <sup>&#x2B67;</sup>](yash/sys-upgrade/yash_readme.md) (–)\
  (–) mažai informacijos\
  (–) neturi asociatyviųjų masyvų
* [x] [ksh <sup>&#x2B67;</sup>](kash/sys-upgrade/ksh_readme.md) (±)\
  (+) turi įterptinius asocijuotuosius masyvus\
  (–) trūksta parametrų išplėtimo (Parameter Expansion) galimybių
* [x] [Osh (Oils) <sup>&#x2B67;</sup>](oils/sys-upgrade/oils_readme.md) (–)\
  (–) mažai informacijos\
  (–) paini dokumentacija
* [x] [Zsh <sup>&#x2B67;</sup>](zsh/sys-upgrade/zsh_readme.md) (±)\
  (–) asociatyvieji masyvai netinka medžio tipo struktūroms\
  (+) pakankamai paplitusi, daug informacijos

## Alternatyvios apvalkalo scenarijų (Shell scripting) kalbos (9)

* [x] [Abs <sup>&#x2B67;</sup>](abs/sys-upgrade/abs_readme.md) (–)\
  (+) patogi kalba\
  (?) ~~nebevystoma?~~ atnaujinta 2025-04-27
* [x] [Elvish <sup>&#x2B67;</sup>](elvish/sys-upgrade/elvish_readme.md) (?)\
  (–) keista asocijuotųjų masyvų ir funkcijų sintaksė\
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [Fish <sup>&#x2B67;</sup>](fish/sys-upgrade/fish_readme.md) (–)\
  (–) neturi priemonių medžio tipo struktūroms\
  (–) nepatogi sintaksė
* [x] [Ysh (Oils) <sup>&#x2B67;</sup>](oils/sys-upgrade/oils_readme.md) (–)\
  (–) mažai informacijos\
  (–) paini dokumentacija
* [x] [Koi <sup>&#x2B67;</sup>](koi/sys-upgrade/koi_readme.md) (–)\
  (–) neužbaigta kalba\
  (–) trūksta reikalingų apvalkalo kalboms ypatybių
* [x] [Murex <sup>&#x2B67;</sup>](murex/sys-upgrade/murex_readme.md) (–)\
  (–) keista sintaksė
* [x] [Ngs <sup>&#x2B67;</sup>](ngs/sys-upgrade/ngs_readme.md) (?)\
  (–) keistai organizuotas darbas su klaidomis
  (?) ~~nebevystoma?~~ atnaujinta 2025-04-05
* [x] [Nushell <sup>&#x2B67;</sup>](nushell/sys-upgrade/nu_readme.md) (?)\
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [PowerShell <sup>&#x2B67;</sup>](powershell/sys-upgrade/pwsh_readme.md) (–)\
  (–) keista sintaksė\
  (–) kilmė iš Microsoft'o

## Intepretuojamos kalbos ir JIT kompiliatoriai (34)

### JavaVM (8)

Lėtai pasileidžia arba reikalingas kompiliavimas. Reikalinga Java JRE arba JDK

* [x] [Clojure <sup>&#x2B67;</sup>](clojure/sys-upgrade/clojure_readme.md) (–)\
  (&ensp;) Lispo sintaksė
* [x] [Ballerina <sup>&#x2B67;</sup>](ballerina/sys-upgrade/ballerina_readme.md) (–)\
  (–) ribotos išorinių komandų iškvietimo funkcijos\
  (–) sudėtingas klaidų apdrojimas\
  (–) skurdi dokumentacija\
  (–) mažai informacijos internete
* [X] [Groovy <sup>&#x2B67;</sup>](groovy/sys-upgrade/groovy_readme.md) (–)
* [x] [Java <sup>&#x2B67;</sup>](java/sys-upgrade/java_readme.md) (–)
* [x] [Kotlin <sup>&#x2B67;</sup>](kotlin/sys-upgrade/kotlin_readme.md) (–)
  3 kodo variantai:
  * [x] intepretuojamas,
  * [x] JVM,
  * [x] kompiliuojamas į mašininį kodą.
* [x] [Scala <sup>&#x2B67;</sup>](scala/sys-upgrade/scala_readme.md) (–)

### JavaScript'as ir TypeScript'as (4)

* [JavaScript'as <sup>&#x2B67;</sup>](js/sys-upgrade/js_readme.md) (+)
  (+) Daug informacijos internete
  * [x] Bun (+)
  * [x] Deno (±)
  * [x] Node (+)
* [TypeScript'as <sup>&#x2B67;</sup>](ts/sys-upgrade/ts_readme.md) (±)
  (+) Daug informacijos internete
  (+) Sparčiai populiarėja
  (–) Paprastai vykdomas ne tiesiogiai, bet po vertimo į JS
  * [x] Deno (+)
    (+) Vykdomas tiesiogiai, be vertimo į JS

### Kitos (22)

* [x] [Dart <sup>&#x2B67;</sup>](dart/sys-upgrade/dart_readme.md) (–)\
  (–) nepatogus darbas su išorinėmis komandomis
* [x] [Euphoria <sup>&#x2B67;</sup>](euphoria/sys-upgrade/euph_readme.md) (–)\
  (–) sudėtingas instaliavimas\
  (–) seniai nebuvo leidimų
  * [x] [Phix <sup>&#x2B67;</sup>](phix/sys-upgrade/phix_readme.md) - stipriai modifikuota Euforijos versija (–)\
    (–) nepavyko paleisti visų pavyzdžių
* [x] [Guile <sup>&#x2B67;</sup>](guile/sys-upgrade/guile_readme.md) (–)\
  (&ensp;) Lispo sintaksė\
  (–) sudėtinga susigaudyti dokumentacijoje\
  (–) mažai informacijos intenete
* [x] [Haxe <sup>&#x2B67;</sup>](haxe/sys-upgrade/haxe_readme.md) (–)\
  (–) pagrindinės klasė nepatogiai susieta su kodo failo pavadinimu\
  (–) reikalauja pagrindinės klasės
* [x] [Io <sup>&#x2B67;</sup>](io/sys-upgrade/io_readme.md) (±)\
  (+) maža, paprasta kalba\
  (&ensp;) Smaltalk'o sintaksė\
  (–) nebevystoma
* [x] [Janet <sup>&#x2B67;</sup>](janet/sys-upgrade/janet_readme.md) (?)\
  (&ensp;) Lispo sintaksė\
  (+) pozicionuojama kaip skriptinė kalba
* [x] [Julia <sup>&#x2B67;</sup>](julia/sys-upgrade/julia_readme.md) (±)\
  (&ensp;) Pythono pakaitalas moksliniams skaičiavimams
* [x] [Lua <sup>&#x2B67;</sup>](lua/sys-upgrade/lua_readme.md) (+)\
  (+) paprasta kalba
  * [x] [Hilbish <sup>&#x2B67;</sup>](hilbish/sys-upgrade/hilbish_readme.md) Apvalkalas (shell) Lua kalbos pagrindu (+)
  * [x] [Pluto <sup>&#x2B67;</sup>](pluto/sys-upgrade/pluto_readme.md) Lua kalbos supersetas su klasėmis (+)
* [x] [Miniscript <sup>&#x2B67;</sup>](miniscript/sys-upgrade/mscr_readme.md) (–)\
  (+) paprasta kalba\
  (–) menkos galimybės dirbti su išorinėmis komandomis\
  (–) mažai informacijos internete\
  (–) seniai nebuvo leidimų\
  (+) ruošiama nauja versija
* [x] [Onyx <sup>&#x2B67;</sup>](onyx/sys-upgrade/onyx_readme.md) - kalba, skirta kompiliuoti į Wasm (±)\
  (+) turi JIT kompiliatorių\
  (–) visiškai nauja kalba\
  (–) nėra dokumentacijos
* [x] [Perl <sup>&#x2B67;</sup>](perl/sys-upgrade/perl_readme.md) bendros paskirties Unix'o scenarijų kalba (–)\
  (–) nepatogi ir keista sintaksė\
  (+) daug informacijos ir pavyzdžių
* [x] [PHP <sup>&#x2B67;</sup>](php/sys-upgrade/php_readme.md) (±)\
  (+) daug informacijos internete\
  (+) kalba pakankamai universali, kad būtų taikoma ne tik web srityje\
  (–) sintaksė vis dar orientuota į web skriptinimą („<?php“ failo pradžioje)
* [x] [Pike <sup>&#x2B67;</sup>](pike/sys-upgrade/pike_readme.md) (+)\
  (+) C++ kalbos sintakse\
  (–) mažai naudojama
* [x] [Python <sup>&#x2B67;</sup>](python/sys-upgrade/python_readme.md) (±)\
  (+) plačiai naudojamas\
  (+) daug informacijos internete\
  (–) teksto įtraukomis grįsta sintaksė
  * [x] [Bython <sup>&#x2B67;</sup>](bython/sys_upgrade/bython_readme.md) (±)\
    (+) skliaustais įrėminti blokai
  * [x] [CurlyPy <sup>&#x2B67;</sup>](curlypy/sys_upgrade/curlypy_readme.md) (±)\
    (+) skliaustais įrėminti blokai
* [x] [Ruby <sup>&#x2B67;</sup>](ruby/sys-upgrade/ruby_readme.md) (–)\
  (–) keistoka sintaksė\
  (–) lėtas, išnaudoja tik vieną branduolį
* [x] [S-Lang <sup>&#x2B67;</sup>](s-lang/sys-upgrade/slang_readme.md) (–)\
  (+) brandi kalba, naudojama jed redaktoriuje ir kitose aplikacijose\
  (–) kartais nepatogi sintaksė\
  (–) neaiški ir neišsami dokumentacija
* [x] [Tcl <sup>&#x2B67;</sup>](tcl/sys-upgrade/tcl_readme.md) (±)\
  (+) sena, žinoma kalba\
  (–) kartais keista sintaksė

## Kompiliuojamos kalbos (13, dar 2 neveikia)

* [x] [C <sup>&#x2B67;</sup>](c/sys-upgrade/c_readme.md) (–)\
  (+) greita\
  (–) nėra reikiamų funkcijų ir struktūrų standartinėje bibliotekoje
* [x] [C++ <sup>&#x2B67;</sup>](c++/sys-upgrade/c++_readme.md) (+)\
  (+) kodą rašyti žymiai paprasčiau už C\
  (+) turi reikalingas duomenų struktūras
* [x] [C3 <sup>&#x2B67;</sup>](c3/sys-upgrade/c3_readme.md) (±)\
  (+) sukurta kaip C kalbos pakaitalas
* [ ] [Carbon <sup>&#x2B67;</sup>](carbon/sys-upgrade/carbon_readme.md) (–)\
  (+) kuriama kaip C kalbos pakaitalas\
  (–) nepakankamai iįvystyta, nepavyko sukompiliuoti dokumentacijos pavyzdžio
* [x] [Chapel <sup>&#x2B67;</sup>](chapel/sys-upgrade/chapel_readme.md) (?)\
  (+) kalba su C sintakse\
  (+) paralelinė\
  (–) pernelyg nauja, nedaug informacijos\
  (–) nelabai patogi dokumentacija
* [x] [Crystal <sup>&#x2B67;</sup>](crystal/sys-upgrade/crystal_readme.md) (+)\
  (+) kalba su Ruby sintakse, tačiau kompiliuojama, tad daugiau prasmės mokytis nei Ruby
* [x] [D <sup>&#x2B67;</sup>](d/sys-upgrade/d_readme.md) (+)\
  (+) išvystyta kalba\
  (–) sunkiai panaudojama be šiukšlių surinktuvo (Garbage Collector)
* [x] [Go <sup>&#x2B67;</sup>](go/sys-upgrade/go_readme.md) (±)
* [x] [Haskell <sup>&#x2B67;</sup>](haskell/sys-upgrade/haskell_readme.md) (–)\
  (–) sintakse ir logika labai skiriasi nuo kitų kalbų
* [x] [Odin <sup>&#x2B67;</sup>](odin/sys-upgrade/odin_readme.md) (+)\
  (+) dar vienas C kalbos pakaitalas\
  (+) paprastesnė už Zig, verta pasimokyti
* [ ] [Purescript <sup>&#x2B67;</sup>](purescript/sys-upgrade/purs_readme.md) (–)\
  (–) transpileris, generuojantis JS kodą\
  (–) netinka scenarijų kalbos vaidmeniui
* [x] [Rust <sup>&#x2B67;</sup>](rust/sys-upgrade/rust_readme.md) (–)\
  (–) reikalauja projekto failo\
  (–) neaiškūs klaidų pranešimai
* [x] [Swift <sup>&#x2B67;</sup>](swift/sys-upgrade/swift_readme.md) (–)\
  (–) klaidos\
  (–) dokumentacija orientuota į MacOS
* [x] [V <sup>&#x2B67;</sup>](v/sys-upgrade/v_readme.md) (–)\
  (–) mažai žinoma\
  (–) daug kritikos dėl neprofesionalių sprendimų
* [x] [Zig <sup>&#x2B67;</sup>](zig/sys-upgrade/zig_readme.md) (–)\
  (–) pernelyg sudėtinga paprastoms užduotims
