#!/usr/bin/python3
import sys
import praw

if len(sys.argv) >= 2 and sys.argv[1] == "config":
	print("graph_title Reddit Karma")
	print("graph_vlabel Karma")
	print("link_karma.label Link Karma")
	print("comment_karma.label Comment Karma")
else:
	elpasi = praw.Reddit("/u/elpasi Munin grapher").get_redditor("elpasi")
	print("link_karma.value {:d}".format(elpasi.link_karma))
	print("comment_karma.value {:d}".format(elpasi.comment_karma))
