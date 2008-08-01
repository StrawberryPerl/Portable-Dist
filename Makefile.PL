use inc::Module::Install 0.76;

all_from       'lib/Portable/Dist.pm';
requires       'Carp';
requires       'File::Spec'            => '0.80';
requires       'File::Slurp'           => '9999.13';
requires       'Tie::Slurp'            => '0.03';
requires       'Object::Tiny'          => '1.04';
requires       'Params::Util'          => '0.31';
requires       'Win32::File::Object'   => '0.01';
build_requires 'Test::More'            => '0.47';
build_requires 'File::Remove'          => '1.42';
build_requires 'File::Copy::Recursive' => '0.35';

WriteAll;
