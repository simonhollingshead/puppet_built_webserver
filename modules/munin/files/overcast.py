#!/usr/bin/python3
# encoding: utf-8

from urllib.request import urlopen,build_opener,HTTPCookieProcessor,Request
from urllib.parse import urlencode
from http import cookiejar
from bs4 import BeautifulSoup
from datetime import timedelta
import os, sys

if len(sys.argv) >= 2 and sys.argv[1] == "config":
	print("graph_category Web")
	print("graph_title Overcast")
	print("graph_vlabel Seconds")
	print("sec.label Seconds of unlistened podcasts")
	print("unk.label Podcasts with unknown length")
else:
    jar = cookiejar.CookieJar()
    opener = build_opener(HTTPCookieProcessor(jar))
    req = Request("https://overcast.fm/login",urlencode({"email":os.getenv('overcast_email'),"password":os.getenv('overcast_password')}).encode('utf-8'))
    
    response = opener.open(req)
    html = response.read()
    
    soup = BeautifulSoup(html, 'html.parser')
    failed = 0
    time_val = timedelta(seconds=0)
    for element in soup.find_all('a', class_="episodecell"):
            result = element.find_all('div', class_="caption2")[1].text
            if (" • " in result) and not (" at " in result):
                    time_val += timedelta(minutes=int(result.split("•")[1].strip().split(" ")[0]))
            else:
                    failed += 1
    
    print("sec.value %d" % time_val.total_seconds())
    print("unk.value %d" % failed)
