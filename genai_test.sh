#!/bin/bash

CSV="genai_urls.csv"

trap "echo 'Stopping...'; kill 0" SIGINT

# URL만 추출해서 배열에 저장 (zsh/bash 호환)
URLS=()
while IFS=',' read -r _ domain; do
  domain="${domain//$'\r'/}"
  [[ "$domain" == "domain" ]] && continue
  [[ -z "$domain" ]] && continue
  if [[ "$domain" != http://* && "$domain" != https://* ]]; then
    domain="https://$domain"
  fi
  URLS+=("$domain")
done < "$CSV"

while true; do
  for url in "${URLS[@]}"; do
    echo "[ACCESS] $url"
    curl -k "$url"
    sleep 1
  done
done

