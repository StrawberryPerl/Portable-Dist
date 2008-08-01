#!/usr/bin/perl

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 14;
use Portable::Dist        ();
use File::Spec::Functions ':ALL';
use File::Remove          'clear';
use File::Copy::Recursive 'dircopy';
use File::Find::Rule      ();

# Preparation
my $source = catdir( 't', 'data' );
ok( -d $source, 'Found source directory' );
my $target = catdir( 't', 'perl' );
clear( $target );
dircopy( $source => $target );
ok( -d $target, 'Target directory does not exist' );

# Make sure everything in the copy is readonly
foreach my $file ( File::Find::Rule->file->in($target) ) {
	Win32::File::Object->new( $file, 1 )->readonly(1);
	ok(   -r $file, "$file is readable" );
	ok( ! -w $file, "$file is readonly" );
}





#####################################################################
# Create a Portable::Dist object on the target

my $dist = Portable::Dist->new( perl_root => $target );
isa_ok( $dist, 'Portable::Dist' );
is(
	$dist->perl_root,
	$target,
	'->perl_root ok',
);
is(
	$dist->perl_bin,
	catdir( $target, 'bin' ),
	'->perl_bin ok',
);
is(
	$dist->perl_lib,
	catdir( $target, 'lib' ),
	'->perl_lib ok',
);
is(
	$dist->perl_sitelib,
	catdir( $target, 'site', 'lib' ),
	'->perl_sitelib ok',
);
ok( -f $dist->pl2bat,          '->pl2bat ok'        );
ok( -f $dist->config_pm,       '->config_pm ok'     );
ok( -f $dist->cpan_config,     '->cpan_config ok'   );
ok( -f $dist->file_homedir,    '->file_homedir ok'  );
ok( ! -e $dist->minicpan_dir,  '->minicpan_dir ok'  );
ok( ! -e $dist->minicpan_conf, '->minicpan_conf ok' );





#####################################################################
# Execute and confirm modifications are ok

ok( $dist->run, '->run ok' );

# Was the minicpan config created
ok( -d $dist->minicpan_dir,  'Created minicpan_dir'  );
ok( -f $dist->minicpan_conf, 'Created minicpan_conf' );

# Are all the files still readonly
foreach my $method ( qw{
	pl2bat
	config_pm
	cpan_config
	file_homedir
	minicpan_conf
} ) {
	ok(   -r $dist->$method(), "$method is readable" );
	ok( ! -w $dist->$method(), "$method is readonly" );
}
