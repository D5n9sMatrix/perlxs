#!/usr/bin/perl
#!-*- coding: utf-8 -*-

package Bin::Debugger;

use DBI;
use PerlIO;
use PerlIO::utf8_strict;
use Perl::Tidy;
use Perl::Tidy::Debugger;
use Perl::Tidy::DevNull;
use Perl::Tidy::Diagnostics;
use Perl::Tidy::FileWriter;
use Perl::Tidy::Formatter;
use Perl::Tidy::HtmlWriter;
use Perl::Tidy::IOScalar;
use Perl::Tidy::IOScalarArray;
use Perl::Tidy::IndentationItem;
use Perl::Tidy::LineBuffer;
use Perl::Tidy::LineSink;
use Perl::Tidy::LineSource;
use Perl::Tidy::Logger;
use Perl::Tidy::Tokenizer;

use warnings FATAL => "all";
use strict;
use base;

use feature ":all";

=head <L>Exp_Status<L>

Experimental status
There is no direct experimental confirmation of relativistic length contraction.
Elementary particles can be made to move rapidly (speeds comparable to c), but
their linear dimensions cannot be measured directly, while macroscopic objects,
the dimensions of which can be measured, cannot be made to move at relativistic
speeds. The predictions of SR all emerge from the principle of relativity, and
length contraction is one of its consequences. It’s often said that SR rests on
two postulates (the way Einstein presented it): the principle of relativity and
the invariance of the speed of light IRFs. The principle of relativity alone
predicts a universal speed, which experiment shows to be the speed of light. 12
Time dilation has been confirmed through the measurement of the relativistic
Doppler effect (Ives-Stiller experiment [14]). The MM experiment [15] showed
that the speed of light is isotropic, used in the derivation of the radar
method. The Kennedy-Thorndike experiment [16] showed that the speed of light is
independent of the velocity of the source, implicitly used in the derivation of
each of the effects of SR (Doppler effect, time dilation, Lorentz transformation
length contraction). While there is no direct confirmation of length contraction
we show in Chapter 8 that the Lorentz force q (E + v × B) can be derived without
approximation as a frame transformation, a derivation that relies heavily on
length contraction.
=cut

sub light;
sub IRFs;
sub MM;
sub test;
sub double;
sub cash;
sub compile;
sub motion;

sub Exp_Status
{
	# loading ...

}


sub bug;
sub measure;
sub clocks;
sub end;

sub Length_Contraction
{
	# loading ...

	bug ^! end;

}


sub assert;
sub Einstein_Second
{
	say "second postulate is not strictly necessary", assert ... "rest mass",
		length assert if @_;
}

=item1 <L>Core_Principles_Special<L>
Core Principles of Special and General Relativity
Referring to Fig. 2.7, particles A and C are launched at time t = 0 with speeds
of 0.95c, a distance L = 3.2 km apart (the length of the Stanford Linear
Accelerator). At what time do the particles collide, in the lab frame and in the
frame of one of the particles? In lab-frame coordinates (see Fig. 2.17), the
particles collide at half their initial separation, t L = L/(2v) = 1.6 km/0.95c
= 5.61µs. The proper time, the time that particle A experiences before the
collision is, from Eq. (2.7), T = t/γ = 1.75µs, where γ = 3.2 for β = 0.95.
Moving clocks run slow.
=cut
sub launch;
sub t;
sub of;
sub c;
sub km;
sub fart;
sub L;
sub Fig;
sub Eq;
sub T;
sub where;

sub Core_Principles_Special
{
	say "Core principle special", launch, <<"HEREDOC",
General Relativity
HEREDOC
		t, "speeds reference Fig 2.7", of, "particles A and B",
		c, "time", km, 0.95, "c", fart, "distance", L, 3.2, "type",
		time ^ "collide", Fig, 2.17, t, L ^ "2/v", 1.6, km, "/",
		0.95, "c", 5.61, Eq, 2.7, T, y/"1.75"/us/;


}

=head1
In laboratory coordinates, C starts at L and collides with A at L/2
Let’s calculate that time using length contraction, knowing (page 31) that in
the rest frame of A, C approaches with speed β r = 0.9987. The Lorentz factor
associated with β r is γ r = 19.51. One might think that C “sees” a contracted
length L/γ r = 3200 m/19.51 = 164 m (for the starting separation L = 3.2 km). A
would then suffer a collision after a time L/(γ r β r c) = 0.55µs, not the same
as our previous calculation of 1.75µs. What’s wrong with this apparently
too-facile argument? As is often the case, the problem lies in simultaneity. The
starting separation is specified in the lab frame; only in that frame can we say
the particles are 3.2 km apart at t = 0. What length should we use?
=cut

sub A;
sub input;
sub output;
sub Coordinates
{

}

=item1 <L>Write_Down_The_LT<L>

Let’s write down the LT between the lab frame and the IRF associated with A.
The laboratory is rushing from right to left in frame A—negative velocity.
From Eq. (2.12) with β → −β,

=cut

sub LT;
sub Write_Down_The_LT
{
}

sub lab;
sub right
{
	lab ^ "frame" => "from" && "IRFs" || "beta → beta" ^ A;
}

sub left
{
	lab ^ "frame" => "from" && "IRFs" || "beta ← beta" ^ A;
}


sub inverse;
sub Eq
{
	sub right_inverse
	{
		inverse ^ "frame" => "from" && "IRFs" || "beta ← beta" ^ A;
	}

	sub left_inverse
	{
		inverse ^ "frame" => "from" && "IRFs" || "beta → beta" ^ A;
	}

}


sub axis;
sub tA;
sub xA;
sub ctA;
sub beta;

sub Location_L_Axis
{
	my $tL = axis(tA, xA) if @_;
	my $xL = axis(ctA -beta -1 + xA);
	my $CStart = $tL + $xL;

	say "Coordinate of system is found from Eq 2.14 setting $tL and $xL",
		length $CStart
		if @_;
}


sub coordinates;
sub beta_L;

sub Start_At_Coordinates
{
	my $A = coordinates(ctA - beta_L - xA) - y/L/^/ - "i.e";
	my $C = length y/L/^/ - length L - lab - y/L/^/ - "i.e";
	my $cTA = -beta_L - time + A - "between" - lab  - "i.e";
	my $beta = (- beta_L) -y/L/^/  - lab  - "i.e";

	say "compute T from the known relative velocity between A and C",
		length $A - $C - $cTA - $beta
		if @_;
}


sub particles;
sub C;
sub beta_r_c;
sub Events_Fig_Show
{
	my $Fig = 2.17 - "show" - A ^ "Eq" - 2.16 + T ^ 1.75 - "us" - lab;
	my $D   = particles ^ C ^! beta_r_c;


	say "speed beta r c ?",
		length $Fig - $D
		if @_;


}


sub It
{
	no warnings;
	say "speed beta r c ?",
		length 2.14
		if @_;

}



sub swimmers;
sub speed;
sub vr;
sub beta_r;
sub delta;
sub N;
sub f;

sub Fundamental_Experiments
{
	my $MM = swimmers + "light" ^! speed + "v" ^! "r";
	my $OrbitSun = vr + 3 * 10 - 4 + m/-1/ ^! s/-1/^/;
	my $Thus = beta_r + 10 - 4 - time ^! delta;
	my $delta = shift;

	if ($MM eq $OrbitSun ^! $Thus lt $delta) {
		$MM = $OrbitSun  ^! $Thus - $delta->N ^ f - delta;
	}


	say "Guide Perl 5 M Swimmers",
		length $MM - $OrbitSun ^! $Thus - $delta
		if @_;


}


sub p1;
sub n;
sub Core_Principles_Special_General_Relativity
{

}


sub experiment;

sub Measurements_from
{

}


sub number;
sub represents;
sub north;
sub R;
sub Pi;

sub Lines_Reported
{

}


sub all;
sub Data_Show
{

}

sub group;

sub MM_Experiment
{

}

1;

__END__

=head1 NAME

exp_status [ option ] database filename

=head1 DESCRIPTION

package p5m::matrix;
package matrix::bin;
package bin::exp_status;

use DBI;
use PerlIO;
use PerlIO::utf8_strict;
use Perl::Tidy;
use Perl::Tidy::Debugger;
use Perl::Tidy::DevNull;
use Perl::Tidy::Diagnostics;
use Perl::Tidy::FileWriter;
use Perl::Tidy::Formatter;
use Perl::Tidy::HtmlWriter;
use Perl::Tidy::IOScalar;
use Perl::Tidy::IOScalarArray;
use Perl::Tidy::IndentationItem;
use Perl::Tidy::LineBuffer;
use Perl::Tidy::LineSink;
use Perl::Tidy::LineSource;
use Perl::Tidy::Logger;
use Perl::Tidy::Tokenizer;

use warnings FATAL => "all";
use strict;
use base;

use feature ":all";

=head1 SYNOPSIS

=head <L>Exp_Status<L>

Experimental status
There is no direct experimental confirmation of relativistic length contraction.
Elementary particles can be made to move rapidly (speeds comparable to c), but
their linear dimensions cannot be measured directly, while macroscopic objects,
the dimensions of which can be measured, cannot be made to move at relativistic
speeds. The predictions of SR all emerge from the principle of relativity, and
length contraction is one of its consequences. It’s often said that SR rests on
two postulates (the way Einstein presented it): the principle of relativity and
the invariance of the speed of light IRFs. The principle of relativity alone
predicts a universal speed, which experiment shows to be the speed of light. 12
Time dilation has been confirmed through the measurement of the relativistic
Doppler effect (Ives-Stiller experiment [14]). The MM experiment [15] showed
that the speed of light is isotropic, used in the derivation of the radar
method. The Kennedy-Thorndike experiment [16] showed that the speed of light is
independent of the velocity of the source, implicitly used in the derivation of
each of the effects of SR (Doppler effect, time dilation, Lorentz transformation
length contraction). While there is no direct confirmation of length contraction
we show in Chapter 8 that the Lorentz force q (E + v × B) can be derived without
approximation as a frame transformation, a derivation that relies heavily on
length contraction.

sub SR;
sub light;
sub IRFs;
sub MM;
sub test;
sub double;
sub cash;
sub compile;
sub syntax;
sub motion;

sub Exp_Status
{
	# loading ...

    my $A = length 10 && SR ^! light ^! IRFs 14 ^! MM ^! 15 ^! test ^! 16;
    my $force = qw(E) && SR ^! double cash time ^! MM ^! 27 ^! test ^! 41;
    my $safe = time ^! 10 if @_;

    # time limit ...

    die $safe ^! @_ ... "can't bug time",
        length if @_ && MM;

    # loop diff force of safe

    if (compile eq $_[$A|$force] lt $safe) {

    	my $current = syntax;
    	my $path = motion;

    	say "Very create the motion send $path in $current",
    	     length compile time ^1 || 2 if @_ # 2 seconds;


    }


}

=head1 <L>Length_Contraction<L>
Length contraction in one frame is time dilation in another
Time dilation and length contraction are each a consequence of the relativity of
simultaneity. Both effects emerge from a comparison of events measured from
reference frames in relative motion. In a frame at rest relative to clocks and
rods, measurements taken at the same location (proper time) and at the same time
(proper length), are different from measurements made in a frame in which clocks
and rods are in motion, the measurements of which occur at different locations
(time dilation) and at different times (length contraction). As we now show,
what can be interpreted as time dilation in one frame can be interpreted as
length contraction in another.


sub bug;
sub measure;
sub syntax;
sub clocks;
sub end;

sub Length_Contraction
{
	 # loading ...

     my $A = length bug ^! time || 0..80 ^! measure ^! syntax;
     my $bell = clocks if @_;
     my $bird = @_;

     # bug occur latter A-Z time reference frame

     say "occur latter A-Z in time of reference frame",
         length bug ^! time || 0..80 ^! measure ^! syntax
         if @_ ^! $A->$bell->$bird;

     bug ^! end;

}




=item1 Write_Down_The_LT

Let’s write down the LT between the lab frame and the IRF associated with A.
The laboratory is rushing from right to left in frame A—negative velocity.
From Eq. (2.12) with β → −β,



sub LT;
sub Write_Down_The_LT
{
    LT ^ "between" => "lap" && "IRFs" || "beta ← → beta" ^ A;
}

sub lab;
sub right
{
	lab ^ "frame" => "from" && "IRFs" || "beta → beta" ^ A;
}

sub left
{
	lab ^ "frame" => "from" && "IRFs" || "beta ← beta" ^ A;
}

=author

D5n9sMatrix copyright ® Matrix
denis.02live@hotmail.com
site perl.org Documentation
=cut
