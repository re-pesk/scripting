[Grįžti &#x2BA2;](../readme.md "Grįžti")

# Skriptinimas skirtingomis programavimo kalbomis (67)

Ubuntu paketų atnaujinimo skriptas skirtingomis programavimo kalbomis ar jų dialektais.

Tikslas - patikrinti, kaip skirtingos kalbos tinka rašyti operacijų sistemos valdymo skriptus.

Naudota operacinė sistema – Ubuntu 24.04

## Diegimas

Apie programavimo kalbų ir vykdymo aplinkų [diegimą <sup>&#x2B67;</sup>](../install/_proglangs/readme.md "Diegimas")

## Tipinės apvalkalo scenarijų (Shell scripting) kalbos (7)

* [x] [Bash <sup>&#x2B67;</sup>](bash/bash_readme.md) (±)\
  (–) asociatyvieji masyvai netinka medžio tipo struktūroms\
  (+) labai paplitusi, daug informacijos
  * [x] [Brush <sup>&#x2B67;</sup>](brush/brush_readme.md) (–)\
    (+) greita ir saugi - parašyta su Rust\
    (+) suderinama su Bash
* [x] [Dash <sup>&#x2B67;</sup>](dash/dash_readme.md) (–)\
  (+) greita\
  (–) neturi asociatyviųjų masyvų\
  (–) daug kitų apribojimų
* [x] [Yash <sup>&#x2B67;</sup>](yash/yash_readme.md) (–)\
  (–) mažai informacijos\
  (–) neturi asociatyviųjų masyvų
* [x] [ksh <sup>&#x2B67;</sup>](kash/ksh_readme.md) (±)\
  (+) turi įterptinius asocijuotuosius masyvus\
  (–) trūksta parametrų išplėtimo (Parameter Expansion) galimybių
* [x] [Osh (Oils) <sup>&#x2B67;</sup>](oils/oils_readme.md) (–)\
  (–) vieno žmogaus projektas\
  (–) mažai informacijos\
  (–) paini dokumentacija
* [x] [Zsh <sup>&#x2B67;</sup>](zsh/zsh_readme.md) (±)\
  (–) asociatyvieji masyvai netinka medžio tipo struktūroms\
  (+) pakankamai paplitusi, daug informacijos

## Alternatyvios apvalkalo scenarijų (Shell scripting) kalbos (10)

* [x] [Abs <sup>&#x2B67;</sup>](abs/abs_readme.md) (±)\
  (+) patogi kalba\
  (?) ~~nebevystoma?~~ atnaujinta 2025-04-27
* [x] [Arsh <sup>&#x2B67;</sup>](arsh/arsh_readme.md) (–)\
  (–) vieno žmogaus projektas\
  (+) statiškai tipizuota scenarijų kalba\
  (+) apvalkalui būdingos savybės
* [x] [Elvish <sup>&#x2B67;</sup>](elvish/elvish_readme.md) (?)\
  (–) keista asocijuotųjų masyvų ir funkcijų sintaksė\
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [Fish <sup>&#x2B67;</sup>](fish/fish_readme.md) (–)\
  (–) neturi priemonių medžio tipo struktūroms\
  (–) nepatogi sintaksė
* [x] [Ysh (Oils) <sup>&#x2B67;</sup>](oils/oils_readme.md) (–)\
  (–) vieno žmogaus projektas\
  (–) mažai informacijos\
  (–) paini dokumentacija
* [x] [Koi <sup>&#x2B67;</sup>](koi/koi_readme.md) (–)\
  (–) neužbaigta kalba\
  (–) trūksta reikalingų apvalkalo kalboms ypatybių
* [x] [Murex <sup>&#x2B67;</sup>](murex/murex_readme.md) (–)\
  (–) keista sintaksė
* [x] [Ngs <sup>&#x2B67;</sup>](ngs/ngs_readme.md) (?)\
  (–) keistai organizuotas darbas su klaidomis
  (?) ~~nebevystoma?~~ atnaujinta 2025-04-05
* [x] [Nushell <sup>&#x2B67;</sup>](nushell/nu_readme.md) (?)\
  (+) dažniau minima, nei kitos alteratyvios apvalkalo scenarijų kalbos
* [x] [PowerShell <sup>&#x2B67;</sup>](powershell/pwsh_readme.md) (–)\
  (–) keista sintaksė\
  (–) kilmė iš Microsoft'o

## Intepretuojamos kalbos ir JIT kompiliatoriai (37)

### JavaVM (8)

Lėtai pasileidžia arba reikalingas kompiliavimas. Reikalinga Java JRE arba JDK. (–)

* [x] [Clojure <sup>&#x2B67;</sup>](clojure/clojure_readme.md) (–)\
  (?) Lisp'o sintaksė
* [x] [Ballerina <sup>&#x2B67;</sup>](ballerina/ballerina_readme.md) (–)\
  (–) ribotos išorinių komandų iškvietimo funkcijos\
  (–) sudėtingas klaidų apdrojimas\
  (–) skurdi dokumentacija\
  (–) mažai informacijos internete
* [X] [Groovy <sup>&#x2B67;</sup>](groovy/groovy_readme.md) (–)
* [x] [Java <sup>&#x2B67;</sup>](java/java_readme.md) (–)
* [Kotlin <sup>&#x2B67;</sup>](kotlin/kotlin_readme.md) (–)
  3 kodo variantai:
  * [x] intepretuojamas,
  * [x] JVM,
  * [x] kompiliuojamas į mašininį kodą.
* [x] [Scala <sup>&#x2B67;</sup>](scala/scala_readme.md) (–)

### JavaScript'as ir TypeScript'as (4)

* [JavaScript'as <sup>&#x2B67;</sup>](js/js_readme.md) (+)
  (+) Daug informacijos internete
  * [x] Bun (+)
  * [x] Deno (±)
  * [x] Node (+)
* [TypeScript'as <sup>&#x2B67;</sup>](ts/ts_readme.md) (±)
  (+) Daug informacijos internete
  (+) Sparčiai populiarėja
  (–) Paprastai vykdomas ne tiesiogiai, bet po vertimo į JS
  * [x] Deno (+)
    (+) Vykdomas tiesiogiai, be vertimo į JS

### Kitos (25)

* [x] [Aria <sup>&#x2B67;</sup>](aria/aria_readme.md) (–)\
  (–) nepatogus darbas su išorinėmis komandomis: negalima išvesti pranešimų vykdymo metu\
  (+) žada ištaisyti tai ateityje
  (+) dažni leidimai
* [x] [Dart <sup>&#x2B67;</sup>](dart/dart_readme.md) (–)\
  (–) nepatogus darbas su išorinėmis komandomis
* [x] [Euphoria <sup>&#x2B67;</sup>](euphoria/euph_readme.md) (–)\
  (–) sudėtingas instaliavimas\
  (–) seniai nebuvo leidimų
  * [x] [Phix <sup>&#x2B67;</sup>](phix/phix_readme.md) - stipriai modifikuota Euforijos versija (–)\
    (–) nepavyko paleisti visų pavyzdžių
* [x] [Haxe <sup>&#x2B67;</sup>](haxe/haxe_readme.md) (–)\
  (–) pagrindinė klasė nepatogiai susieta su kodo failo pavadinimu\
  (–) reikalauja pagrindinės klasės
* [x] [Io <sup>&#x2B67;</sup>](io/io_readme.md) (±)\
  (+) maža, paprasta kalba\
  (?) Smaltalk'o sintaksė\
  (–) nebevystoma
* [x] [Janet <sup>&#x2B67;</sup>](janet/janet_readme.md) (?)\
  (?) Lisp'o sintaksė\
  (+) pozicionuojama kaip skriptinė kalba
* [x] [Julia <sup>&#x2B67;</sup>](julia/julia_readme.md) (±)\
  (?) Pythono pakaitalas moksliniams skaičiavimams
* [x] [Lua <sup>&#x2B67;</sup>](lua/lua_readme.md) (+)\
  (+) paprasta kalba
  * [x] [Hilbish <sup>&#x2B67;</sup>](hilbish/hilbish_readme.md) Apvalkalas (shell) Lua kalbos pagrindu (+)
  * [x] [Pluto <sup>&#x2B67;</sup>](pluto/pluto_readme.md) Lua kalbos supersetas su klasėmis (+)
* [x] [Miniscript <sup>&#x2B67;</sup>](miniscript/mscr_readme.md) (–)\
  (+) paprasta kalba\
  (–) menkos galimybės dirbti su išorinėmis komandomis\
  (–) mažai informacijos internete\
  (–) seniai nebuvo leidimų\
  (+) ruošiama nauja versija
* [x] [Onyx <sup>&#x2B67;</sup>](onyx/onyx_readme.md) - kalba, skirta kompiliuoti į Wasm (±)\
  (+) turi JIT kompiliatorių\
  (–) visiškai nauja kalba\
  (–) nėra dokumentacijos
* [x] [Perl <sup>&#x2B67;</sup>](perl/perl_readme.md) bendros paskirties Unix'o scenarijų kalba (–)\
  (–) nepatogi ir keista sintaksė\
  (+) daug informacijos ir pavyzdžių
* [x] [PHP <sup>&#x2B67;</sup>](php/php_readme.md) (±)\
  (+) daug informacijos internete\
  (+) kalba pakankamai universali, kad būtų taikoma ne tik web srityje\
  (–) sintaksė vis dar orientuota į web skriptinimą („<?php“ failo pradžioje)
* [x] [Pike <sup>&#x2B67;</sup>](pike/pike_readme.md) (+)\
  (+) C++ kalbos sintakse\
  (–) mažai naudojama
* [x] [Python <sup>&#x2B67;</sup>](python/python_readme.md) (±)\
  (+) plačiai naudojamas\
  (+) daug informacijos internete\
  (–) teksto įtraukomis grįsta sintaksė
  * [x] [Bython <sup>&#x2B67;</sup>](bython/sys_upgrade/bython_readme.md) (±)\
    (+) skliaustais įrėminti blokai
  * [x] [CurlyPy <sup>&#x2B67;</sup>](curlypy/sys_upgrade/curlypy_readme.md) (±)\
    (+) skliaustais įrėminti blokai
* [x] [Ruby <sup>&#x2B67;</sup>](ruby/ruby_readme.md) (–)\
  (–) keistoka sintaksė\
  (–) lėtas, išnaudoja tik vieną procesoriaus branduolį
* [x] [SBCL <sup>&#x2B67;</sup>](sbcl/sbcl_readme.md) (±)\
  (?) Lisp'o dialektas Common Lisp
* Scheme
  * [x] [Guile <sup>&#x2B67;</sup>](guile/guile_readme.md) (–)\
    (?) Lisp'o sintaksė\
    (–) sudėtinga susigaudyti dokumentacijoje\
    (–) mažai informacijos intenete
  * [x] [Racket <sup>&#x2B67;</sup>](racket/racket_readme.md) (±)\
    (?) Lisp'o sintaksė\
    (+) daug informacijos internete\
* [x] [S-Lang <sup>&#x2B67;</sup>](s-lang/slang_readme.md) (–)\
  (+) brandi kalba, naudojama jed redaktoriuje ir kitose aplikacijose\
  (–) kartais nepatogi sintaksė\
  (–) neaiški ir neišsami dokumentacija
* [x] [Tcl <sup>&#x2B67;</sup>](tcl/tcl_readme.md) (±)\
  (+) sena, žinoma kalba\
  (–) kartais keista sintaksė

## Kompiliuojamos kalbos (13, dar 2 neveikia)

* [x] [C <sup>&#x2B67;</sup>](c/c_readme.md) (–)\
  (+) greita\
  (–) nėra reikiamų funkcijų ir struktūrų standartinėje bibliotekoje
* [x] [C++ <sup>&#x2B67;</sup>](c++/c++_readme.md) (+)\
  (+) kodą rašyti žymiai paprasčiau už C\
  (+) turi reikalingas duomenų struktūras
* [x] [C3 <sup>&#x2B67;</sup>](c3/c3_readme.md) (±)\
  (+) sukurta kaip C kalbos pakaitalas
* [ ] [Carbon <sup>&#x2B67;</sup>](carbon/carbon_readme.md) (–)\
  (+) kuriama kaip C kalbos pakaitalas\
  (–) nepakankamai išvystyta, nepavyko sukompiliuoti dokumentacijos pavyzdžio
* [x] [Chapel <sup>&#x2B67;</sup>](chapel/chapel_readme.md) (?)\
  (+) kalba su C sintakse\
  (+) paralelinė\
  (–) pernelyg nauja, nedaug informacijos\
  (–) nelabai patogi dokumentacija
* [x] [Crystal <sup>&#x2B67;</sup>](crystal/crystal_readme.md) (+)\
  (+) kalba su Ruby sintakse, tačiau kompiliuojama, tad daugiau prasmės mokytis nei Ruby
* [x] [D <sup>&#x2B67;</sup>](d/d_readme.md) (+)\
  (+) išvystyta kalba\
  (–) sunkiai panaudojama be šiukšlių surinktuvo (Garbage Collector)
* [x] [Go <sup>&#x2B67;</sup>](go/go_readme.md) (±)
* [x] [Haskell <sup>&#x2B67;</sup>](haskell/haskell_readme.md) (–)\
  (–) sintakse ir logika labai skiriasi nuo kitų kalbų
* [x] [Odin <sup>&#x2B67;</sup>](odin/odin_readme.md) (+)\
  (+) dar vienas C kalbos pakaitalas\
  (+) paprastesnė už Zig, verta pasimokyti
* [ ] [Purescript <sup>&#x2B67;</sup>](purescript/purs_readme.md) (–)\
  (–) transpileris, generuojantis JS kodą\
  (–) netinka aplinkos scenarijų kalbos vaidmeniui
* [x] [Rust <sup>&#x2B67;</sup>](rust/rust_readme.md) (–)\
  (–) reikalauja projekto failo\
  (–) neaiškūs klaidų pranešimai
* [x] [Swift <sup>&#x2B67;</sup>](swift/swift_readme.md) (–)\
  (–) klaidos\
  (–) dokumentacija orientuota į MacOS
* [x] [V <sup>&#x2B67;</sup>](v/v_readme.md) (–)\
  (–) mažai žinoma\
  (–) daug kritikos dėl neva neprofesionalių sprendimų
* [x] [Zig <sup>&#x2B67;</sup>](zig/zig_readme.md) (–)\
  (–) pernelyg sudėtinga paprastoms užduotims
