#!/bin/bash

# Script works on:
# - PiOS Bookworm 32-bit Desktop
# - PiOS Bookworm 64-bit Desktop


cd /home/pi
git clone http://www.github.com/DexterInd/GoPiGo3.git /home/pi/Dexter/GoPiGo3
sudo curl -kL dexterindustries.com/update_tools | bash -s -- --system-wide --use-python3-exe-too --install-deb-debs --install-python-package
sudo apt install -y --no-install-recommends python3-curtsies
git clone https://github.com/DexterInd/DI_Sensors.git /home/pi/Dexter/DI_Sensors

# === pigpiod
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master
make
sudo make install
cd ..
rm master.zip

git clone https://github.com/slowrunner/bookworm_test.git /home/pi/bookworm_test

sudo cp /home/pi/bookworm_test/setups/pigpiod.service /etc/systemd/system
sudo systemctl enable pigpiod.service
sudo systemctl start pigpiod.service
systemctl status pigpiod.service

# === setup RFR_Tools
sudo git clone https://github.com/DexterInd/RFR_Tools.git /home/pi/Dexter/lib/Dexter/RFR_Tools
sudo apt  install -y libffi-dev

cd /home/pi/Dexter/lib/Dexter//RFR_Tools/miscellaneous/

sudo mv di_i2c.py di_i2c.py.orig
sudo mv setup.py setup.py.orig
sudo cp ~/bookworm_test/i2c/di_i2c.py.bookworm di_i2c.py
sudo cp ~/bookworm_test/RFR_Tools/setup.py .
sudo python3 setup.py install

# === also depends on smbus-cffi

sudo pip3 install smbus-cffi --break-system-packages


# ==== GPG3_POWER SERVICE ===
cd ~
sudo cp /home/pi/Dexter/GoPiGo3/Install/gpg3_power.service /etc/systemd/system
sudo chmod 644 /etc/systemd/system/gpg3_power.service
sudo systemctl daemon-reload
sudo systemctl enable gpg3_power.service
sudo systemctl start gpg3_power.service
systemctl status gpg3_power.service


# ==== SETUP GoPiGo3 and DI_Sensors Python3 eggs
cd /home/pi/Dexter/GoPiGo3/Software/Python

sudo mv setup.py setup.py.orig
sudo cp ~/bookworm_test/GPG_Soft_Python/setup.py .
sudo python3 setup.py install

cd /home/pi/Dexter/DI_Sensors/Python/di_sensors
mv easy_distance_sensor.py easy_distance_sensor.py.orig
mv distance_sensor.py distance_sensor.py.orig
cp ~/bookworm_test/di_sensors/distance_sensor.py.bookworm distance_sensor.py
cp ~/bookworm_test/di_sensors/easy_distance_sensor.py.bookworm easy_distance_sensor.py
cd /home/pi/Dexter/DI_Sensors/Python
sudo python3 setup.py install

cd /home/pi/Dexter/GoPiGo3/Software/Python/Examples
sudo mv easy_Distance_Sensor.py easy_Distance_Sensor.py.orig
sudo cp ~/bookworm_test/Examples/easy_Distance_Sensor.py.bookworm easy_Distance_Sensor.py



# ==== Setup non-root access rules ====

sudo cp /home/pi/bookworm_test/setups/99-com.rules /etc/udev/rules.d

cp /home/pi/Dexter/GoPiGo3/Install/list_of_serial_numbers.pkl /home/pi/Dexter/.list_of_serial_numbers.pkl

# === ESPEAK-NG
sudo apt install -y espeak-ng
sudo pip3 install py-espeak-ng --break-system-packages
espeak-ng "Am I alive? Can you hear me?"

