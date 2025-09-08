#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 <principal> <rate_percent> <time_years>  (or run with no args for interactive mode)"; }

if [[ $# -eq 0 ]]; then
  read -rp "Principal: " P
  read -rp "Rate (% per year): " R
  read -rp "Time (years): " T
else
  if [[ $# -ne 3 ]]; then usage; exit 1; fi
  P="$1"; R="$2"; T="$3"
fi

if command -v bc >/dev/null 2>&1; then
  SI=$(echo "scale=2; $P * $R * $T / 100" | bc)
  TOTAL=$(echo "scale=2; $P + $SI" | bc)
else
  SI=$(awk -v p="$P" -v r="$R" -v t="$T" 'BEGIN{printf "%.2f", p*r*t/100}')
  TOTAL=$(awk -v p="$P" -v si="$SI" 'BEGIN{printf "%.2f", p+si}')
fi

echo "Simple Interest: $SI"
echo "Total Amount: $TOTAL"
