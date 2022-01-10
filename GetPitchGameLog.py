import requests
import csv
import urllib
from bs4 import BeautifulSoup
import pandas as pd
from google.colab import files

url = 'https://baseballsavant.mlb.com/savant-player/579328?stats=gamelogs-r-pitching-mlb&season=2021'
r = requests.get(url)

HEADER = ['date', 'Home', 'Away', 'W', 'L', 'ERA', 'G', 'GS', 'SV', 'IP', 'H', 'R', 'ER', 'HR', 'BB', 'SO', 'WHIP']

soup = BeautifulSoup(r.text, 'html.parser')
game_logs_table=soup.find_all(id="gamelogs-mlb")
game_logs=game_logs_table[0].find_all('tr', class_='default-table-row')

with open('PitchGameLog.csv', 'w', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(HEADER)
    for log in game_logs:
      spans=log.find_all('span');\
      date=spans[0].text
      Home=spans[1].text
      Away=spans[2].text
      W=spans[3].text
      L=spans[4].text
      ERA=spans[5].text
      G=spans[6].text
      GS=spans[7].text
      SV=spans[8].text
      IP=spans[9].text
      H=spans[10].text
      R=spans[11].text
      ER=spans[12].text
      HR=spans[13].text
      BB=spans[14].text
      SO=spans[15].text
      WHIP=spans[16].text
      row = [date, Home, Away, W, L, ERA, G, GS, SV, IP, H, R, ER, HR, BB, SO, WHIP]
      writer.writerow(row)
df = pd.read_csv('PitchGameLog.csv')
print(df)
df.to_csv('PitchGameLog.csv',index=False)
files.download('PitchGameLog.csv')
