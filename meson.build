project('arduino blink', 'c', 'cpp',
  default_options : ['buildtype=minsize',
                     'b_lto=true',
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


strip = find_program('avr-strip')
stripped = custom_target('stripped',
  input : exe,
  output : 'blink.stripped',
  command: [strip, '@INPUT@', '-o', '@OUTPUT@']
)

avrdude = find_program('avrdude')
run_target('upload',
  command : [avrdude,
  '-C/usr/share/arduino/hardware/tools/avrdude.conf',
  '-v', '-v', '-v', '-v',
  '-patmega328p', '-carduino', '-P/dev/ttyACM0', '-b115200',
  '-D', '-Uflash:w:@0@:e'.format(stripped.full_path())],
  depends : stripped
)
