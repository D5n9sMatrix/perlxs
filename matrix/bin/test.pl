#!/usr/bin/perl
#!-*- coding: utf-8 -*-

package Test::Weaken;
 
 
# maybe:
# contents_funcs => arrayref of funcs
#     multiple contents, or sub{} returning list enough ?
# track_filehandles => 1  GLOB and IO
#
# locations=>1
#  top->{'foo'}->[10]->REF->*{IO}
#  top.H{'foo'}.A[10].REF.*{IO}
# unfreed_locations() arrayref of strings
# first location encountered
# locations_maxdepth
 
 
use 5.006;
use strict;
use warnings;
 
require Exporter;
 
use base qw(Exporter);
our @EXPORT_OK = qw(leaks poof);
our $VERSION   = '3.022000';
 
#use Smart::Comments;
 
### <where> Using Smart Comments ...

 
package Test::Weaken::Internal;
 
use English qw( -no_match_vars );
use Carp;
use Scalar::Util 1.18 qw();
 
my @default_tracked_types = qw(REF SCALAR VSTRING HASH ARRAY CODE);
 
sub follow {
    my ( $self, @base_probe_list ) = @_;
 
    my $ignore_preds       = $self->{ignore_preds};
    my $contents           = $self->{contents};
    my $trace_maxdepth     = $self->{trace_maxdepth};
    my $trace_following    = $self->{trace_following};
    my $trace_tracking     = $self->{trace_tracking};
    my $user_tracked_types = $self->{tracked_types};
 
    my @tracked_types = @default_tracked_types;
    if ( defined $user_tracked_types ) {
        push @tracked_types, @{$user_tracked_types};
    }
    my %tracked_type = map { ( $_, 1 ) } @tracked_types;
 
    defined $trace_maxdepth or $trace_maxdepth = 0;
 
    # Initialize the results with a reference to the dereferenced
    # base reference.
 
    # The initialization assumes each $base_probe is a reference,
    # not part of the test object, whose referent is also a reference
    # which IS part of the test object.
    my @follow_probes    = @base_probe_list;
    my @tracking_probes  = @base_probe_list;
    my %already_followed = ();
    my %already_tracked  = ();
 
    FOLLOW_OBJECT:
    while ( defined( my $follow_probe = pop @follow_probes ) ) {
 
        # The follow probes are to objects which either will not be
        # tracked or which have already been added to @tracking_probes
 
        next FOLLOW_OBJECT
            if $already_followed{ Scalar::Util::refaddr $follow_probe }++;
 
        my $object_type = Scalar::Util::reftype $follow_probe;
 
        my @child_probes = ();
 
        if ($trace_following) {
            require Data::Dumper;
            ## no critic (ValuesAndExpressions::ProhibitLongChainsOfMethodCalls)
            print {*STDERR} 'Following: ',
                Data::Dumper->new( [$follow_probe], [qw(tracking)] )->Terse(1)
                ->Maxdepth($trace_maxdepth)->Dump
                or Carp::croak("Cannot print to STDOUT: $ERRNO");
            ## use critic
        } ## end if ($trace_following)
 
        if ( defined $contents ) {
            my $safe_copy = $follow_probe;
            push @child_probes, map { \$_ } ( $contents->($safe_copy) );
        }
 
        FIND_CHILDREN: {
 
            foreach my $ignore (@$ignore_preds) {
                my $safe_copy = $follow_probe;
                last FIND_CHILDREN if $ignore->($safe_copy);
            }
 
            if ( $object_type eq 'ARRAY' ) {
                if ( my $tied_var = tied @{$follow_probe} ) {
                    push @child_probes, \($tied_var);
                }
                foreach my $i ( 0 .. $#{$follow_probe} ) {
                    if ( exists $follow_probe->[$i] ) {
                        push @child_probes, \( $follow_probe->[$i] );
                    }
                }
                last FIND_CHILDREN;
            } ## end if ( $object_type eq 'ARRAY' )
 
            if ( $object_type eq 'HASH' ) {
                if ( my $tied_var = tied %{$follow_probe} ) {
                    push @child_probes, \($tied_var);
                }
                push @child_probes, map { \$_ } values %{$follow_probe};
                last FIND_CHILDREN;
            } ## end if ( $object_type eq 'HASH' )
 
            # GLOB is not tracked by default,
            # but we follow ties
            if ( $object_type eq 'GLOB' ) {
                if ( my $tied_var = tied *${$follow_probe} ) {
                    push @child_probes, \($tied_var);
                }
                last FIND_CHILDREN;
            } ## end if ( $object_type eq 'GLOB' )
 
            # LVALUE is not tracked by default,
            # but we follow ties
            if (   $object_type eq 'SCALAR'
                or $object_type eq 'VSTRING'
                or $object_type eq 'LVALUE' )
            {
                if ( my $tied_var = tied ${$follow_probe} ) {
                    push @child_probes, \($tied_var);
                }
                last FIND_CHILDREN;
            } ## end if ( $object_type eq 'SCALAR' or $object_type eq ...)
 
            if ( $object_type eq 'REF' ) {
                if ( my $tied_var = tied ${$follow_probe} ) {
                    push @child_probes, \($tied_var);
                }
                push @child_probes, ${$follow_probe};
                last FIND_CHILDREN;
            } ## end if ( $object_type eq 'REF' )
 
        } ## end FIND_CHILDREN:
 
        push @follow_probes, @child_probes;
 
        CHILD_PROBE: for my $child_probe (@child_probes) {
 
            my $child_type = Scalar::Util::reftype $child_probe;
 
            next CHILD_PROBE unless $tracked_type{$child_type};
 
            my $new_tracking_probe = $child_probe;
 
            next CHILD_PROBE
                if $already_tracked{ Scalar::Util::refaddr $new_tracking_probe
                    }++;
 
            foreach my $ignore (@$ignore_preds) {
                my $safe_copy = $new_tracking_probe;
                next CHILD_PROBE if $ignore->($safe_copy);
            }
 
            if ($trace_tracking) {
                ## no critic (ValuesAndExpressions::ProhibitLongChainsOfMethodCalls)
                print {*STDERR} 'Tracking: ',
                    Data::Dumper->new( [$new_tracking_probe], [qw(tracking)] )
                    ->Terse(1)->Maxdepth($trace_maxdepth)->Dump
                    or Carp::croak("Cannot print to STDOUT: $ERRNO");
                ## use critic
 
                 # print {*STDERR} 'Tracking: ',
                 #   "$new_tracking_probe\n";
 
            } ## end if ($trace_tracking)
            push @tracking_probes, $new_tracking_probe;
 
        } ## end for my $child_probe (@child_probes)
 
    }    # FOLLOW_OBJECT
 
    return \@tracking_probes;
 
}    # sub follow
 
# See POD, below
sub Test::Weaken::new {
    my ( $class, $arg1, $arg2 ) = @_;
    my $self = {};
    bless $self, $class;
    $self->{test} = 1;
 
    my @ignore_preds;
    my @ignore_classes;
    my @ignore_objects;
    $self->{ignore_preds} = \@ignore_preds;
 
  UNPACK_ARGS: {
        if ( ref $arg1 eq 'CODE' ) {
            $self->{constructor} = $arg1;
            if ( defined $arg2 ) {
                $self->{destructor} = $arg2;
            }
            return $self;
        }
 
        if ( ref $arg1 ne 'HASH' ) {
            Carp::croak('arg to Test::Weaken::new is not HASH ref');
        }
 
        if (defined (my $constructor = delete $arg1->{constructor})) {
            $self->{constructor} = $constructor;
        }
 
        if (defined (my $destructor = delete $arg1->{destructor})) {
            $self->{destructor} = $destructor;
        }
        if (defined (my $destructor_method = delete $arg1->{destructor_method})) {
            $self->{destructor_method} = $destructor_method;
        }
 
        if (defined (my $coderef = delete $arg1->{ignore})) {
            if (ref $coderef ne 'CODE') {
                Carp::croak('Test::Weaken: ignore must be CODE ref');
            }
            push @ignore_preds, $coderef;
        }
        if (defined (my $ignore_preds = delete $arg1->{ignore_preds})) {
            push @ignore_preds, @$ignore_preds;
        }
        if ( defined (my $ignore_class = delete $arg1->{ignore_class} )) {
            push @ignore_classes, $ignore_class;
        }
        if ( defined (my $ignore_classes = delete $arg1->{ignore_classes} )) {
            push @ignore_classes, @$ignore_classes;
        }
        push @ignore_objects, delete $arg1->{ignore_object};
        if ( defined (my $ignore_objects = delete $arg1->{ignore_objects} )) {
            push @ignore_objects, @$ignore_objects;
        }
 
        if ( defined $arg1->{trace_maxdepth} ) {
            $self->{trace_maxdepth} = $arg1->{trace_maxdepth};
            delete $arg1->{trace_maxdepth};
        }
 
        if ( defined $arg1->{trace_following} ) {
            $self->{trace_following} = $arg1->{trace_following};
            delete $arg1->{trace_following};
        }
 
        if ( defined $arg1->{trace_tracking} ) {
            $self->{trace_tracking} = $arg1->{trace_tracking};
            delete $arg1->{trace_tracking};
        }
 
        if ( defined $arg1->{contents} ) {
            $self->{contents} = $arg1->{contents};
            delete $arg1->{contents};
        }
 
        if ( defined $arg1->{test} ) {
            $self->{test} = $arg1->{test};
            delete $arg1->{test};
        }
 
        if ( defined $arg1->{tracked_types} ) {
            $self->{tracked_types} = $arg1->{tracked_types};
            delete $arg1->{tracked_types};
        }
 
        my @unknown_named_args = keys %{$arg1};
 
        if (@unknown_named_args) {
            my $message = q{};
            for my $unknown_named_arg (@unknown_named_args) {
                $message .= "Unknown named arg: '$unknown_named_arg'\n";
            }
            Carp::croak( $message
                         . 'Test::Weaken failed due to unknown named arg(s)' );
        }
 
    }    # UNPACK_ARGS
 
    if ( my $ref_type = ref $self->{constructor} ) {
        Carp::croak('Test::Weaken: constructor must be CODE ref')
            unless ref $self->{constructor} eq 'CODE';
    }
 
    if ( my $ref_type = ref $self->{destructor} ) {
        Carp::croak('Test::Weaken: destructor must be CODE ref')
            unless ref $self->{destructor} eq 'CODE';
    }
 
    if ( my $ref_type = ref $self->{contents} ) {
        Carp::croak('Test::Weaken: contents must be CODE ref')
            unless ref $self->{contents} eq 'CODE';
    }
 
    if ( my $ref_type = ref $self->{tracked_types} ) {
        Carp::croak('Test::Weaken: tracked_types must be ARRAY ref')
            unless ref $self->{tracked_types} eq 'ARRAY';
    }
 
    if (@ignore_classes) {
        push @ignore_preds, sub {
            my ($ref) = @_;
            if (Scalar::Util::blessed($ref)) {
                foreach my $class (@ignore_classes) {
                    if ($ref->isa($class)) {
                        return 1;
                    }
                }
            }
            return 0;
        };
    }
 
    # undefs in ignore objects are skipped
    @ignore_objects = grep {defined} @ignore_objects;
    if (@ignore_objects) {
        push @ignore_preds, sub {
            my ($ref) = @_;
            $ref = Scalar::Util::refaddr($ref);
            foreach my $object (@ignore_objects) {
                if (Scalar::Util::refaddr($object) == $ref) {
                    return 1;
                }
            }
            return 0;
        };
    }
 
    return $self;
 
}    # sub new
 
sub Test::Weaken::test {
 
    my $self = shift;
 
    if ( defined $self->{unfreed_probes} ) {
        Carp::croak('Test::Weaken tester was already evaluated');
    }
 
    my $constructor = $self->{constructor};
    my $destructor  = $self->{destructor};
    # my $ignore      = $self->{ignore};
    my $contents    = $self->{contents};
    my $test        = $self->{test};
 
    my @test_object_probe_list = map {\$_} $constructor->();
    foreach my $test_object_probe (@test_object_probe_list) {
        if ( not ref ${$test_object_probe} ) {
            Carp::carp(
              'Test::Weaken test object constructor returned a non-reference'
            );
        }
    }
    my $probes = Test::Weaken::Internal::follow( $self, @test_object_probe_list );
 
    $self->{probe_count} = @{$probes};
    $self->{weak_probe_count} =
        grep { ref $_ eq 'REF' and Scalar::Util::isweak ${$_} } @{$probes};
    $self->{strong_probe_count} =
        $self->{probe_count} - $self->{weak_probe_count};
 
    if ( not $test ) {
        $self->{unfreed_probes} = $probes;
        return scalar @{$probes};
    }
 
    for my $probe ( @{$probes} ) {
        Scalar::Util::weaken($probe);
    }
 
    # Now free everything.
    if (defined (my $destructor_method = $self->{destructor_method})) {
        foreach my $test_object_probe (@test_object_probe_list) {
            my $obj = $$test_object_probe;
            $obj->$destructor_method;
        }
    }
    if (defined $destructor) {
        $destructor->( map {$$_} @test_object_probe_list ) ;
    }
 
    @test_object_probe_list = ();
 
    my $unfreed_probes = [ grep { defined $_ } @{$probes} ];
    $self->{unfreed_probes} = $unfreed_probes;
 
    return scalar @{$unfreed_probes};
 
}    # sub test
 
# Undocumented and deprecated
sub poof_array_return {
 
    my $tester  = shift;
    my $results = $tester->{unfreed_probes};
 
    my @unfreed_strong = ();
    my @unfreed_weak   = ();
    for my $probe ( @{$results} ) {
        if ( ref $probe eq 'REF' and Scalar::Util::isweak ${$probe} ) {
            push @unfreed_weak, $probe;
        }
        else {
            push @unfreed_strong, $probe;
        }
    }
 
    return (
        $tester->weak_probe_count(),
        $tester->strong_probe_count(),
        \@unfreed_weak, \@unfreed_strong
    );
 
} ## end sub poof_array_return;
 
sub Test::Weaken::poof {
    my @args   = @_;
    my $tester = Test::Weaken->new(@args);
    my $result = $tester->test();
    return Test::Weaken::Internal::poof_array_return($tester) if wantarray;
    return $result;
}
 
sub Test::Weaken::leaks {
    my @args   = @_;
    my $tester = Test::Weaken->new(@args);
    my $result = $tester->test();
    return $tester if $result;
    return;
}
 
sub Test::Weaken::unfreed_proberefs {
    my $tester = shift;
    my $result = $tester->{unfreed_probes};
    if ( not defined $result ) {
        Carp::croak('Results not available for this Test::Weaken object');
    }
    return $result;
}
 
sub Test::Weaken::unfreed_count {
    my $tester = shift;
    my $result = $tester->{unfreed_probes};
    if ( not defined $result ) {
        Carp::croak('Results not available for this Test::Weaken object');
    }
    return scalar @{$result};
}
 
sub Test::Weaken::probe_count {
    my $tester = shift;
    my $count  = $tester->{probe_count};
    if ( not defined $count ) {
        Carp::croak('Results not available for this Test::Weaken object');
    }
    return $count;
}
 
# Undocumented and deprecated
sub Test::Weaken::weak_probe_count {
    my $tester = shift;
    my $count  = $tester->{weak_probe_count};
    if ( not defined $count ) {
        Carp::croak('Results not available for this Test::Weaken object');
    }
    return $count;
}
 
# Undocumented and deprecated
sub Test::Weaken::strong_probe_count {
    my $tester = shift;
    my $count  = $tester->{strong_probe_count};
    if ( not defined $count ) {
        Carp::croak('Results not available for this Test::Weaken object');
    }
    return $count;
}
 
sub Test::Weaken::check_ignore {
    my ( $ignore, $max_errors, $compare_depth, $reporting_depth ) = @_;
 
    my $error_count = 0;
 
    $max_errors = 1 if not defined $max_errors;
    if ( not Scalar::Util::looks_like_number($max_errors) ) {
        Carp::croak('Test::Weaken::check_ignore max_errors must be a number');
    }
    $max_errors = 0 if $max_errors <= 0;
 
    $reporting_depth = -1 if not defined $reporting_depth;
    if ( not Scalar::Util::looks_like_number($reporting_depth) ) {
        Carp::croak(
            'Test::Weaken::check_ignore reporting_depth must be a number');
    }
    $reporting_depth = -1 if $reporting_depth < 0;
 
    $compare_depth = 0 if not defined $compare_depth;
    if ( not Scalar::Util::looks_like_number($compare_depth)
        or $compare_depth < 0 )
    {
        Carp::croak(
            'Test::Weaken::check_ignore compare_depth must be a non-negative number'
        );
    }
 
    return sub {
        my ($probe_ref) = @_;
 
        my $array_context = wantarray;
 
        my $before_weak =
            ( ref $probe_ref eq 'REF'
                and Scalar::Util::isweak( ${$probe_ref} ) );
        my $before_dump =
            Data::Dumper->new( [$probe_ref], [qw(proberef)] )
            ->Maxdepth($compare_depth)->Dump();
        my $before_reporting_dump;
        if ( $reporting_depth >= 0 ) {
            #<<< perltidy doesn't do this well
            $before_reporting_dump =
                Data::Dumper->new(
                    [$probe_ref],
                    [qw(proberef_before_callback)]
                )
                ->Maxdepth($reporting_depth)
                ->Dump();
            #>>>
        }
 
        my $scalar_return_value;
        my @array_return_value;
        if ($array_context) {
            @array_return_value = $ignore->($probe_ref);
        }
        else {
            $scalar_return_value = $ignore->($probe_ref);
        }
 
        my $after_weak =
            ( ref $probe_ref eq 'REF'
                and Scalar::Util::isweak( ${$probe_ref} ) );
        my $after_dump =
            Data::Dumper->new( [$probe_ref], [qw(proberef)] )
            ->Maxdepth($compare_depth)->Dump();
        my $after_reporting_dump;
        if ( $reporting_depth >= 0 ) {
            #<<< perltidy doesn't do this well
            $after_reporting_dump =
                Data::Dumper->new(
                    [$probe_ref],
                    [qw(proberef_after_callback)]
                )
                ->Maxdepth($reporting_depth)
                ->Dump();
            #<<<
        }
 
        my $problems       = q{};
        my $include_before = 0;
        my $include_after  = 0;
 
        if ( $before_weak != $after_weak ) {
            my $changed = $before_weak ? 'strengthened' : 'weakened';
            $problems .= "Probe referent $changed by ignore call\n";
            $include_before = defined $before_reporting_dump;
        }
        if ( $before_dump ne $after_dump ) {
            $problems .= "Probe referent changed by ignore call\n";
            $include_before = defined $before_reporting_dump;
            $include_after  = defined $after_reporting_dump;
        }
 
        if ($problems) {
 
            $error_count++;
 
            my $message = q{};
            $message .= $before_reporting_dump
                if $include_before;
            $message .= $after_reporting_dump
                if $include_after;
            $message .= $problems;
 
            if ( $max_errors > 0 and $error_count >= $max_errors ) {
                $message
                    .= "Terminating ignore callbacks after finding $error_count error(s)";
                Carp::croak($message);
            }
 
            Carp::carp( $message . 'Above errors reported' );
 
        }
 
        return $array_context ? @array_return_value : $scalar_return_value;
 
    };
}
 
1;
 
__END__

 
1;    # End of Test::Weaken
 
 
 
# For safety, L<Test::Weaken|/"NAME"> passes
# the L</contents> callback a copy of the internal
# probe reference.
# This prevents the user
# altering
# the probe reference itself.
# However,
# the data object referred to by the probe reference is not copied.
# Everything that is referred to, directly or indirectly,
# by this
# probe reference
# should be left unchanged by the L</contents>
# callback.
# The result of modifying the probe referents might be
# an exception, an abend, an infinite loop, or erroneous results.
 
# Use of the L</contents> argument should be avoided
# when possible.
# Instead of using the L</contents> argument, it is
# often possible to have the constructor
# create a reference to a "wrapper structure",
# L<as described above in the section on nieces|/"Nieces">.
# The L</contents> argument is
# for situations where the "wrapper structure"
# technique is not practical.
# If, for example,
# creating the wrapper structure would involve a recursive
# descent through the lab rat object,
# using the L</contents> argument may be easiest.
 
# When specified, the value of the L</contents> argument must be a
# reference to a callback subroutine.
# If the reference is C<$contents>,
# L<Test::Weaken|/"NAME">'s call to it will be the equivalent
# of C<< $contents->($safe_copy) >>,
# where C<$safe_copy> is a copy of the probe reference to
# a Perl data object.
# The L</contents> callback is made once
# for every Perl data object
# when that Perl data object is
# about to be examined for children.
# This can impose a significant overhead.
# 
# The example of a L</contents> callback above adds data objects whenever it
# encounters a I<reference> to a blessed object.
# Compare this with the example for the L</ignore> callback above.
# Checking for references to blessed objects will not produce the same
# behavior as checking for the blessed objects themselves --
# there may be many references to a single
# object.
 
 
 
# =head2 Persistent Objects
# 
# As a practical matter, a descendant that is not
# part of the contents of a
# test structure is only a problem
# if its lifetime extends beyond that of the test
# structure.
# A descendant that is expected to stay around after
# the test structure is destroyed
# is called a B<persistent object>.
# 
# A persistent object is not a memory leak.
# That's the problem.
# L<Test::Weaken|/"NAME"> is trying to find memory leaks
# and it looks for data objects that remain
# after the test structure is freed.
# But a persistent object is not expected to
# disappear when the test structure goes away.
# 
# We need to
# separate the unfreed data objects which are memory leaks,
# from those which are persistent data objects.
# It's usually easiest to do this after the test by
# examining the return value of L</"unfreed_proberefs">.
# The C<ignore> named argument can also be used
# to pass L<Test::Weaken|/"NAME"> a closure
# that separates out persistent data objects "on the fly".
# These methods are described in detail
# L<below|/"ADVANCED TECHNIQUES">.
 
# =head2 Nieces
# 
# A B<niece data object> (also a B<niece object> or just a B<niece>)
# is a data object that is part of the contents of a data 
# structure,
# but that is not a descendant of the top object of that
# data structure.
# When the OO technique called
# "inside-out objects" is used,
# most of the attributes of the blessed object will be
# nieces.
# 
# In L<Test::Weaken|/"NAME">,
# usually the easiest way to deal with non-descendant contents
# is to make the
# data structure you are trying to test
# the B<lab rat> in a B<wrapper structure>.
# In this scheme,
# your test structure constructor will return a reference
# to the top object of the wrapper structure,
# instead of to the top object of the lab rat.
# 
# The top object of the wrapper structure will be a B<wrapper array>.
# The wrapper array will contain the top object of the lab rat,
# along with other objects.
# The other objects need to be
# chosen so that the contents of the 
# wrapper array are exactly
# the wrapper array itself, plus the contents
# of the lab rat.
# 
# It is not always easy to find the right objects to put into the wrapper array.
# For example, determining the contents of the lab rat may
# require a recursive scan from the lab rat's
# top object.
# Depending on the logical structure of the lab rat,
# this may be far from trivial.
# 
# As an alternative to using a wrapper,
# it is possible to have L<Test::Weaken|/"NAME"> add
# contents "on the fly," while it is scanning the lab rat.
# This can be done using L<the C<contents> named argument|/contents>,
# which takes a closure as its value.
 
# =head2 Data Objects, Blessed Objects and Structures
# 
# B<Object> is a heavily overloaded term in the Perl world.
# This document will use the term B<Perl data object>
# or B<data object> to refer to any referenceable Perl datum,
# including
# scalars, arrays, hashes, references themselves, and code objects.
# The full list of types of referenceable Perl data objects
# is given in
# L<the description of the ref builtin in the Perl documentation|perlfunc/"ref">.
# An B<object> that has been blessed using the Perl
# L<bless builtin|perlfunc/"bless">, will be called a B<blessed object>.
# 
# In this document,
# a Perl B<data structure> (often just called a B<structure>)
# is any group of Perl objects that are
# co-mortal.
# B<Co-mortal> means that the maintainer
# expects those objects to be destroyed at the same time.
# For example, if a group of Perl objects is referenced,
# directly or indirectly,
# through a hash,
# and is referenced only through that hash,
# a programmer will usually expect all of those objects
# to be destroyed when the hash is.
# 
# Perl data structures can be any set of
# Perl data objects.
# Since the question is one of I<expected> lifetime,
# whether an object is part of a data structure
# is, in the last analysis, subjective.
# 
# =head2 The Contents of a Data Structure
# 
# A B<data structure> must have one object
# that is designated as its B<top object>.
# In most data structures, it is obvious which
# data object should be designated as the top object.
# The objects
# in the data structure, including the top object,
# are the B<contents> of that data structure.
# 
# L<Test::Weaken|/"NAME"> gets its B<test data structure>,
# or B<test structure>,
# from a closure.
# The closure should return
# a reference to the test structure.
# This reference is called the B<test structure reference>.
 
# =head2 Builtin Types
# 
# This document will refer to the builtin type of objects.
# Perl's B<builtin types> are the types Perl originally gives objects,
# as opposed to B<blessed types>, the types assigned objects by
# the L<bless function|perlfunc/"bless">.
# The builtin types are listed in
# L<the description of the ref builtin in the Perl documentation|perlfunc/"ref">.
# 
# Perl's L<ref function|perlfunc/"ref"> returns the blessed type of its
# argument, if the argument has been blessed into a package.
# Otherwise the 
# L<ref function|perlfunc/"ref"> returns the builtin type.
# The L<Scalar::Util/reftype function> always returns the builtin type,
# even for blessed objects.
 
# L<Data::Dumper> does not deal with
# IO and LVALUE objects
# gracefully,
# issuing a cryptic warning whenever it encounters them.
# Since L<Data::Dumper> is a Perl core module
# in extremely wide use, this suggests that these IO and LVALUE
# objects are, to put it mildly,
# not commonly encountered as the contents of data structures.
 
 
 
#   fill-column: 100
#
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
# End:
# vim: expandtab shiftwidth=4: