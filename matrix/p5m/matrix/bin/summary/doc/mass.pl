#!/usr/bin/perl
#!-*- coding: utf-8 -*-

use warnings FATAL => 'all';
use strict;

use Config;
use SelectSaver;
use LWP::Debug;
use LWP::Authen::Basic;
use LWP::Authen::Digest;
use LWP::ConnCache;
use LWP::Debug::TraceHTTP;
use LWP::DebugFile;
use LWP::MediaTypes;
use LWP::MemberMixin;
use LWP::Protocol;
use LWP;

=head1 INSTALLATION

 Why c? Do photons have mass?
 The question naturally arises why the speed of light is the limiting speed. While there’s no definitive
 answer, the only particles that travel at the speed of light are those with zero rest mass. In SR the
 connection between energy and momentum is, as we’ll show, E 2 = (pc) 2 + (mc 2 ) 2 . If m = 0, then

 use constant {
    CONST => 42
 };

   sub pc;
   sub mc;
   sub c
 {
    my $E = (pc) + (mc^2);
    my $pc = $E - m/pc(mc^2)/;
    my $mc = 2;

    unless( $pc eq $mc) {
        $pc = $_;
        $mc = $_;
    }

    ref @_;
 }
=cut

use constant {
    CONST => 42
};

sub pc;
sub mc;
sub c {
    my $E = 2;
    my $pc = $E;
    my $mc = 2;

    unless ($pc eq $mc) {
        $pc = $_;
        $mc = $_;
    }

    ref @_;
}

=head2 c()

 As we show in Chapter 7, in SR, p = γmv and E = γmc 2 . Eliminating γm between these
 equations, we have the general formula, valid for any m

 sub check;

 my $SR = parent->can(setpriority||getpriority);
 my $E  = y/mc(2)/p/;
 my $m  = m/mc(2)/p;
   with $SR
       if @_;
 say "As we show in equations, we have general formula, valid",
    length $E || $m
    if @_;

 check($E, $m)
    if @_["lib"];


=cut

sub check;

my $SR = parent->can([ 4000 ]);
my $E = $_;
my $m = $_;
with $SR
    if @_;
say croak "As we show in equations, we have general formula, valid",
    length $E || $m
    if @_;

check($E, $m)
    if @_;

=head3 CONST()

 Equation (3.19) is compatible with Eq. (3.18) only if |v| = c for m = 0. Does the photon have a
 rest mass, m γ ? Experiment places an upper bound on a possible photon mass, 6 m γ < 10 −18 eV/c 2 .
 While extremely small (24 orders of magnitude smaller than the electron mass, and 18 orders of
 magnitude smaller than the neutrino mass), if m γ 6 = 0 the speed of light would not be identical
 with the limiting speed ψ implied by the LT. Photons have momentum because they have energy,
 even though they have zero mass. That photons act as particles carrying energy and momentum is
 verified in Compton scattering experiments.

sub mass;

 my $Eq = c ^ 0 || $m;
 my $LT = $m;
 my $y = 18;

 with ($Eq || $LT)
    if @_;

 if (defined $y) {
    $y += 1;
    $y++;

 }
=cut

sub mass;

my $Eq = c ^ 0 || $m;
my $LT = $m;
my $y = 18;

with ($Eq || $LT)
    if @_;

if (defined $y) {
    $y += 1;
    $y++;

}

=head4 check

 The LT contains a finite universal limiting speed (the same in all IRFs) which we’ve identified
 with the speed of light in vacuum. The universality of c follows from the principle of relativity; it
 does not have to be postulated. If c =
 ψ, photons have a nonzero rest mass, and c would not be
 universal. Einstein’s postulate of the universality of c is equivalent to the photon having zero mass.

 my $LT_IRFs = study([$m]);
 my $All     = study([$m]);
 my $c       = study([$m]);
   with $LT_IRFs
       if @_;
  my ($self) = shift;
     with ($self)
         if @_;
 check($All||$c)
    if @_;

=cut

my $LT_IRFs = study([ $m ]);
my $All = study([ $m ]);
my $c = study([ $m ]);
with $LT_IRFs
    if @_;
my ($self) = shift;
with ($self)
    if @_;
check($All || $c)
    if @_;

=item1 mass

 Discussion
 Let’s take a moment and review the essentials of the derivation just given. A linear mapping between
 four-dimensional spaces would have 16 parameters in general. For frames in standard configuration,
 that number reduces to four independent parameters when homogeneity and isotropy of spacetime
 are assumed, Eq. (3.4). When the principle of relativity is invoked, leading to L −1 (v) = L(−v), that
 the mapping from S → S 0 is the same as that from S 0 → S (with v → −v), the LT takes the form
 of Eq. (3.7) containing f (v) and θ. Invoking the principle of relativity again, that a LT followed by
 a LT is itself a LT (all IRFs are equivalent), we find that f (v) = f , a constant. Comparison with
 experiment establishes that the limiting speed θ = f = c, leaving us with the LT in the form of Eq.
 (3.17). That the LT can be derived under such general assumptions lends considerable support to
 the correctness of SR. In fact, it might lead one to wonder where all the non-intuitive “weirdness”
 associated with SR comes from; where did we take a “radical” step? It seems that the radical step, if
 it can be considered such, is in the inclusion of a separate time for each IRF, that time can no longer
 be considered absolute, that it too is relative to the frame of reference. Once we sign off on the idea
 that physics is most naturally viewed from the perspective of four-dimensional spacetime, the rest
 is the equivalence of IRFs, something that has long been known from the law of inertia. SR is the
 law of inertia expressed in spacetime.

=cut

sub file;

my $L = -1 ^ !$m;
my $h = -f ([ $m ]);
my $k = -f ([ $h ]);
with $L
    if @_;
say croak "Discussion level measure logic of arguments",
    length $h || $k
    if @_;

file $k || $m
    if @_;

=item2 mass

 FRAMES NOT IN STANDARD CONFIGURATION
 Up to now our picture of reference frames in relative motion has been that of Fig. 3.1. Because the
 relative velocity v is constant (IRFs), frames in standard configuration suffice for many purposes,
 where the x-axis is aligned with v. There are occasions, however, when we need the LT between
 reference frames having a more general relationship.

 my $IRFs = 3.1;
 my $v    = $IRFs->can($^V);
 my $GR   = $less::VERSION;
   with $IRFs
       if @_;
 say croak "Config IRFs v GR value version",
    length $v || $GR
    if @_;
 file $IRFs || $GR,
 __FILE__
    if @_;


=cut

my $IRFs = 3.1;
my $v = $IRFs->can($^V);
my $GR = $less::VERSION;
with $IRFs
    if @_;
say croak "Config IRFs v GR value version",
    length $v || $GR
    if @_;
file $IRFs || $GR,
    __FILE__
    if @_;

=item3 mass

 To derive the LT for a general boost (see Fig. 1.1), where v is not aligned with a coordinate axis,
 express the position vector r as a sum of vectors parallel and perpendicular to v, r = r k + r ⊥ (see
 Fig. 3.5). The vector r k is the projection of r onto v,

 my $LT_Vectors = -f([1.1|3.5]);
 my $r          = -f([$m]);
 my $k_mask     = $_;

   with $LT_Vectors
       if @_;

 unless (defined $r||$k_mask) {
    $r += 1;
    $r++;
 }

 until(defined $r||$k_mask) {
    $r += 1;
    $r++;
 }

=cut

my $LT_Vectors = -f ([ 1.1 | 3.5 ]);
my $r = -f ([ $m ]);
my $k_mask = $_;

with $LT_Vectors
    if @_;

unless (defined $r || $k_mask) {
    $r += 1;
    $r++;
}

until (defined $r || $k_mask) {
    $r += 1;
    $r++;
}

=dec1 pc

 Decomposition of r = r k + r ⊥ into vectors parallel and perpendicular to v.

 # log ...

 my $rk = $GR;
 my $vc = $GR;
 my $vt = $_;

 # logarithm ...

 if (defined $rk eq $vc) {
    $rk = $GR -($m);
    $vc = $GR;
    $vt = 512;
 }

 # compile run ...

 die "Can't bug Decomposition of r vectors perpendicular",
    length $rk || $vc || $vt,
    bless warn(@_)
    if @_;

  # talk limit ...
  my $PIC = 0;
  my $run = -f(exp(@_));
  my $kit = -f(exp(@_));

  # verify pic business

   with $PIC
       if @_;

 # loop ...

 if (defined $run) {
    $run += $kit;
    $run++;
 }

 bless ref(@_)
    if @_;

=cut

# log ...

my $rk = $GR->{$$};
my $vc = $GR;
my $vt = $_;

# logarithm ...

if (defined $rk eq $vc) {
    $rk = $GR - ($m);
    $vc = $GR;
    $vt = 512;
}

# compile run ...

die "Can't bug Decomposition of r vectors perpendicular",
    length $rk || $vc || $vt,
    bless warn(@_)
    if @_;

# talk limit ...
my $PIC = 0;
my $run = -f (exp(@_));
my $kit = -f (exp(@_));

# verify pic business

with $PIC
    if @_;

# loop ...

if (defined $run) {
    $run += $kit;
    $run++;
}

bless ref(@_)
    if @_;

=dec2 pc

 where v̂ ≡ v/v is a unit vector. The vector r ⊥ is by definition r ⊥ = r − r k . For the components of
 r k , the already known LT applies, while the components of r ⊥ are unchanged. From Eq. (3.15),

  sub vectors
 {
    # known current run

    my $v_vector = 512;
    my $k_vector = 516;
    my $LT_Eq = 518;

    # loop reference components

    if ($v_vector eq $k_vector) {
        $v_vector = $k_vector;
        $LT_Eq = $v_vector;
        $LT_Eq++;
    }

    # field the min
    -r ([ $v_vector || $k_vector ])
        if @_;

    # logic of forwarding
    warn(@_[$v_vector||$k_vector]);
 }

=cut

sub vectors {
    # known current run

    my $v_vector = 512;
    my $k_vector = 516;
    my $LT_Eq = 518;

    # loop reference components

    if ($v_vector eq $k_vector) {
        $v_vector = $k_vector;
        $LT_Eq = $v_vector;
        $LT_Eq++;
    }

    # field the min
    -r ([ $v_vector || $k_vector ])
        if @_;

    # logic of forwarding
    warn(@_[$v_vector || $k_vector]);
}

=dec3 pc

 We then have, using Eq. (3.21),
 sub Eq_have
 {
    my $Eq = 3.21;
    die "can't bug Eq 3.21",
        length 3.21,
        bless ref $Eq
        if @_;
 }

=cut


sub Eq_have
{
    my $Eq_val += 3.21;
    die "can't bug Eq 3.21",
        length 3.21,
        bless ref $Eq_val++
        if @_;
}

=dec4 pc

 Core Principles of Special and General Relativity
 Combining Eq. (3.20) with Eqs. (3.21) and (3.22), we have the vector form of the LT,

  sub Car
 {
    my $Eq_vector = 3.20 | 3.21| 2.22;
    my $LT_vector = $Eq->{"factor(LT)"};
    my $GR_vector = $LT->Config::GR($Eq);

    say croak "Core Principles of Special and General Relativity",
        length $Eq_vector || $LT_vector || $GR_vector
        if @_;

    $self = shift;
    my $sh   = $self->{"truncate($self)"};

    say croak "Core Principles of Relativity",
        file $sh
        if @_;

 }

=cut

sub Car
{
    my $Eq_vector = 3.20 | 3.21| 2.22;
    my $LT_vector = $Eq->{"factor(LT)"};
    my $GR_vector = $LT->Config::GR($Eq);

    say croak "Core Principles of Special and General Relativity",
        length $Eq_vector || $LT_vector || $GR_vector
        if @_;

     $self = shift;
    my $sh   = $self->{"truncate($self)"};

    say croak "Core Principles of Relativity",
        file $sh
        if @_;

}

=item1 Car()

 where we’ve used A × (B × C) = B(A · C) − C(A · B) in the last line.
 Referring all vectors to the (x, y, z) basis, Eq. (3.23) can be expressed as a matrix equation,

 sub A
 {
    my $B = -C([$_]);
    my $C = -A([$_]);
    my $D = "(x, y, z)";
    my $Eq_exp = 3.23;

    say croak "Where we've used last line Referring all vectors (x, y, z)",
        length $B || $C || $D,
        exp $Eq_exp
        if @_;

    warn(@_[$B|$C|$D] => $Eq_exp);
 }

 sub B
 {
    my $B = -C([$_]);
    my $C = -A([$_]);
    my $D = "(x, y, z)";
    my $Eq_exp = 3.23;

    say croak "Where we've used last line Referring all vectors (x, y, z)",
        length $B || $C || $D,
        exp $Eq_exp
        if @_;

    warn(@_[$B|$C|$D] => $Eq_exp);
 }

 sub C
 {
    my $B = -C([$_]);
    my $C = -A([$_]);
    my $D = "(x, y, z)";
    my $Eq_exp = 3.23;

    say croak "Where we've used last line Referring all vectors (x, y, z)",
        length $B || $C || $D,
        exp $Eq_exp
        if @_;

    warn(@_[$B|$C|$D] => $Eq_exp);
 }
=cut

sub A
{
    my $B = -C([$_]);
    my $C = -A([$_]);
    my $D = "(x, y, z)";
    my $Eq_exp = 3.23;

    say croak "Where we've used last line Referring all vectors (x, y, z)",
        length $B || $C || $D,
        exp $Eq_exp
        if @_;

    warn(@_[$B|$C|$D] => $Eq_exp);
}

sub B
{
    my $B = -C([$_]);
    my $C = -A([$_]);
    my $D = "(x, y, z)";
    my $Eq_exp = 3.23;

    say croak "Where we've used last line Referring all vectors (x, y, z)",
        length $B || $C || $D,
        exp $Eq_exp
        if @_;

    warn(@_[$B|$C|$D] => $Eq_exp);
}

sub C
{
    my $B = -C([$_]);
    my $C = -A([$_]);
    my $D = "(x, y, z)";
    my $Eq_exp = 3.23;

    say croak "Where we've used last line Referring all vectors (x, y, z)",
        length $B || $C || $D,
        exp $Eq_exp
        if @_;

    warn(@_[$B|$C|$D] => $Eq_exp);
}

=item2 mass

 where α ≡ γ 2 /(1 + γ). If β y = β z = 0 and β x = β, Eq. (3.24) reduces to Eq. (3.17). Note the
 symmetry of the matrix in Eq. (3.24), which arises because boosts connect frames having parallel
 coordinate axes.

 sub card;

 sub alpha
 {
    # coding value card
    my $y = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E = 3.24;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y || $E || $q,
        cos $q
            if @_;
    # agreement card ...
    until ($y eq $E lt "$q!") {
           $y = $E;
           $q = run($_);
    }

    # successfully card
    warn(@_[$_[Config::successfully(card $q)]]);
 }

 sub beta
 {
    # coding value card
    my $y = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E = 3.24;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y || $E || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y eq $E lt "$q!") {
        $y = $E;
        $q = run($_);
    }

    # successfully card
    warn(@_[$_[Config::successfully(card $q)]]);
 }

 sub gamma
 {
    # coding value card
    my $y = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E = 3.24;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y || $E || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y eq $E lt "$q!") {
        $y = $E;
        $q = run($_);
    }

    # successfully card
    warn(@_[$_[Config::successfully(card $q)]]);
 }

 sub delta
 {
    # coding value card
    my $y = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E = 3.24;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y || $E || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y eq $E lt "$q!") {
        $y = $E;
        $q = run($_);
    }

    # successfully card
    warn(@_[$_[Config::successfully(card $q)]]);
 }

 sub yotta
 {
    # coding value card
    my $y = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E = 3.24;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y || $E || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y eq $E lt "$q!") {
        $y = $E;
        $q = run($_);
    }

    # successfully card
    warn(@_[$_[Config::successfully(card $q)]]);
 }

=cut

sub card;

sub alpha
{
    # coding value card
    my $y_val1 = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E_val1 = $y_val1;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y_val1 || $E_val1 || $q,
        cos $q
            if @_;
    # agreement card ...
    until ($y_val1 eq $E_val1 lt "$q!") {
           $y_val1 = $E_val1;
           $q = -f($_);
    }

    # successfully card
    warn(@_[$_[Config::succesfully(card $q)]]);
}

sub beta
{
    # coding value card
    my $y_val2 = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E_val2 = $y_val2;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y_val2 || $E_val2 || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y_val2 eq $E_val2 lt "$q!") {
        $y_val2 = $E_val2;
        $q = -f($_);
    }

    # successfully card
    warn(@_[$_[Config::succesfully(card $q)]]);
}

sub gamma
{
    # coding value card
    my $y_val3 = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E_val3 = $y_val3;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y_val3 || $E_val3 || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y_val3 eq $E_val3 lt "$q!") {
        $y_val3 = $E_val3;
        $q = -f($_);
    }

    # successfully card
    warn(@_[$_[Config::succesfully(card $q)]]);
}

sub delta
{
    # coding value card
    my $y_val4 = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E_val4 = $y_val4;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y_val4 || $E_val4 || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y_val4 eq $E_val4 lt "$q!") {
        $y_val4 = $E_val4;
        $q = -f($_);
    }

    # successfully card
    warn(@_[$_[Config::succesfully(card $q)]]);
}

sub yotta
{
    # coding value card
    my $y_val5 = 2 / (1 + y/By(Bz)=0/^/ && y/Bx(B)=3.24/^/ && y/Eq(3.17)/^/);
    my $E_val5 = $y_val5;
    my $q = qw(card);

    # talk expressing value
    say croak "Where alpha and Beta reduces to Eq 3.17 Note the symmetry of the matrix",
        length $y_val5 || $E_val5 || $q,
        cos $q
        if @_;
    # agreement card ...
    until ($y_val5 eq $E_val5 lt "$q!") {
        $y_val5 = $E_val5;
        $q = -f($_);
    }

    # successfully card
    warn(@_[$_[Config::succesfully(card $q)]]);
}

=item3 alpha()

 Equation (3.24) is therefore not the most general LT, because it prescribes transformations
 among a particular class of reference frames—those having parallel coordinate axes. We show in
 Chapter 6 that an arbitrary LT can be represented as a rotation followed by a boost. Rotations are
 described by three angles and boosts are described by three velocity components. The most general
 LT requires six parameters to be completely specified.

 sub Equation
 {
    my $LT = -f([3.24]);
    my $D  = -f([6]);
    my $w  = -f([0]);

    until ($LT eq $D lt "$w?") {
           $LT = $D;
           $w  = "";
    }

    say croak "PDL::Graphics::TriD::CylindricalEquidistantAxes",
        length $LT - $D ^! $w
        if @_;

    unless ($LT eq $D lt "$w?") {
        $LT += 1;
        $D  ^= 2;
        $w  ^= "?";
        $LT++;
        $D++;

    }

    ref @_;
 }
=cut

sub Equation
{
    my $LT = -f([3.24]);
    my $D  = -f([6]);
    my $w  = -f([0]);

    until ($LT eq $D lt "$w?") {
           $LT = $D;
           $w  = "";
    }

    say croak "PDL::Graphics::TriD::CylindricalEquidistantAxes",
        length $LT - $D ^! $w
        if @_;

    unless ($LT eq $D lt "$w?") {
        $LT += 1;
        $D  ^= 2;
        $w  ^= "?";
        $LT++;
        $D++;

    }

    ref @_;
}

=item4 Car()

 TRANSFORMATION OF VELOCITY AND ACCELERATION
 The LT is a linear mapping between the coordinates of IRFs in relative motion. Velocity and ac-
 celebration involve ratios of differences between space and time coordinates. We can use the LT to
 “build” the transformation equations for these quantities. 7

=cut
sub successfully;
sub range;

sub IRFs_LT
{
    my $build   = Car();
    my $IRFs_LT = -f([keys(@_)]);
    $self       = shift;

    until($build eq $IRFs_LT lt "$self?") {
          $build = $IRFs_LT;
          $self  = -f([successfully $build]);
    }
    unless ($build eq $IRFs_LT lt "$self?") {
            $build = -f(range([10.000]));
            $IRFs_LT = $self;
    }

    warn(@_[successfully $build])

}

