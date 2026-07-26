import csv
import re

input_file = "transactions_inserts.sql"
output_file = "transactions.csv"

pattern = re.compile(
    r"VALUES \('([^']+)', '([^']+)', '([^']+)', '([^']+)', '([^']+)'\);"
)

with open(input_file, "r", encoding="utf-8") as sql_file, \
     open(output_file, "w", newline="", encoding="utf-8") as csv_file:

    writer = csv.writer(csv_file)

    writer.writerow([
        "transaction_id",
        "account_id",
        "merchant_id",
        "amount_usd",
        "transaction_date"
    ])

    row_count = 0

    for line in sql_file:
        match = pattern.search(line)

        if match:
            writer.writerow(match.groups())
            row_count += 1

print(f"Conversion completed successfully.")
print(f"Rows converted: {row_count:,}")
print(f"Output file: {output_file}")