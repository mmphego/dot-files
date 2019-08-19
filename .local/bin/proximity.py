#!/usr/bin/python

import paho.mqtt.subscribe as subscribe
import subprocess
import time
import pynotify

mqtt_topic = 'work/proximity'
notified = False

def sendmessage(title, message):
    pynotify.init("Basic")
    notice = pynotify.Notification(title, message)
    notice.show()

while True:
    msg = subscribe.simple(mqtt_topic)
    value = float(msg.payload)
    if value == 0:
        if not notified:
            title = '...Seating...'
            message = 'Moving your desktop and windows over.'
            sendmessage(title, message)
            time.sleep(0.5)
            subprocess.call(["/home/mmphego/bin/seating"])
            notified = True
    else:
        if notified:
            title = '...Standing...'
            message = 'Moving your desktop and windows over.'
            sendmessage(title, message)
            time.sleep(0.5)
            subprocess.call(["/home/mmphego/bin/standing"])
            notified = False
    time.sleep(1)
