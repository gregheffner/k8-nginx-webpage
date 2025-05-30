IP="$1"
ZONE_ID=$(cat /etc/cloudflare/ZONE_ID)
API_TOKEN=$(cat /etc/cloudflare/API_TOKEN)
DATE_MMDDYY=$(TZ=America/New_York date +"%m/%d/%y")
TIME_HHMMSS=$(TZ=America/New_York date +"%H:%M:%S")

# Get ASN using whois
ASN=$(whois "$IP" | grep -iE 'origin:|OriginAS:' | grep -Eo 'AS[0-9]+' | head -n1)

curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/firewall/access_rules/rules" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "mode": "block",
    "configuration": {
      "target": "ip",
      "value": "'"$IP"'"
    },
    "notes": "Blocked by fail2ban on '"$DATE_MMDDYY $TIME_HHMMSS"' (ASN: '"$ASN"')"
  }'
