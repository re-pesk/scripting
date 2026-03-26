#!/usr/bin/env -S bash

declare -A messages="(
  'en.UTF-8.infoTitle' 'Starting reminder'
  'en.UTF-8.error' 'Error!'
  'en.UTF-8.errorDurationNotExists' 'Duration is absent!'
  'en.UTF-8.errorDurationFormat' 'Wrong duration format!'
  'en.UTF-8.errorMessageIsAbsent' 'No message specified!'
  'en.UTF-8.errotTimeNotExists' 'Time is absent!'
  'en.UTF-8.startInfo' 'Remind after'
  'en.UTF-8.finalInfoTitle' 'Reminder'
  'en.UTF-8.finalInfo' 'has already expired!'
  'en.UTF-8.h' 'hrs'
  'en.UTF-8.m' 'min'
  'en.UTF-8.s' 'sec'

  'lt_LT.UTF-8.infoTitle' 'Programos paleidimas'
  'lt_LT.UTF-8.error' 'Klaida!'
  'lt_LT.UTF-8.errorDurationNotExists' 'Nenurodyta trukmė!'
  'lt_LT.UTF-8.errorDurationFormat' 'Klaidingas trukmės formatas!'
  'lt_LT.UTF-8.errorMessageIsAbsent' 'Nenurodytas pranešimas!'
  'lt_Lt.UTF-8.errotTimeNotExists' 'Nenurodytas laikas!'
  'lt_LT.UTF-8.startInfo' 'Priminti po'
  'lt_LT.UTF-8.finalInfoTitle' 'Priminimas'
  'lt_LT.UTF-8.finalInfo' 'jau praėjo!'
  'lt_LT.UTF-8.h' 'val'
  'lt_LT.UTF-8.m' 'min'
  'lt_LT.UTF-8.s' 'sek'
)"

declare -A messages="(
  ${messages[*]@K}
  'en.UTF-8.info' 'When a reminder is starting, the duration and the text of the message must be specified. \
There must be a space between the duration and the message text.

The duration shall follow the following format:

one or more digits, which may be followed by the following without a space

  \"h\" or \"${messages[en.UTF-8.h]}\",
  \"m\" or \"${messages[en.UTF-8.m]}\",
  \"s\" or \"${messages[en.UTF-8.s]}\",

Message text is in free form, it is not to be surrounded by quotes.

Usage:

>  priminiklis.sh 1m \"Text of the message\"

>  priminiklis.sh 1m Text of the message'

  'lt_LT.UTF-8.info' 'Paleidžiant priminimą, turi būti nurodyti trukmė ir pranešimo tekstas. \
Tarp trukmės ir pranešimo teksto turi būti tarpas.

Trukmė turi atitikti tokį formatą:

vienas ar keli skaitmenys, po kurių be tarpo gali būti prirašyta

  \"h\" arba \"${messages[lt_LT.UTF-8.h]}\",
  \"m\" arba \"${messages[lt_LT.UTF-8.m]}\",
  \"s\" arba \"${messages[lt_LT.UTF-8.s]}\",

Pranešimo tekstas laisvas, jis neturi būti įrėmintas kabutėmis.

Naudojimas:

>  priminiklis.sh 1m \"Pranešimo tekstas\"

>  priminiklis.sh 1m Pranešimo tekstas'
)"

path_name="$(realpath "$0")"

if [[ "$*" == "" ]]; then
  if [[ $(ps -o stat= -p $$) == *+* ]]; then
    printf '%s\n\n' "${messages[$LANG.info]}" >&2
    "${path_name}" &
    exit 1
  fi
  zenity --info \
    --title "${messages[$LANG.infoTitle]}" \
    --width=400 \
    --height=300 \
    --text "${messages[$LANG.info]}"
  exit 1
fi

if [[ "$(ps -o stat= -p $$)" == *+* ]]; then
  set -- "$(date +"%Y-%m-%d %H:%M:%S")" "$@"
fi

if [ "$1" = "" ]; then
  if [[ $(ps -o stat= -p $$) == *+* ]]; then
    printf '\n%s\n\n' "${messages[$LANG.errorTimeNotExists]}" >&2
    "${path_name}" "$@" &
    exit 1
  fi
  zenity --error \
    --width=400 \
    --height=100 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorTimeNotExists]}"
  exit 1
fi

if [ "$2" = "" ]; then
  if [[ $(ps -o stat= -p $$) == *+* ]]; then
    printf '\n%s\n\n' "${messages[$LANG.errorDurationNotExists]}" >&2
    "${path_name}" "$@" &
    exit 1
  fi
  zenity --error \
    --width=400 \
    --height=100 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorDurationNotExists]}"
  exit 1
fi

trukme="$2"
[[ "$trukme" =~ ^[0-9]+$ ]] && trukme="${trukme}m"
[[ "$trukme" =~ ^[0-9]+${messages[$LANG.m]}$ ]] && trukme="${trukme//${messages[$LANG.m]}/m}"
[[ "$trukme" =~ ^[0-9]+${messages[$LANG.s]}$ ]] && trukme="${trukme//${messages[$LANG.s]}/s}"
[[ "$trukme" =~ ^[0-9]+${messages[$LANG.h]}$ ]] && trukme="${trukme//${messages[$LANG.h]}/h}"

if [[ ! ( "$trukme" =~ ^[0-9]+[hms]$ ) ]]; then
  if [[ $(ps -o stat= -p $$) == *+* ]]; then
    printf '\n%s\n\n' "${messages[$LANG.errorDurationFormat]}" >&2
    printf '\n%s\n\n' "${trukme}" >&2
    "${path_name}" "$@" &
    exit 1
  fi
  zenity \
    --error \
    --width=400 \
    --height=100 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorDurationFormat]}: \"$trukme\"!"
  exit 1
fi

text="${*:3}"

if [ "$text" == "" ]; then
  if [[ $(ps -o stat= -p $$) == *+* ]]; then
    printf '\n%s\n\n' "${messages[$LANG.errorMessageIsAbsent]}" >&2
    "${path_name}" "$@" &
    exit 1
  fi
  zenity \
    --error \
    --width=400 \
    --height=100 \
    --title "${messages[$LANG.error]}" \
    --text "${messages[$LANG.errorMessageIsAbsent]}"
  exit 1
fi

time="$(date +"%Y-%m-%d %H:%M:%S")"

if [[ $(ps -o stat= -p $$) == *+* ]]; then
  # printf '\n%s\n\n%s\n\n' "$(dirname "$0" | xargs dirname)/sounds/Alarm_clock.ogg" "${messages[$LANG.startInfo]} $trukme: $text" >&2
  printf '\n%s\n\n%s %s: %s\n\n' "${time}" "${messages[$LANG.startInfo]}" "$(
    sed "s/m/ ${messages[$LANG.m]}/; s/s/ ${messages[$LANG.s]}/; s/h/ ${messages[$LANG.h]}/" <<<"$trukme"
  )" "$text" >&2
  "${path_name}" "${time}" "$trukme" "$text" &
  exit 0
fi

secs="0"
case "$trukme" in
  (*h)
    secs=$((${trukme%h} * 3600)) # valanda = 3600s
    ;;
  (*m)
    secs=$((${trukme%m} * 60)) #  minutė = 60s
    ;;
  (*s)
    secs=${trukme%s}
    ;;
  (*)
    zenity \
      --error \
      --width=400 \
      --height=300 \
      --title "${messages[$LANG.error]}" \
      --text "${messages[$LANG.errorDurationFormat]}: $trukme"
    exit 1
    ;;
esac

sleep "$secs" # laukti nurodytą sekundžių skaičių

paplay /usr/share/sounds/ubuntu/ringtones/Alarm\ clock.ogg
# paplay $(dirname "${path_name}")/../sounds/Alarm\ clock.ogg

# Parodyti langą su antrašte ir tekstu
zenity \
  --warning \
  --width=400 \
  --title "${messages[$LANG.finalInfoTitle]}" \
  --text "Nuo ${time}\n\n$(
      sed "s/m/ ${messages[$LANG.m]}/; s/s/ ${messages[$LANG.s]}/; s/h/ ${messages[$LANG.h]}/" <<<"$trukme"
    ) ${messages[$LANG.finalInfo]}\n\n${text}"
