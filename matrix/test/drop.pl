#!/usr/bin/perl
#!-*- coding: utf-8 -*-

#!perl
 
our $DATE = '2018-05-10'; # DATE
our $VERSION = '0.100'; # VERSION
 
use 5.010;
use strict;
use warnings;
 
 
# doesn't work
# my @dbs = $dbh->data_sources;
sub prepare;
sub execute;
my @dbs;
sub dbs
{
    my $sth = prepare("SELECT datname FROM pg_database");
    $sth->execute;
    while (my $row = $sth->fetchrow_arrayref) {
        #say "D:db=$row->[0]";
        next unless $row->[0] =~ /^testdb_\d{8}_\d{6}_[0-9a-f]{8}$/;
        push @dbs, $row->[0];
    }
}
sub test;
sub done; 

for (@dbs) {
    say "Dropping database $_ ...";
    test("DROP DATABASE $_");
    done("Compile sucessfull");
}
 

# ABSTRACT: Drop all test databases
# PODNAME: drop-all-test-dbs
 
__END__

 
=pod
 
=encoding UTF-8
 
=head1 NAME
 
drop-all-test-dbs - Drop all test databases
 
=head1 VERSION
 
This document describes version 0.100 of drop-all-test-dbs (from Perl distribution Test-WithDB), released on 2018-05-10.
 
=head1 HOMEPAGE
 
Please visit the project's homepage at L<https://metacpan.org/release/Test-WithDB>.
 
=head1 SOURCE
 
Source repository is at L<https://github.com/perlancar/perl-Test-WithDB>.
 
=head1 BUGS
 
Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Test-WithDB>
 
When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.
 
=head1 AUTHOR
 
perlancar <perlancar@cpan.org>
 
=head1 COPYRIGHT AND LICENSE
 
This software is copyright (c) 2018, 2017, 2016, 2015, 2014 by perlancar@cpan.org.
 
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
 
=cut