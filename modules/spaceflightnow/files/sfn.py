#!/usr/bin/python3
import icalendar, datetime, time, re, pytz
from urllib.request import urlopen
from bs4 import BeautifulSoup

def parse_with_formatters(to_parse: str, parser_dict, strptime_obj, default_value):
    result = default_value
    for fmt in parser_dict:
        try:
            result = parser_dict[fmt](strptime_obj.strptime(to_parse, fmt))
            return result[0], (False or result[1])
        except ValueError:
            pass
    print("Failed to parse: %s" % to_parse)
    return result, True


def struct_time_to_timedelta(input: (time.struct_time, bool)) -> (datetime.timedelta, bool):
    return datetime.timedelta(hours=input[0].tm_hour, minutes=input[0].tm_min, seconds=input[0].tm_sec), input[1]


# Collect all mission data from the SpaceFlightNow launch calendar page
page = urlopen('https://spaceflightnow.com/launch-schedule/').read()
relevant_elements = BeautifulSoup(page).findAll(class_=["datename", "missiondata", "missdescrip"])

# Formatting data required to parse the page
NOW = datetime.datetime.now()
TODAY = NOW.replace(hour=0, minute=0, second=0, microsecond=0)
VERSION = "1.1.0+"+NOW.strftime("%Y%m%d%H")
DATE_FORMATS = {"%B %d": (lambda x: (x.replace(year=datetime.date.today().year), False)),
                "%b. %d": (lambda x: (x.replace(year=datetime.date.today().year), False)),
                "%B": (lambda x: (x.replace(year=datetime.date.today().year, day=1), True))}
TIME_FORMATS = {"%H%M:%S": (lambda x: (x, False)), "%H%M": (lambda x: (x, False))}
CHEAT_MAPPINGS = {"tbd": datetime.datetime(1900, 1, 1), "early2016": datetime.datetime(2016, 1, 1),
                  "1stquarter": datetime.datetime(2016, 1, 1), "mid2016": datetime.datetime(2016, 6, 1),
                  "late2016": datetime.datetime(2016, 9, 1)}

# Because it will take three loops to collate a mission, the instantiation must be outside the loop.
this_mission = {}
all_launches = []
for element in relevant_elements:
    if "datename" in element["class"]:
        # This section contains the mission name and the launch date.
        this_mission["mission_name"] = element.findAll(class_="mission")[0].text
        launch_date = element.findAll(class_="launchdate")[0].text.replace("Sept", "Sep")
        this_mission["NET?"] = launch_date.startswith("NET ")
        if this_mission["NET?"]:
            launch_date = launch_date[4:]
        this_mission["launch_string"] = launch_date
        simplified_launch_date = launch_date.lower().translate({ord(i): None for i in ' -'})
        if simplified_launch_date in CHEAT_MAPPINGS:
            this_mission["launch_date"] = CHEAT_MAPPINGS[simplified_launch_date]
            this_mission["unknown_date"] = True
            print("Cheated - substituted %s for %s." % (launch_date, this_mission["launch_date"]))
        else:
            parsed_date = parse_with_formatters(launch_date, DATE_FORMATS, datetime.datetime, TODAY)
            this_mission["launch_date"] = parsed_date[0]
            this_mission["unknown_date"] = parsed_date[1]
        # If the mission's fuzzy date is before today, assume today.
        if this_mission["unknown_date"]:
            this_mission["launch_date"] = max(this_mission["launch_date"], TODAY)

    if "missiondata" in element["class"]:
        # This section contains the launch time or window.
        this_mission["launch_location"] = element.contents[3].strip()
        launchtime = element.contents[1].strip()
        this_mission["all_day"] = False
        if launchtime == "TBD":
            this_mission["window_start"] = datetime.timedelta()
            this_mission["all_day"] = True
            this_mission["unknown_time"] = True
        elif "-" in launchtime:
            # This will contain a launch window.
            match = re.search('([0-9:]+)-([0-9:]+) GMT', launchtime)
            this_mission["window_start"], this_mission["unknown_time"] = struct_time_to_timedelta(parse_with_formatters(match.group(1), TIME_FORMATS, time,
                                          datetime.datetime(1900, 1, 1).timetuple()))
            this_mission["window_end"], tmp_unknown_time = struct_time_to_timedelta(parse_with_formatters(match.group(2), TIME_FORMATS, time,
                                          datetime.datetime(1900, 1, 1).timetuple()))
            this_mission["unknown_time"] |= tmp_unknown_time
            # If the launch window straddles midnight, one day needs to be added.
            if this_mission["window_start"] > this_mission["window_end"]:
                this_mission["window_end"] += datetime.timedelta(days=1)
        else:
            # Only one time, no window.
            match = re.search('([0-9:]+) GMT', launchtime)
            this_mission["window_start"], this_mission["unknown_time"] = struct_time_to_timedelta(
                    parse_with_formatters(match.group(1), TIME_FORMATS, time,
                                          datetime.datetime(1900, 1, 1).timetuple()))
            this_mission["window_end"] = this_mission["window_start"]
    if "missdescrip" in element["class"]:
        # Remove the last update time from the end of the string.
        description = element.contents[0]
        last_square_bracket = description.rfind("[")
        if len(description) - last_square_bracket < 15:
            description = description[:last_square_bracket]
        this_mission["description"] = description.strip()
        all_launches.append(this_mission)
        this_mission = {}

cal = icalendar.Calendar()
cal.add("prodid", "-//Simon Hollingshead//Space Launch Calendar//EN")
cal.add("version", VERSION)
for launch in all_launches:
    event = icalendar.Event()

    prefix = ""
    if launch["NET?"]:
        prefix = "(No earlier than) "
    elif launch["unknown_date"]:
        prefix = "("+launch["launch_string"]+") "
    elif launch["unknown_time"]:
        prefix = "(Time TBC) "

    event.add('location', launch["launch_location"])
    event.add('summary', prefix+launch["mission_name"])
    event.add('description', launch["description"])

    if launch["all_day"]:
        event.add('dtstart', (launch["launch_date"].replace(tzinfo=pytz.utc)).date())
    else:
        event.add('dtstart', (launch["launch_date"].replace(tzinfo=pytz.utc))+launch["window_start"])
        event.add('dtend', (launch["launch_date"].replace(tzinfo=pytz.utc))+launch["window_end"])
    cal.add_component(event)
with open("/tmp/my.ics", "wb") as f:
    f.write(cal.to_ical())
    print("Saved version "+VERSION+".")