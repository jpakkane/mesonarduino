project('arduino blink', 'c', 'cpp',
  default_options : ['buildtype=minsize',
                     'b_lto=true',
                     'cpp_rtti=false',
                     'cpp_eh_=none',
                     'c_std=gnu11',
                     'cpp_std=gnu++11',
                     'b_staticpic=false',
                     ],
  meson_version : '>=0.54.0',
  )

assert(meson.is_cross_build(), 'Arduino projects can only be built in a cross build environment.')

cross_variant = meson.get_external_property('variant')
avrdude_speed = meson.get_external_property('avrdude_speed')
avrdude_programmer = meson.get_external_property('avrdude_programmer')
requires_reset = meson.get_external_property('requires_reset', false)

dependencies = ['arduinocore', 'arduinocore-main']
deps = []
foreach dep : dependencies
  deps += dependency(dep)
endforeach

blink_cpp = custom_target(
  'blink.cpp',
  input: 'blink.ino',
  output: 'blink.cpp',
  command: [ 'tools/ino-to-cpp.sh', '@INPUT@' ],
  capture: true
)

exe = executable('blink', blink_cpp,
  dependencies : deps,
  link_args : '-lm')


strip = find_program('avr-strip')
stripped = custom_target('stripped',
  input : exe,
  output : 'blink.stripped',
  command: [strip, '@INPUT@', '-o', '@OUTPUT@']
)

if requires_reset
  avrdude = find_program('tools/avrdude-wrapper.sh')
else
  avrdude = find_program('avrdude')
endif
run_target('upload',
  command : [avrdude,
  '-v',
  '-p' + target_machine.cpu(), '-P' + get_option('port'),  '-c' + avrdude_programmer, '-b' + avrdude_speed,
  '-D', '-Uflash:w:@0@:e'.format(stripped.full_path())],
  depends : stripped
)
