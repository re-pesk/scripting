[Grįžti &#x2BA2;](../readme.md "Grįžti")

# yt-dlp [<sup>&#x2B67;</sup>](https://github.com/yt-dlp/yt-dlp)

## Diegimas

Paleidžiamas diegimo skriptas `yt-dlp_install.sh` arba terminale įvykdomos komandos:

```bash
LATEST="$(
  curl -sLo /dev/null -w "%{url_effective}" "https://github.com/yt-dlp/yt-dlp/releases/latest" | \
  xargs basename
)"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(yt-dlp --version | awk '{print $NF}')"

# Jeigu vėliausia versija nėra naujesnė nei įdiegtoji, diegimą nutraukti

curl -LO "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux"

printf 'sha256 patikros sumos:\n  atsisiųsto failo: %s\n  iš repozitorijos: %s\n\n' \
  "$(sha256sum "yt-dlp_linux" | awk '{print $1}')" \
  "$(curl -sSL "https://github.com/yt-dlp/yt-dlp/releases/latest/download/SHA2-256SUMS" \
      | grep 'yt-dlp_linux$' | awk '{print $1}')"

# Jeigu patikros sumos nesutampa, nutraukti diegimą ir ištrinti atsisiųstus failus

mkdir -p "${HOME}/.opt/yt-dlp"
mv -fT "yt-dlp_linux" "${HOME}/.opt/yt-dlp/yt-dlp"
chmod a+rx "${HOME}/.opt/yt-dlp/yt-dlp"

printf '%s\n' $'[[ -d "${HOME}/.opt/yt-dlp" ]] && \
  [[ ":${PATH}:" != *":${HOME}/.opt/yt-dlp:"* ]] && \
    export PATH="${HOME}/.opt/yt-dlp${PATH:+:${PATH}}"' > "${HOME}/.opt/yt-dlp/env.sh"
. "${HOME}/.opt/yt-dlp/env.sh"

printf '\nVersijos:\n  Vėliausia: %s\n  Įdiegta:   %s\n\n' \
  "${LATEST}" "$(yt-dlp --version | awk '{print $NF}')"

unset LATEST
```

Baigę diegti, pakeiskite konfigūracinius faile, kad `${HOME}/.opt/yt-dlp/env.sh` sistemos apvalkale būtų vykdomas automatiškai.
