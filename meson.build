project('arduino blink', 'c', 'cpp',
  default_options : ['buildtype=minsize'],
  )

ardu_src_dir = '/usr/share/arduino/hardware/arduino/cores/arduino/'

ardu_lib_files = [
  'wiring_shift.c',
  'wiring_analog.c',
  'WInterrupts.c',
  'avr-libc/realloc.c',
  'avr-libc/malloc.c',
  'wiring_digital.c',
  'wiring_pulse.c',
  'wiring.c',
  'HID.cpp',
  'new.cpp',
  'Tone.cpp',
  'main.cpp',
  'WString.cpp',
  'CDC.cpp',
  'HardwareSerial.cpp',
  'IPAddress.cpp',
  'Print.cpp',
  'WMath.cpp',
  'Stream.cpp',
  'USBCore.cpp'
]

ardu_src = []
foreach f : ardu_lib_files
  ardu_src += ardu_src_dir + f
endforeach

ardulib = static_library('ardulib',
  ardu_src)

exe = executable('blink', 'blink.cpp',
  link_with : ardulib)
  