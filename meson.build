project('arduino blink', 'c', 'cpp',
  default_options : ['buildtype=minsize',
                     'b_lto=true',
                     'cpp_rtti=false',
                     'cpp_eh_=none',
                     'c_std=gnu11',
                     'cpp_std=gnu++11',
                     'b_staticpic=false',
                     ],
  )

assert(meson.is_cross_build(), 'Arduino projects can only be built in a cross build environment.')

cross_variant = meson.get_cross_property('variant')

dependencies = [['arduinocore', 'arduinocore-avr'],
                ['arduinocore-main', 'arduinocore-avr']]
deps = []
foreach dep : dependencies
  deps += dependency('@0@-@1@'.format(dep[0], cross_variant), fallback : [dep[1], dep[0].underscorify() + '_dep'])
endforeach


exe = executable('blink', 'blink.cpp',
  dependencies : deps,
  link_args : '-lm')

objcopy = find_program('avr-objcopy')
avrdude = find_program('avrdude')

eep = custom_target('blink.eep',
  input : exe,
  output : 'blink.eep',
  command : [objcopy, '-O', 'ihex', '-j', '.eeprom',
    '--set-section-flags=.eeprom=alloc,load',
    '--no-change-warnings', '--change-section-lma',
    '.eeprom=0', '@INPUT@', '@OUTPUT@',
  ]
)

hex = custom_target('blink.hex',
  input : exe,
  output : 'blink.hex',
  command : [objcopy, '-O', 'ihex', '-R', '.eeprom',
    '@INPUT@', '@OUTPUT@',
  ],
  depends : eep,
)

run_target('upload',
  command : [avrdude,
  '-C/usr/share/arduino/hardware/tools/avrdude.conf',
  '-v', '-v', '-v', '-v',
  '-patmega328p', '-carduino', '-P/dev/ttyACM0', '-b115200',
  '-D', '-Uflash:w:@0@:i'.format(hex.full_path())],
  depends : hex,
)
