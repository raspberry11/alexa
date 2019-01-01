KEY-"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3ipvc2kAab5av\nu0QXNp4wZTHU+OmXWnwvbn1s+2/u019KPAHHqUDsHv8qVFk2wYbzWo94apWuzpLs\nbJBIzz8BfVaAnVlQ7N+u/3a2M8iSpoMcQ555hPiDvZVmSH8LSKrREKFwy62YW3+B\np3QCR6wham4NIAzILJv3nJ/a5AB6FhHdvyjBR5E2LaqLVwz/h4awqD+29IAiOvCE\ndtmhx7ZBWi1OMQwQVH7NQyaru3KZUVMz4+Zhx7gkcWsrsxu9qZJW63/hmVc79KQc\nxVAkxkmaU5CmWRk2TPKE1jUkD5bHD+Xd5uefsovUXUcglsm3AkR2cKrUT2tJ3RRL\nvTm97dtnAgMBAAECggEAN0G9I/P3GZ5fxN9BpCV24YYNxxr7JGyC97qxeyaFr+am\nCRDgzk4H9C5uzr0fMMt5x/kLOYsJLlwVwqT6mVj/lIC6ErWMhr8RprtVb4xOhcwo\nq9E1vEsKkIr6mBUaXnjNqGxz1iQTyss9K3kRBYCzc0n6AOyVvIwllpnqTHmZJSfO\nSvtylAy1AlcT4yfiT1sMFO0XFaMjT2vrAGj92A7Cz3qwI3mrKNlEjfWZrJDu7C74\nWSu6cSGYyZ1N1xNGv4BHkTIr8KOhT2YvWjPjaqJaWSOyKYAaFk9DodpOT1Nce8zw\nWMDXUWb9MHuPFuL2FV8Em/5hgmnngsaz1+mrxWxHtQKBgQDZjs3t9H8O8Py28+C0\n/USWbTPSUNb0AaJWo/YXdQ+8XLTzhpS9oIxg/UXdXRED7cKEC4ct8HQONE3DLjL2\nCwmynELjiqnc/hWMddMs/oMuvZcg55TIXYMoAua36JXyCufszF5mFivq8C8IZthN\n90sEl0ZHTAl4JKiUz+lL8zUw1QKBgQDX+RQFW0uNz49rGY60WP5eCZW1KOWyp8PV\nkD2flvE5C4fwocjxzx8qd2ooDp7dieIP1DMuGa5pLzPI1mzjboGaTr5rbUpJ/o+Q\n/N5bCcxfV/HN+O37vVKL7AMXkPh7QkIxcrmsWDK0v+tTjQaQw4kceeqktSQvCpPz\nyeQI5STZSwKBgQCw3ohMjBk/7GuH0X09pym7ocwfj9kxRqLUDThkmabRXA1Abok+\nIOf/cej6rk7HAuTAtR6RGos/gQY3R7fmj9KygpdepbyzDV43cxLb4Y6E0V2sQpmS\ny3N1c+ZeXZiJzpP+z6dvF1ddCSczjWkM+Z7jfJiGHisUobjsQptIQ9FagQKBgFED\n1kbMIGNp4NrEE4wDdifAYLA8Ty3dUNDj8rnS3VoQwUW66q4KjB5Z/TBZi65+8pYN\ne8VnTM2YL0y/YslNwsAnmbaioKNxIlm5AZAU9N0vGD2zi1JLipOCTQaiExPpnvr9\nljjYPO0gsR3+YOAc+Wn9Mc/nQ1OCHE3vBeNwUYpRAoGAAYcgh9bh8L5nznrfIUBM\nuDS/jirM6MHhhvripjaL4KoPkkJvKY7Gqlmkxu3VoY4oNgjuH2uzkpesOiqOzAms\nSG3UAX8A/gqNwb2NaOZqqH2OACYqHWBgByPIg6YJ3PwnTVGUWX5MmPeAr6RG7xtX\n/3e5Lm1whq3BQ3IpOdqY0+g="
URL-"https://www.google.com/speech-api/v2/recognize?output=json&lang=de-de&key=$KEY"

echo "Aufnahme... Zum stoppen STRG+C drücken und warten."
arecord -D plughw:1,0 -f cd -t wav -d 0 -q -r 44100 | flac - -s -f --best --sample-rate 44100 -o file.flac;
echo ""
echo "Ausführen..."
wget -q -U "Mozilla/5.0" --post-file file.flac --header "Content-Type: audio/x-flac; rate=44100" -O - "$URL" >stt.txt
 
echo -n "Google Antwort: "
OUTPUT=$(cat stt.txt  | sed -e 's/[{}]/''/g' | awk -F":" '{print $4}' | awk -F"," '{print $1}' | tr -d '\n')
 
echo $OUTPUT
echo ""
 
rm file.flac  > /dev/null 2>&1
 
strindex() {
  x="${1%%$2*}"
  [[ $x = $1 ]] && echo -1 || echo ${#x}
}
 
# Damit Groß- und Kleinschreibung ignoriert wird.
# Falls wichtig, nächste Zeile auskommentieren
OUTPUT=$(echo $OUTPUT | tr '[:upper:]' '[:lower:]')
 
# Die zu suchende Zeichenkette muss klein geschrieben sein
# (ansonsten den Befehl vorher auskommentieren)
if (($(strindex "$OUTPUT" "licht an") != -1));  then
  # Befehle ausführen, Skripte startem, etc.
  echo "Licht wird eingeschaltet"
fi
if (($(strindex "$OUTPUT" "licht aus") != -1));  then
  echo "Licht wird ausgeschaltet"
fi