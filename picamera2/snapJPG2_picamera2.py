#!/usr/bin/env python3

# snapJPG2.py  Takes single 320x240 resolution image
#              after 5 sec delay to set exposure
#              if argument - writes image to ./images/<arg>
#              otherwise writes image to ./images/capture_YYYYmmdd-HHMMSS.jpg
#              Uses picamera2 and libcamera for Bookworm (and Bullseye)
#              still_configuration() obsoleted, must call create_still_configuration()
#
# (transfer to Mac from Pi with scp *.jpg mac_user@10.0.0.mac_ip:/Users/mac_user/to_from_pi/)

from picamera2 import Picamera2
import libcamera                 # for transform vflip and hflip
from time import sleep
from datetime import datetime
import os
import sys

picam2 = Picamera2()

# default (full) resolution
# config = picam2.create_still_configuration()

# 320x240 resolution
# config = picam2.create_still_configuration(main={"size": (320, 240)})

# hflip and 320x240
# config = picam2.create_still_configuration(main={"size": (320, 240)},transform=libcamera.Transform(hflip=1))

# vflip and 320x240
# config = picam2.create_still_configuration(main={"size": (320, 240)},transform=libcamera.Transform(vflip=1))

# Robot Dave needs this one for camera with flat cable socket up
# vflip and hflip and 320x240
config = picam2.create_still_configuration(main={"size": (320, 240)},transform=libcamera.Transform(hflip=1,vflip=1))

picam2.configure(config)
picam2.start()

sleep(5) # 0.25 good light, 5.0 when dark - allow picam to adjust exposure
args = sys.argv[1:]

if ( len(args) > 0 ):
    fname = "images/"+args[0]
else:
    fname = "images/capture_"+datetime.now().strftime("%Y%m%d-%H%M%S")+".jpg"

if not os.path.exists('images'):
    os.makedirs('images')

# np_array = picam2.capture_array()
# print(np_array)

picam2.capture_file(fname)

print("Wrote image to {}".format(fname))

picam2.stop_()
