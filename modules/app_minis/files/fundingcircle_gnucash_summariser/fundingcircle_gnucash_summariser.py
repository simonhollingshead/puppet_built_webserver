#/usr/bin/env python3

import csv
import sys

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Accepts exactly one parameter - the filepath to a Funding Circle CSV export.")
        sys.exit(1)
    entries = {}
    with open('input.csv', 'r') as f:
        csv_reader = csv.reader(f)
        next(csv_reader)  # Remove the headers.
        for row in csv_reader:
            loan_part = ""
            if "Interest repayment for loan part " in row[1]:
                loan_part = row[1].split(" ")[-1]
                if row[0]+loan_part in entries:
                    entries[row[0]+loan_part]["interest"] = row[2]
                else:
                    entries[row[0] + loan_part] = {"interest": row[2]}
            elif "Principal repayment for loan part " in row[1]:
                loan_part = row[1].split(" ")[-1]
                if row[0]+loan_part in entries:
                    entries[row[0]+loan_part]["principal"] = row[2]
                else:
                    entries[row[0] + loan_part] = {"principal": row[2]}
            elif "Servicing fee for Loan ID " in row[1]:
                loan_part = row[1].split(";")[1].split(" ")[-1]
                if row[0]+loan_part in entries:
                    entries[row[0]+loan_part]["fee"] = row[3]
                else:
                    entries[row[0] + loan_part] = {"fee": row[3]}
            elif "Loan offer on " in row[1]:
                loan_part = row[1].split(" ")[-1]
                if row[0]+loan_part in entries:
                    entries[row[0]+loan_part]["cost"] = row[3]
                else:
                    entries[row[0] + loan_part] = {"cost": row[3]}
            else:
                raise IOError("Unrecognised row: "+row[1])

delta = 0
print("{: ^10} {: ^9} {: ^5} {: ^5} {: ^5} {: ^5} {: ^6}".format("Date", "ID", "Prin.", "Int", "Fee", "Cost", "Total"))
for k in sorted(entries.keys()):
    principal = float(entries[k].get("principal", "0"))
    interest = float(entries[k].get("interest", "0"))
    fee = float(entries[k].get("fee", "0"))
    cost = float(entries[k].get("cost", "0"))
    total = principal + interest - fee - cost
    delta += total
    print("{: >10} {: >9} {: >5.2f} {: >5.2f} {: >5.2f} {: >5.2f} {: >6.2f}".format(k[0:10],
                                                                                    k[10:],
                                                                                    principal,
                                                                                    interest,
                                                                                    fee,
                                                                                    cost,
                                                                                    total
                                                                                    ))
print()
print("Difference between last month and this month: £{:.2f}".format(delta))

