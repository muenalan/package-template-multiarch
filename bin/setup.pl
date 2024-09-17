#!/usr/bin/perl

use lib qw(bin/lib/perl);

use Env qw($CONFIGURE_PKGNAME $DIRECTORY_PKG); 

use Path::Class;

use Package::Template::MultiArch::FilesAndDirs::Translate;

die 'Need env $CONFIGURE_PKGNAME' unless $CONFIGURE_PKGNAME;

die 'Need env $DIRECTORY_PKG' unless $DIRECTORY_PKG;


warn "Translate configure_package entries in DIRECTORY_PKG=$DIRECTORY_PKG";

Package::Template::MultiArch::FilesAndDirs::Translate->rename_depth_first_stepwise(

    findname => '*configure_package*',
    
    sref => sub { $_[0] =~ s/configure_package/$CONFIGURE_PKGNAME/ },
    
    dirpath => dir( $DIRECTORY_PKG ),

    );

exit;
