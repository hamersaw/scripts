#!/bin/python3

import datetime
import os

def touch(filename):
    f = open(filename, "a")
    f.close()

# intiailize data directory
data_directory = os.getenv("HOME") + "/.local/share/hammer"
if not os.path.exists(data_directory):
    os.makedirs(data_directory)

# initialize task files
task_completed_file = data_directory + "/task.completed"
task_data_file = data_directory + "/task.data"

if not os.path.exists(task_completed_file):
    touch(task_completed_file)

if not os.path.exists(task_data_file):
    touch(task_data_file)

# initialize time files
time_completed_file = data_directory + "/time.completed"
time_data_file = data_directory + "/time.data"

if not os.path.exists(time_completed_file):
    touch(time_completed_file)

if not os.path.exists(time_data_file):
    touch(time_data_file)

# set timezone
timezone = datetime.timezone(datetime.timedelta(hours=-5))
