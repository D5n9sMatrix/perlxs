#!/usr/bin/perl
#!-*- coding: utf-8 -*-

package KFactor_::Doc;

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
use Perl::Tidy::Tokenizer;
use Perl::Tidy::VerticalAligner;
use Perl::Tidy::VerticalAligner::Alignment;
use Perl::Tidy::VerticalAligner::Line;
use AE;

use warnings FATAL => "all";
use base;

use strict;
use feature ":all";


=head1 Exercises()

EXERCISES

2.1 Derive Eq. (2.10) from Eq. (2.9) using Eq. (2.3) for each of the k-factors.
2.2 Derive Eq. (2.17). Use that β r = 2β/(1 + β 2 ).
2.3 The inverse of Eq. (2.12) is found by setting β → −β. Show that


1 β 1 −β
1 0 γ 2
. β 1
−β 1
0 1
2.4 Derive the k-factor from the Lorentz transformation. Referring to Fig. 2.20, 
a photon is emitted at time T and received in a frame moving away at time kT . 
The Lorentz transformation relates the coordinates assigned to the same event:


ct 1 β
kcT = γ
. x 
β 1
0
We’ve used the inverse transformation. The time t is the time T plus the time 
for the photon to travel the distance x, t = T + x/c. Show that k is given by 
Eq. (2.3).
ct kcT cT
x Figure 2.20
Derive the k-factor using the Lorentz transformation.
=cut

sub plume;
sub Fig;
sub fonts;
sub over;
sub doc;
sub table;
sub protected;
sub professional;
sub formatter;
 
sub Exercises
{

}

=head2 SR

Ng the Lorentz transformation.CHAPTER
3
Lorentz transformation, I
E provide a systematic derivation of the Lorentz transformation 1 (LT) and 
examine its kinematic consequences, what can be said without taking into
account the causes of motion. (Relativistic dynamics is taken up in Chapter 7.) 
We derive the LT first for frames in standard configuration (defined below) and 
then for frames not in standard configuration. Along the way, the velocity 
addition formula emerges as a bonus. We make two assumptions about space and 
time (appropriate for SR), that space is isotropic (all directions are 
equivalent) and that spacetime is homogeneous (no location or instant of time 
is preferred). 2 These concepts are distinct: Isotropy does not necessarily 
imply homogeneity, nor does homogeneity necessarily imply isotropy. One could 
have homogeneous, anisotropic spaces (a crystalline environment, for example, 
where one direction is preferred over the others), and one could have 
inhomogeneous, isotropic spaces (all spatial directions equivalent, yet a 
special location of the origin—a set of concentric spheres about a specified 
origin). Remarkably, these two assumptions together with the principle of 
relativity suffice to determine the LT.

=cut

sub sun;
sub develop;
sub trump;
sub def;
sub help;
sub args;
sub property;

sub SR
{
    my $LT = sun - develop trump ^ `` ^ `{5.4%}`;
    my $Eq = $LT->(help.args^"?");
    my $t  = property();
    
    
    `show group job: `,
     my $job = property();
     my $lpp = $t ^ $Eq.m/dialog/;
     my $pis = cos $lpp;
     
     say "har, har, har, former my har bible computing programming",
          $LT  | $Eq  | $t,
          $job | $lpp | $pis,
          if @_;

	$job = $lpp;

	$LT->((abs()));

    if ($LT eq $Eq) {
        $LT->$Eq.cut => "selector K-factor PDL time",
            length 2.14 * 10
            if @_;    	
    }
              
}

=head3 IRFs

FRAMES IN STANDARD CONFIGURATION
Let IRFs S and S 0 be in relative motion with velocity v. Whatever is the 
direction of v, it is by assumption constant (IRF); let v define the direction 
of the x-axis. The observers synchronize their clocks when the origins of their 
coordinate systems coincide, i.e., where and when they have a common spacetime 
origin. Frames in standard configuration move along their common x-axis with
their y and z-axes parallel, as shown in Fig. 3.1.

=cut

sub spacetime;
sub bread;
sub degree;
sub matrix;
sub network;
sub body;
sub pull;
sub compile;
sub test;

sub IRFs
{
	my $S    = (0..100);
	my $x    = 512;
	my $axis = $x->((sin()));
	my $dl   = bread((sin()));
    my $t    = test((cos()));
    my $d    = ((log()));
	say "Latter's A-Z common x-axis and z-axis coordinates long system",
	    length $S->$x.protected($axis|$dl)
	    if @_;
	    
   degree -27 - "ºc";
   
   my $C = network(matrix(PDL::all("connect")));
   my $D = exp 2.14 * 10 - body((exp()));
   my $R = sin 2.14 * 20 - body((sin()));
   
   
   unless ($C eq $D le $R - "connect!") {
   	    $C->$D = $R;
   }
   
   open($C eq $D le $R - "connect!") or
       die "can't error language computing connect a matrix";

   compile bless $C->$D => $R,
         if $t->$d;
}


=item1 FORM_GENERAL


General form of the Lorentz transformation
The LT, symbolized L(v), is a linear mapping between the spacetime coordinates 
assigned to events by different inertial observers. All inertial observers see 
straight worldliness for free particles, and straight lines are preserved under
homogeneous, linear mappings. 3 The most general linear homogeneous mapping 
between four-dimensional spaces has 16 parameters. For frames in standard 
configuration, that number can be reduced considerably by invoking homogeneity 
and isotropy. Write L(v) as a 4 × 4 matrix containing four unknown functions 
of v, α(v), δ(v), γ(v), η(v):

=cut

sub v;
sub alpha;
sub delta;
sub yotta;
sub neutron;

sub FORM_GENERAL
{
	my $LT     = (v) + 4 * 4;
	my $v      = alpha(v) + delta(v) + yotta(v) + neutron(v);
	my $matrix = $LT + $v;
	
	say "General Form Lorentz Transformation",
	    length $LT - $v, 
	    exp $matrix
	    if @_;
}


=item2 Eq

We’ve introduced in Eq. (3.1) an unknown parameter θ having the dimension 
of speed. We argued in Section 1.4 that the principle of relativity requires 
a universal speed, the same in all IRFs. 4 Let θ represent that speed; 
experiment will show that θ = c. We indicate mathematically that L is a mapping 
from the coordinates of S to those of S 0 with 50 the notation L : S → S 0 . 
That is, L associates an

 element of S with an element of S . Denote
 A B the matrix in Eq. (3.1) in block form:

. Block B = 0 because of isotropy: We’re free
C D
to orient the y and z-axes however we choose; the assignment of x 0 and t 0 can 
depend only on the relative speed and not on the orientation of y and z, 
otherwise clocks situated differently around the x-axis would show different 
times in violation of the assumption of isotropy. Block C = 0 because of 
homogeneity: The assignment of y 0 and z 0 can’t depend on the choice of 
spacetime origin. Block
D is diagonal because frames in standard configuration have parallel y and 
z-axes. The coefficients η(v) are the same for y and z because of isotropy; 
we’ll show that η(v) = 1. In block A there are functions α(v) and δ(v) in the 
equation for t 0 , but only one independent function γ(v) in the
equation for x 0 , because the location of x 0 = 0 (in S) is described 
by x = vt. 

=cut 

sub equation;
sub let;
sub block;

sub Eq
{
	my $B = 0;
	my $IRFs = equation(v) - let 0 - block $B;
	my $x = 0;
	my $t = 0;
	
	say "Let 0 equation next block z-axis and x-axis",
	    length $B - $IRFs - exp $x - $t
	    if @_;
	    
}

=item3 S_left

What if S 0 moves to the left?
We could equally well consider the motion of S 0 along the negative x-axis 
(Fig. 3.2), in which case

=cut

sub consider;
sub axis;

sub S_left
{
	my $Self = shift;
	my $S = $Self->consider((exp(1)));
	my $x = $Self->axis((exp(0)));
	my $B = $Self->let((exp(2)));

	if (@_) {
		say << "HEREDOC",
            What if S0 consider axis let 0
HEREDOC
			length $S - $x - exp $B
		;
	}
	    
    for $S ($x - $B){
    	$x = $B;
    	$x++;
    }	    
	 
}


=item4 S_along

Motion of S 0 along negative x-axis of S.
the LT would follow from Eq. (3.1) by letting t → t, x → −x, y → −y, z → z, 
t 0 → t 0 , x 0 → −x 0 , 3 That
is, lines that pass through the origin.
is because, as we’ll show, LTs have the property that a LT followed by a LT is 
itself a LT. 5 The level of mathematical maturity is only going to increase 
from here on. Don’t fight it; mathematics is in your future lighten.

=cut

sub ConfigIO;
sub IO;

sub S_along
{
	my $S    = 0;
	my $Self = $S;
	my $PIC  = $S;
	my $LT   = $S;
	
	say "Level only mathematics your lighten in path spacetime velocity",
	     length $S - $PIC - $LT
	     if @_;

	$Self->$LT($Self);
}

