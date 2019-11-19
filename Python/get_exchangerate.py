from urllib import request
import json
import sys
import ibm_db_dbi as db2

conn = db2.connect(dsn=None, user='user0500', password='user0500', database='*LOCAL', conn_options=None)
csr = conn.cursor()

date = None

if len(sys.argv) > 1:
  date = sys.argv[1]
else:
  date = 'latest'

# expecting url : https://api.exchangeratesapi.io/2010-01-12?base=USD
url = f'https://api.exchangeratesapi.io/{date}?base=USD'
print('Fetching data for ', url)
response = request.urlopen(url)
jsondata = response.read()

data = json.loads(jsondata)

date = data['date']
for k,v in data['rates'].items():
  print(date, k, v)
  csr.execute("insert into user05001.exrates values (?,?,?)",(date, k, v))

conn.commit()
