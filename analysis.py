import matplotlib.pyplot as plt
import pandas as pd

# 1. Request Counts
request_types = ['GET', 'POST']
request_counts = [9952, 5]

plt.figure(figsize=(6, 6))
plt.pie(request_counts, labels=request_types, autopct='%1.1f%%', startangle=140)
plt.title('GET vs POST Requests')
plt.savefig('01_get_post_distribution.png')
plt.close()

# 2. Unique IPs (Pie chart for top 1 + rest as "Others")
top_ip = {'66.249.73.135': 482}
others = 10000 - 482  # from total requests
labels = ['66.249.73.135', 'Others']
counts = [482, others]

plt.figure(figsize=(6, 6))
plt.pie(counts, labels=labels, autopct='%1.1f%%', startangle=140)
plt.title('Top IP Activity')
plt.savefig('02_top_ip_pie.png')
plt.close()

# 3. Failure Requests by Day
failures_by_day = {
    '17 May': 30,
    '18 May': 66,
    '19 May': 66,
    '20 May': 58
}

plt.figure(figsize=(8, 5))
plt.bar(failures_by_day.keys(), failures_by_day.values(), color='orange')
plt.title('Failures by Day')
plt.xlabel('Date')
plt.ylabel('Failures')
plt.savefig('03_failures_by_day.png')
plt.close()

# 4. Status Code Breakdown
status_codes = {
    '200 OK': 9126,
    '304 Not Modified': 445,
    '404 Not Found': 213,
    '301 Moved Permanently': 164,
    'Other': 50
}

plt.figure(figsize=(8, 5))
plt.bar(status_codes.keys(), status_codes.values(), color='skyblue')
plt.title('HTTP Status Code Distribution')
plt.xlabel('Status Code')
plt.ylabel('Count')
plt.xticks(rotation=30)
plt.savefig('04_status_code_distribution.png')
plt.close()

# 5. Requests per Hour (Mocked example based on description)
hours = [f'{h}:00' for h in range(24)]
requests_per_hour = [150]*9 + [300, 350, 400, 450, 500, 600, 550] + [300]*8  # ← كان 7، خليناه 8

plt.figure(figsize=(10, 5))
plt.plot(hours, requests_per_hour, marker='o')
plt.title('Requests per Hour')
plt.xlabel('Hour')
plt.ylabel('Request Count')
plt.xticks(rotation=45)
plt.grid(True)
plt.savefig('05_requests_per_hour.png')
plt.close()

# 6. Table of Top IPs
top_ips_data = {
    'IP Address': ['66.249.73.135', '78.173.140.106'],
    'Method': ['GET', 'POST'],
    'Requests': [482, 3]
}

df_top_ips = pd.DataFrame(top_ips_data)
df_top_ips.to_csv('06_top_ips_table.csv', index=False)

