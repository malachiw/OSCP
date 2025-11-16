"""Extract a columns data from a Bloodhound CSV export. For example, use this to get all the
usernames.
Cypher
`match (u:User) return m

Export as csv

usernames = read_csv_column_csv_module("nodes.csv", "label")
"""

def read_csv_column_csv_module(filename, column_name):
    column_data = []
    with open(filename, 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile) # Reads rows as dictionaries with header keys
        for row in reader:
            if column_name in row:
                column_data.append(row[column_name])
            else:
                print(f"Warning: Column '{column_name}' not found in a row.")
    return column_data


def insert_usernames(names)
  with open("usernames.txt", "a") as f:
    for name in names:
      f.writelines(name+'\n')

def main(filename, label):
  names = read_csv_column_csv_module(filename, column_name="label")
  try:
    insert_usernames(names)
  except Exception as e:
    print(f" Something broke => {e}")
    
if __name__ == "__main__":
  
