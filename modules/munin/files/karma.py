#!/usr/bin/python3
import sys, praw

if len(sys.argv) >= 2 and sys.argv[1] == "config":
	print("graph_category Web")
	print("graph_title Reddit Karma")
	print("graph_vlabel Karma")
	print("karma.label Karma")
else:
	elpasi = praw.Reddit("/u/elpasi Munin grapher").get_redditor("elpasi")
	print("karma.value {:d}".format((elpasi.link_karma+elpasi.comment_karma)))