# https://mesonbuild.com/External-Project-module.html

project('uchardet', 'c', 'cpp')

cmake = import('cmake')

cpu = host_machine.cpu()
if cpu == 'amd64'
    arch = 'x86_64'
elif cpu == 'arm64'
    arch = 'arm64'
endif

options = cmake.subproject_options()
options.add_cmake_defines({
    'CMAKE_OSX_ARCHITECTURES': arch,
    'CMAKE_OSX_SYSROOT': meson.get_cross_property('cmake_osx_sysroot'),
    'CMAKE_BUILD_TYPE': 'Release',
    'BUILD_STATIC': false,
    # uchardet asks for a CMake older than 3.5, which CMake 4 no longer
    # takes ("Compatibility with CMake < 3.5 has been removed").
    'CMAKE_POLICY_VERSION_MINIMUM': '3.5',
})

uchardet = cmake.subproject('uchardet',
    options: options,
)

uchardet_dep = uchardet.dependency('libuchardet')
meson.override_dependency('uchardet', uchardet_dep)
