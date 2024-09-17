package Package::Template::MultiArch::FilesAndDirs::Translate;

use strict;

use warnings;

use Env qw($CONFIGURE_PKGNAME); 

use Path::Class;

# debian: lists files with names matching configure_package* in the current directory and its subdirectories, prints their depth and paths, and then sorts them by depth.

sub _printf_find_depth_sorted_debian
{
    my $this = shift;
    
    return sprintf q{find . %s %s|sort -n}, join( ' ', @_ ), q{-printf "%d %p\n"};
}

# darwin: lists files with names matching configure_package* in the current directory and its subdirectories, prints their depth and paths, and then sorts them by depth.

sub _printf_find_depth_sorted_darwin
{
    my $this = shift;

    return q{find . -name 'configure_package*' -type f -exec sh -c 'for file; do echo "$(dirname "$file" | awk -F"/" "{print NF-1}") $file"; done' sh {} + | sort -n};
}

=head1 SYNOPSIS

    mue->ln( "FIND DEPTH darwin: ", Package::Template::MultiArch::Setup->_printf_find_depth_sorted_darwin( qw(-name 'configure_package*' -type f) ) );

    mue->ln( "FIND DEPTH debian: ", Package::Template::MultiArch::Setup->_printf_find_depth_sorted_debian( qw(-name 'configure_package*' -type f) ) );

    my $cmd = Package::Template::MultiArch::Setup->_printf_find_depth_sorted_darwin( qw(-name 'configure_package*' -type f) );

    print qx{$cmd |sort -r|perl -pe 's/^\d+\s//;'};

=cut

sub rename_depth_first_stepwise
{
    my $this = shift;

    my $options = {@_};
    
    my $sref = $options->{sref};
    
    my $dirpath = $options->{dirpath};

    my $findname = $options->{findname};

            

    my @result = ();

    while( my @entries = qx{find $dirpath -name '${findname}'} )
    {
        chomp( $_= $entries[0] );

        my $filepath = file( $_ );


        my @orig = $filepath->components;

        my @tmp = @orig;

        #eexamples/example1/source
            
        if( $sref->( $tmp[-1] ) )
        {
            my $to = file( @tmp );

            if( -d $to || -f $to )
            {
                warn "*WARN* Target $to already exists. Will not overwrite $to with $filepath.";
            }
            else
            {
                my $cmd = sprintf( "mv %s %s", file( @orig ), $to );

                warn $cmd;

                print qx{$cmd};
            }
        }
    }

    return;
}




1;

