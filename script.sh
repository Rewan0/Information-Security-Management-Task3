#!/bin/bash

LOGFILE="apache_logs"  

if [[ ! -f "$LOGFILE" ]]; then
    echo "Log file not found: $LOGFILE"
    exit 1
fi

echo "=== Log File Analysis ==="

# 1. Request Counts
total_requests=$(wc -l < "$LOGFILE")
get_requests=$(grep '"GET' "$LOGFILE" | wc -l)
post_requests=$(grep '"POST' "$LOGFILE" | wc -l)

echo "[1] Request Counts"
echo "Total requests: $total_requests"
echo "GET requests: $get_requests"
echo "POST requests: $post_requests"
echo

# 2. Unique IP Addresses
echo "[2] Unique IP Addresses"
unique_ips=$(awk '{print $1}' "$LOGFILE" | sort | uniq | wc -l)
echo "Total unique IPs: $unique_ips"

echo "Requests per IP (GET/POST):"
awk '{print $1, $6}' "$LOGFILE" | grep -E '"GET|POST' | awk '
{
  if ($2 == "\"GET") get[$1]++;
  else if ($2 == "\"POST") post[$1]++;
}
END {
  for (ip in get) print ip, "GET:", get[ip], "POST:", post[ip]+0;
}
' | sort
echo

# 3. Failure Requests
echo "[3] Failure Requests (4xx and 5xx)"
failures=$(awk '$9 ~ /^4|^5/ {count++} END {print count}' "$LOGFILE")
fail_percentage=$(awk -v f="$failures" -v t="$total_requests" 'BEGIN { printf "%.2f", (f/t)*100 }')
echo "Total failed requests: $failures"
echo "Failure percentage: $fail_percentage%"
echo

# 4. Top User
echo "[4] Most Active IP"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -1
echo

# 5. Daily Request Averages
echo "[5] Daily Request Averages"
days=$(awk '{print $4}' "$LOGFILE" | cut -d: -f1 | sort | uniq | wc -l)
average=$(awk -v t="$total_requests" -v d="$days" 'BEGIN { printf "%.2f", t/d }')
echo "Total days: $days"
echo "Average requests per day: $average"
echo

# 6. Failure Analysis by Day
echo "[6] Days with Most Failures"
awk '$9 ~ /^4|^5/ {print $4}' "$LOGFILE" | cut -d: -f1 | sort | uniq -c | sort -nr | head
echo

# Additional Analyses

# Request by Hour
echo "[7] Requests Per Hour"
awk -F: '{print $2}' "$LOGFILE" | sort | uniq -c | sort -n
echo

# Status Code Breakdown
echo "[8] Status Code Breakdown"
awk '{print $9}' "$LOGFILE" | sort | uniq -c | sort -nr
echo

# Most Active User by Method
echo "[9] Most Active IP by Method"
echo "GET:"
grep '"GET' "$LOGFILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1
echo "POST:"
grep '"POST' "$LOGFILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1
echo

# Failure Patterns by Hour
echo "[10] Failure Patterns by Hour"
awk '$9 ~ /^4|^5/ {split($4, t, ":"); print t[2]}' "$LOGFILE" | sort | uniq -c | sort -nr
echo

echo "=== End of Analysis ==="
