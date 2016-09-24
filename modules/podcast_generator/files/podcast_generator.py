#!/usr/bin/env python3

import argparse
import datetime
from feedgen.feed import FeedGenerator
import hashlib
import io
import os
import sys
import subprocess

class readable_dir(argparse.Action):
	def __call__(self, parser, namespace, values, option_string=None):
		if not os.path.isdir(values):
			raise argparse.ArgumentTypeError("%s is not a valid path." % values)
		if os.access(values, os.R_OK):
			setattr(namespace, self.dest, values)
		else:
			raise argparse.ArgumentTypeError("%s is not a readable directory." % values)

def typelookup(filename):
	# Official MIME type required.
	switcher = {
		"mp3": "audio/mpeg3"
	}
	extension = filename.split(".")[-1]
	if extension in switcher:
		return switcher[extension]
	else:
		return ""

def getmd5(filename):
	md5 = hashlib.md5()
	with open(filename, 'rb') as f:
		while True:
			data = f.read(65536)
			if not data:
				break
			md5.update(data)
	return md5.hexdigest()


def toseconds(timestring):
	multiplier = [3600, 60, 1]
	return sum([a*b for a,b in zip(multiplier, map(int,timestring.split(":")))])


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Generates a podcast XML file from a directory of media.")
	parser.add_argument("input_directory", help="Media location, output XML location.", action=readable_dir)
	parser.add_argument("url", help="URL to the directory provided in input_directory.")
	
	args = parser.parse_args()
	
	if not args.url.endswith("/"):
		args.url += "/"
	
	fg = FeedGenerator()
	fg.load_extension('podcast')
	fg.podcast.itunes_category('Technology')
	
	fg.id(args.url)
	fg.title("Simon's Custom Feed")
	fg.link(href=args.url)
	fg.logo("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Python-logo-notext.svg/480px-Python-logo-notext.svg.png")
	fg.subtitle("All the media that doesn't have an RSS feed, but I want in my player.")
	fg.language('en-GB')
	
	file_list = [f for f in os.listdir(args.input_directory) if (os.path.isfile(os.path.join(args.input_directory, f)) and not typelookup(f) == "")]
	
	# TODO: Theoretically, all file lengths could be fetched at once to save calling out multiple times.
	for f in file_list:
		fe = fg.add_entry()
		popen = subprocess.Popen(["ffmpeg", "-i", os.path.join(args.input_directory, f), "-f", "null", "-"], stdout = subprocess.DEVNULL, stderr = subprocess.PIPE)
		popen.wait()
		answer = toseconds(popen.stderr.readlines()[-2].decode("utf-8").split(" ")[1].split("=")[1].split(".")[0])
		#fe.id(args.url+f)
		fe.id(getmd5(os.path.join(args.input_directory, f)))
		fe.title(f)
		fe.enclosure(args.url+f, str(answer), typelookup(f))
		fe.pubdate(datetime.datetime.fromtimestamp(os.path.getmtime(os.path.join(args.input_directory, f))).replace(tzinfo=datetime.timezone.utc))
	
	print(fg.rss_str(pretty=True).decode("utf-8"))

