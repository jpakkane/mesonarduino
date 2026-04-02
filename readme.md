# Meson sample project for Arduino development

This repository contains the sample blink application for
Arduino. Compile it with the following commands.

    mkdir build
    meson setup --cross-file cross/arduino_uno.txt build
    cd build
    ninja

The result can be uploaded with the following command:

    ninja upload

This command will rebuild the binary before uploading if it is out of
date.

By default, 'ninja upload' will assume that your Arduino is connected
as '/dev/ttyACM0'. If your Arduino shows up as a different device,
you can override the default by setting the meson option 'port', i.e.

    meson --cross-file cross/arduino_uno.txt -Dport=/dev/arduino build

# Arduino AVR Core

The Arduino AVR core is built as a subproject using the Meson WrapDB
arduinocore-avr package.

The blink application uses the 'arduinocore' and 'arduinocore-main'
dependencies from the Arduino core.

The package also includes the EEPROM, HID, SoftwareSerial, SPI
and Wire libraries. For example, to use EEPROM in an application add
a dependency on 'arduinocore-eeprom'.

# Porting to other Arduino models

This project is currently ported to

    * Arduino Leonardo
    * Arduino Mega 2560
    * Arduino Micro
    * Arduino Uno
    * SparkFun Pro Micro

If you have a different model, add the compiler specifications and
flags to a new file in the cross/ subdirectory. There does not seem
to be a way to easily get these programmatically so you have to copy
them by hand from Arduino IDE invocations.
