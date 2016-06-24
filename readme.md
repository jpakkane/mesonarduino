# Meson sample project for Arduino development

This repository contains the sample blink application for
Arduino. Compile it with the following commands.

    mkdir build
    meson --cross-file arduino_uno_cross.txt build
    cd build
    ninja

The result can be uploaded with the following command:

    ninja ardup

This command will rebuild the binary before uploading if it is out of
date.

# Porting to other Arduino models

This project hardcodes Arduino Uno. If you have a different model,
change the compiler specifications and flags in the cross file. There
does not seem to be a way to easily get these programmatically so you
have to copy them by hand from Arduino IDE invocations.

The code also assumes a Linux environment and that your Arduino is in
the serial port `/dev/ttyACM0`. If your setup is different, change the
program invocations to match.
