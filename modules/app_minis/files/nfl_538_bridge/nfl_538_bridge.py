#!/usr/bin/env python3

import gzip
import urllib.request
import xml.etree.ElementTree
from bs4 import BeautifulSoup


def calc_key(quarter, remaining_in_quarter):
    if quarter in ["P", "Suspended"]:
        return str((60 * 60) + 1)
    elif quarter == "H":
        return str(30 * 60)
    elif quarter in ["F","FO"]:
        return str((60 * 60) + 2)
    else:
        full_quarters = max((4 - int(quarter)) * (15 * 60), 0)
        current_quarter = sum(int(a) * b for a, b in zip(remaining_in_quarter.split(":"), [60, 1]))
        return str(full_quarters + current_quarter)


def fix_inits(team_initials):
    # Map NFL team initials onto FiveThirtyEight team initials.
    if team_initials == "WAS":
        return "WSH"
    else:
        return team_initials


if __name__ == '__main__':
    fivethirtyeight_html = gzip.decompress(
        urllib.request.urlopen("http://projects.fivethirtyeight.com/2016-nfl-predictions/").read())
    soup_fivethirtyeight_html = BeautifulSoup(fivethirtyeight_html, 'lxml')
    soup_fivethirtyeight_schedule_iterator = soup_fivethirtyeight_html.find("div", {"id": "schedule"}).children
    next(soup_fivethirtyeight_schedule_iterator)
    soup_fivethirtyeight_mobile_view = next(soup_fivethirtyeight_schedule_iterator).find_all("tr")
    expected_winners = {}
    for game in soup_fivethirtyeight_mobile_view[1:]:
        tds = game.find_all("td")
        team1 = tds[1].text
        team1_pct = tds[2].find("div", {"class": "prob"}).text
        team2_pct = tds[3].find("div", {"class": "prob"}).text
        team2 = tds[4].text
        if team1 < team2:
            expected_winners[team1 + "-" + team2] = team1_pct
        else:
            expected_winners[team2 + "-" + team1] = team2_pct

    nfl_xml = urllib.request.urlopen("http://www.nfl.com/liveupdate/scorestrip/ss.xml")
    games = xml.etree.ElementTree.parse(nfl_xml).getroot()

    game_dict = {}
    for game in games.iter("g"):
        game_dict[calc_key(game.attrib["q"], game.attrib.get("k", "0:00")) + "-" + game.attrib["gsis"]] = {
            "state": game.attrib["q"],
            "home_initials": fix_inits(game.attrib["h"]),
            "home_full": game.attrib["hnn"],
            "home_score": int(game.attrib["hs"]),
            "away_initials": fix_inits(game.attrib["v"]),
            "away_full": game.attrib["vnn"],
            "away_score": int(game.attrib["vs"]),
            "in_redzone": game.attrib["rz"],
            "remaining_in_quarter": game.attrib.get("k", ""),
            "possession_initials": fix_inits(game.attrib.get("p", ""))
        }

    games_in_order = sorted(game_dict.keys(), key=lambda x: (int(x.split("-")[0]), int(x.split("-")[1])))
    for ordered_game in games_in_order:
        this_game = game_dict[ordered_game]
        time_remaining = ""
        if this_game["state"] == "P":
            time_remaining = "PRE-GAME"
        elif this_game["state"] == "Suspended":
            time_remaining = "SUSPEND"
        elif this_game["state"] == "F":
            time_remaining = "FINAL"
        elif this_game["state"] == "FO":
            time_remaining = "FINAL+OT"
        elif this_game["state"] == "H":
            time_remaining = "HALF"
        else:
            time_remaining = "Q{0} {1}".format(this_game["state"], this_game["remaining_in_quarter"])

        home_ind = ""
        away_ind = ""
        if this_game["home_initials"] == this_game["possession_initials"]:
            home_ind = ">"
        elif this_game["away_initials"] == this_game["possession_initials"]:  # Sometimes no team is in possession.
            away_ind = "<"
        if this_game["in_redzone"] == "1":
            home_ind *= 2
            away_ind *= 2

        smaller_initals = min(this_game["home_initials"], this_game["away_initials"])
        larger_initals = max(this_game["home_initials"], this_game["away_initials"])

        if not smaller_initals + "-" + larger_initals in expected_winners:
                continue

        smaller_initials_win_chance = int(expected_winners[smaller_initals + "-" + larger_initals][:-1])
        expected_winner_string = "{: >3} ({: ^2}%){:}"
        expected_winner_string_1 = smaller_initals if smaller_initials_win_chance >= 50 else larger_initals
        expected_winner_string_2 = smaller_initials_win_chance if smaller_initials_win_chance >= 50 else 100 - smaller_initials_win_chance
        expected_winner_string_3 = ""

        if this_game["home_score"] > this_game["away_score"]:
            expected_winner_string_3 = " X" if this_game["home_initials"] != expected_winner_string_1 else ""
        elif this_game["away_score"] > this_game["home_score"]:
            expected_winner_string_3 = " X" if this_game["away_initials"] != expected_winner_string_1 else ""

        expected_winner_string = expected_winner_string.format(expected_winner_string_1, expected_winner_string_2, expected_winner_string_3)

        print("{: >8} | {: >2}{: >3} {: >3} - {: <3} {: <3}{: <2} | 538 Pred: {: <10}".format(time_remaining,
                                                                                                     home_ind,
                                                                                                     this_game[
                                                                                                         "home_initials"],
                                                                                                     this_game[
                                                                                                         "home_score"],
                                                                                                     this_game[
                                                                                                         "away_score"],
                                                                                                     this_game[
                                                                                                         "away_initials"],
                                                                                                     away_ind,
                                                                                                     expected_winner_string
                                                                                                     ))
