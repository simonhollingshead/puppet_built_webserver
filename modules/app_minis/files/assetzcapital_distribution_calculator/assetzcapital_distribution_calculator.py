#!/usr/bin/python3

import csv
from collections import defaultdict
import sys

# Checks if the transaction matters for the purpose of this calculation.
def relevant_transaction(t):
    return ("Purchase loan part" in t or "Sale of loan part" in t)

# Extracts the loan name from a loan message.
def get_loan_name(t):
    return t.split("loan:",1)[1].strip()

if __name__ == "__main__":
    if not len(sys.argv) == 2:
        print("Accepts exactly one parameter - the filepath to an Assetz Capital CSV export.")
    with open(sys.argv[1], 'rt') as csvfile:
        # Default to entries being for £0.00.
        loandict = defaultdict(float)
        acreader = csv.reader(csvfile)
        next(acreader, None) # Skip header row
        for row in acreader:
            if(len(row) >= 5):
                if relevant_transaction(row[3]):
                    # Transactions are for negative amounts, so record positive value instead.
                    loandict[get_loan_name(row[3])] -= float(row[4])
#               else:
#                   print("Skipped "+row[3])
        sortedloans = ((k, loandict[k]) for k in sorted(loandict, key=loandict.get, reverse=True))
        for k, v in sortedloans:
            if v > 0.01:  # Less than 1p still invested is likely just rounding errors.
                print("%s: £%.2f" % (k, v))
