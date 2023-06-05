#!/usr/bin/perl
#!-*- coding: utf-8 -*-

package Bin::LorentzTransform;

use warnings FATAL => "all";
use strict;
use diagnostics;
use PerlIO;

use feature ":all";



sub fullbar;
sub observer;
sub fart;
sub FILENAME;
sub name;

sub loretz_transform 
{
	# loading ...
	
    my (%A, %B, $relative, %P, %t, %x) = shift;
    my $show = 512;
    my $beta = $B{fart} if scalar(0..80);
    my $time = $relative->fullbar($P{1});
    my $assy = $t{ 1 - 10 } + $x{1 / 10};
    
    # motion type send connect
    
    $_[1500] if 0;
    
    # Figure 2.8 Inertial observers A and B use the radar method to assign 
    # coordinates to the same event, (t, x) and (t 0 , x 0 ).
    # The emission and reception times in the two frames are naturally related 
    # through the k-factor: 
    
    if ($show){
    
        bless $_[0];
        	 
    	
    } 
    
         	
}
=head1 Eq
 Solve Eq. (2.11) for (t 0 , x 0 ):
=cut

sub Eq
{
	for my $t (0){
	    $t = 0;	
	}
}
=head1 <L><matrix></L> || <L>Eq_matrix</L>
 Using Eq. (2.3), we have the matrix equation (show this)
=cut

sub matrix;
sub Eq_matrix
{
	my $self = shift;
	my $this = matrix(@_) if $_[1];
	return $self->$this;
}

=item1 <L>Eq_A</L>
 the same as Eq. (A.6).
=cut

sub Eq_A
{
	my $A = 6;
}

=head1 Location 
Location of x 0 -axis: Lines of simultaneity
With the LT, we can find the location of the x 0 -axis—the spatial axis of S 
0 —in relation to the space and time axes of S. The t 0 -axis is the worldline 
seen in S, x = vt, or ct = β −1 x. The same result follows from Eq. (2.12) as 
the locus of points with x 0 = 0 (check it!). What about the x 0 - axis? Answer: 
The locus of points associated with t 0 = 0, which from Eq. (2.12) is ct = βx.
Figure 2.9 shows the x 0 and t 0 axes both situated at the angle φ with respect 
to the x, t axes, where tan φ = β. As β → 1, φ → π/4. The coordinates assigned 
to the same event in each reference
=cut

sub points;
sub ct;
sub pi;

sub Location
{
	# loading ...
	
	my $x = 0;
	my $LT = $x->{axis} if @_;
	my $t = 0;
	my $S = $x->{vt} || $x->{ct} -1;
	my $result = Eq.points; # (check it!)
	
	# loop cycles result lines x0 -axis 
	
	if ($x and $LT eq $S and $result lt "x0 -axis?") {
	    $x = 0 if -axis;
	    $t = 0 if Eq.ct();
	   
	}


return $x;

}

=head1 <C>Coordinates<C>
Figure 2.9 Coordinates assigned to the same event—the asterisk—in reference 
frames in relative motion with speed β: (t, x) and (t 0 , x 0 ). The t 0 and 
x 0 -axes form the same angle φ with respect to the t and x-axes, with tan 
φ = β.
=cut

sub Coordinates
{
	# loading ...
	my $t = $_;
	my $x = $t || $_ || $t || $_{0}; 
	my $B = $t || $x || $t || $_{0};
	
	return $B->$x||$t;
}

=head1 Frame
frame are found by projecting onto the respective space and time-axes, as shown. 
Knowing the x 0 -axis provides a way to test for the simultaneity of events 
(in S 0 ): If two events can be connected by a line parallel to the x 0 axis, 
they have the same time in that frame. Lines parallel to the x-axis are
lines of simultaneity. 5
=cut

sub Frame
{
	# loading ...
	
	my $vs = time;
	my $t = $_{0};
	
	my $x = 0;

	
}

=head1 Began
We began our discussion of spacetime diagrams by agreeing to take the time axis 
as orthogonal to the space of spatial variables. All IRFs are equivalent, yet 
the space and time axes of S 0 do not appear orthogonal in Fig. 2.9. We don’t 
know yet how to form the inner product of spacetime vectors. We’ll see that the 
t 0 and x 0 -axes are indeed orthogonal in S 0 .
=cut
sub IRFs;
sub Began
{
	my $All = IRFs.Eq;

    say "The $All Began our discussion of spacetime diagram by take"
        if @_;
        	
}

=head1 Speed
Example. Particle B moves away from A at speed β = 0.25, from left to right. 
What are the coordinates in the moving frame √ assigned to an event that in the 
rest frame occurs at ct = 2.25 and x = 1.5? For β = 0.25, γ = 4/ 15 = 1.03. Use 
the LT, Eq. (2.12):
=cut

sub left;
sub right;
sub Speed
{
	my $B = 0.25;
	my $A = $B->{frame};
	my $ct = 2.25;
	
	for $B (0.25){
	    my $All = Eq(2.12);
	    $B = 0.25;
	 
	    say "Speed coordinates moves away from left and right"
	        if @_;   	
	}
}

=head1 Coordinates_Show
These are the coordinates shown in Fig. 2.9. What if the speed is negative 
(particle moves from right to left)? Figure 2.10 shows the spacetime diagram 
for β = −0.25.
=cut

sub Coordinates_Show
{
	for my $B (-0.25) {
		$B += -0.25;
		$B++; 
	}
}

=item1 <L>diagram<L>
Figure 2.10 x x 0
Spacetime diagram for a particle moving with negative velocity, right to left.
=cut

sub diagram
{
	my $x = $_{0};
}

=item1 <L>lines<L>
5 Lines parallel to the t-axis are lines of co-locality; between timelike 
separated events one can always find a frame of reference where the events occur 
at the same location in space.
=cut

sub lines
{
	my $t = -axis;
}

=head1 Core_Principles
Core Principles of Special and General Relativity
Example. Relativity of causality
Spacelike-separated events can occur simultaneously or in either time order, 
depending on the reference frame (mentioned in Section 1.5). The left portion 
of Fig. 2.11 shows spacelike-separated events A and B as seen from a reference 
frame moving with speed β = 0.26 relative to the unprimed frame. A precedes B 
in both frames. In the right portion of Fig. 2.11 the same events occur in the 
opposite order in a frame moving with speed β = 0.71.
=cut

sub Core_Principles
{
	my $A = $_;
	my $B = 0.26 && 0.71;
	
	say "Core Principles of Special and General Relativity"
	    if @_;
	    
}

=head1
Time order of spacelike-separated events is reference-frame dependent.
=cut

sub spacelike_separeted
{
	my $A = $_;
	my $B = 0.26 && 0.71;
	
	ref $A || $B if @_; 
}

=item1 <L>LENGTH_CONTRACTION<L>
LENGTH CONTRACTION
We now discuss, from several points of view, length contraction, the converse 
of time dilation, a phenomenon students (and others) tend to find more confusing 
than time dilation.
=cut

sub Length_contraction
{
	my $self = @_;
	say "The discuss, from several points of view length contraction."
	    if $self; 
}

=head2 K_factor
Using the k-factor
A rod of rest length D moves along the x-axis with speed v from left to right. 
Figure 2.12 shows the worldlines of the front and back ends of the moving rod as 
B front and B back from the perspective of reference frame A. Clocks are 
synchronized when the front edge of the rod passes the origin, O.
You may find it helpful to visualize how you would use a radar gun to measure 
the distance to an approaching rod, traveling straight at you. As we now show, 
the length of the rod as measured in A is d = D/γ, the phenomenon of length 
contraction.
=cut

sub front;
sub back;
sub gun;
sub fart;

sub k_factor
{
	my $D = shift;
	my $x = $D;
	
	say "The phenomenon of length contraction measure gun.",
	    fart($x) 
	    if @_; 
}

=head1 fart_time
A emits a photon at time −d/c (negative time, relative to the origin O), which 
reflects from the back end of the rod, event E. The reflected photon arrives in 
A at time d/c. The coordinate of the back end of the rod is, from the radar 
method, d. In B the emitted photon passes the front end of the rod at point P 
in Fig. 2.12. It’s as if in frame B a photon was emitted from the front end of 
the rod toward the back end. Such a photon would have been emitted at time 
−d/(kc) in the B-frame. We’ve used that k(−v) = k −1 (v); the receiver (front 
end of the rod) is moving toward the source—negative speed. The reflected photon 
encounters B front at point Q in Fig. 2.12, which occurs at time kd/c (use the 
k-factor together with the time d/c in the A-frame). By the radar method, the
coordinates for event E in frame B are
=cut

sub end;
sub kc;
sub k;
sub v;
sub point;
sub Q;
sub kd;
sub c;

sub fart_time
{
	# loading ...
	
	my $All = 512;
	my $E = $_;
	my $D = $_;

    # verify the elements
    
       
    
    
    say "Coordinates of speed to compile portability info elements",
        |exp| time-> d / c
        if @_;	 
}

=item2 <L>motion_appear<L> 
Thus D = γd, or d = D/γ: Rods in motion appear shorter than the length measured 
in its rest frame. We’ll show in Chapter 4 that the relation is symmetrical: 
Both observers claim that a rod in motion has a length shorter than its rest 
length. The line labeled D in Fig. 2.12 is where the x 0 -axis in B intersects 
event E (a line of simultaneity). In both reference frames, the spatial 
coordinates of the two ends of the rod have been obtained at the same time.
=cut

sub event;

sub motion_appear
{
	my $D = $_;
	my $x = 0;

	
	say "Coordinates of the two of rod have been obtained at same time",
	   time && 0..80
	     if @_;
	
}

=head1 <L>length_contraction_input<L>
Length contraction. Rod of rest length D has length D/γ measured in A.
=cut

sub length_contraction_input
{
	my $D = $_;
	if ($D le $D && y/$A/^/ lt "$D/y"){
	    $D = y/$A/^/; 	
	}
}

=head1 <L>Lorentz_transformation_length<L>
Using the Lorentz transformation
Length contraction can be more readily demonstrated using the Lorentz 
transformation (LT). Figure 2.13 shows the worldlines of the front and back ends 
of the moving rod as B front and B back as seen in the frame of observer A. Both 
observers want to measure the length of the rod, and both are careful to measure 
the two ends of the rod at the same time in their reference frames. 6 But of 
course, what’s simultaneous in one frame is not in another. Observer B, at rest 
relative to the rod, measures ∆x 0 at t 0 = 0 as the rest length of the rod. 
Observer A records the locations of the two ends of the rod at time t, measuring 
the length as ∆x. The events used to measure length in frame A are not 
simultaneous in frame B, and vice versa; see Fig. 2.13. Referring to the events 
with ∆t = 0, we have from Eq. (2.12),
=cut

sub delta;
sub at;

sub Lorentz_transformation_length
{
	 my $LT = 2.13;
	 my $self = time || 0..80;
	 
	 say "length contraction measure frame vice and versa events delta",
	      $self->{$LT}
	      if @_;
}

=item2 <L>delta_length_contraction<L> 
Thus, ∆x 0 = γ∆x (length contraction) and c∆t 0 = −βγ∆x (relativity of 
simultaneity).
=cut

sub delta_length_contraction
{
	my $self = delta;
	my $D = $self->{length};
	
	say "The delta length contraction and relativity of simultaneity",
	    length 0
	    if @_; 
}

=head2 <L>Pole_and_Barn<L>
Pole and barn
A paradox is a conflict between reality and your feeling of what reality ought 
to be.
—Richard Feynman [13, p18-9]
=cut

sub Pole_and_Barn
{
    say "Pole and barn
         A paradox is a conflict between reality and your feeling of what 
         reality ought to be.
         —Richard Feynman [13, p18-9]
        ",
        length 512
        if @_;   	
}

=item3 <C>well_known<C>
One of the more well-known of the supposed paradoxes associated with SR is the 
pole and barn problem. In this thought experiment, a runner carries a pole that 
in its rest frame is 20 m long (a
=cut

sub pole;
sub barn;
sub compile;

sub well_known
{
	my $SR = pole;
	my $P = compile;
	
	say "The one of the more well-known of the supposed paradoxes associated",
	    $SR->{frame}
	    if @_;
}

=head3 <C>To_Measure_Length<C>
6 To measure the length of a stick moving past you, you wouldn’t first measure 
the location of one end of the stick, and
then only an hour later measure the location of the other end.
=cut

sub only;
sub handle;
sub separate;

sub To_Measure_Length
{
	my $self = length front;
	my $A = only;
	$_[$A] if 0;
	
	say "To measure the lenght of stick moving past you location info",
	    $self->$_, $A if 0;
	     
}

=over <L>Core_Principles_Special<L>
Core Principles of Special and General Relativity
=cut

sub Core_Principles_Special
{
	my $self = length front;
	my $A = only;

    $_[$A] if 0;	
}

=item1 <C>Length_Contraction_Compile<C>
Length contraction ∆x = ∆x 0 /γ where ∆x 0 is the proper length.
=cut

sub is;
sub count_net;
sub psiu;

sub Length_Contraction_Compile
{
	my $delta = $_;
	my $D = $_;
	my $proper = count_net;
	
	case($delta eq $D lt $proper) or
	   die "can't type case bug",
	   if @_;
	   	
    say "Length contraction delta compile where delta proper",
        if @_;	   
	     
}

=head1 <L>Long_Pole<L>
long pole!). The runner is headed 
√ toward a barn that in its rest frame is 10 m long. The speed of the runner is 
such that γ = 2 (β = 3/2). In the frame of the barn, the pole appears 10 m long 
because of relativistic length contraction. Thus, the pole fits entirely within 
the barn at one instant of time. In the frame of the pole, however, the barn 
appears 5 m long, and the pole cannot fit entirely within the barn. Can these 
descriptions be reconciled?
=cut

sub Long_Pole
{
	Frame is 10 && m/long/ && y/2 + 3/2/;
	barn  is 10 && m/long/ && y/2 + 3/2/;
	
	
	say "The long pole the runner is headed correct a barn frame 10",
	    if @_;
	    
}

=head2 <C>Couscous_Show_Events<C>
The left portion of Fig. 2.14 shows the events in the reference frame of the 
barn, with the pole approaching from left to right. We consider the front of the 
pole and the front of the barn to be on the right, with the back of the pole and 
the back of the barn to the left. The front of the pole first encounters the 
back of the barn. As the pole passes through the barn there is an instant of 
time when the pole fits entirely within the barn. These events are labeled in 
Fig. 2.14 as A (back of the pole encountering the back of the barn) and B 
(front of the pole encountering the front of the barn).
=cut

sub portion_magic;

sub Couscous_Show_Events
{
	my $left = portion_magic; # length barn
	my $self = $_;
	
	say "portion magic couscous a your honor mass public franchise cookies",
	    if @_;
}

=over <C>Same_Events<C>
The same events are shown in the reference frame of the pole in the right 
portion of Fig. 2.14. We can place the origin of spacetime coordinates wherever 
we want, but to use the LT formula the origins of the two systems of spacetime 
coordinates must coincide. 7 In both diagrams the origin is the event in which 
the front of the pole encounters the back of the barn. Events A and B (from the
left diagram) are shown in the right diagram as events A 0 and B 0 . The events 
are the same, but the coordinates assigned to them are different in the two 
frames.
=cut

sub Same_Events
{
	my $LT = 7 && back;
	my $A = 0..80;
	my $B = 2;

	
	say "Coordinates assigned to them different in frame 2.14 * 7",
	    if @_ && $A && $B ^ $LT ^ Couscous_Show_Events;
}

=head1 <C>Because<C>
7 Because
the Lorentz transformation is a linear, homogeneous coordinate transformation
.Length contraction 37 √ √ In the barn frame, A has coordinates (20/ 3, 0)
—the time to cover 10 m at speed β = 3/2. In the pole frame, the same event has 
coordinates
=cut

sub cover;
sub Because
{
    my $LT = length 37 && barn && Frame;
    my $left ^= $LT;
    my $S = m/speed/;
    my $beta = $left ^! Frame ^ Coordinates;
    

}

sub L;
sub hkl;
sub plane;

sub Length_Contraction_Compile_Minkowski
{
	my $self = length L ^ 0;
	my $beta = $self;
	my $B = $beta;
	
	say "Length of com plane kl L < L 0",
	    length L ^ $B;
}


sub Separation_Between_Atoms
{
	my $Atoms = plane;
	my $exist = $Atoms;
	
	say "Separation between atoms points ?",
	    length 2.16 ^! "atoms ?",
	    if $Atoms;
}


sub Worldtubes
{
	 for my $A (Frame) {
		 $A += 8;
		 $A++;
	}
}


sub Fig;
sub as;
sub QQ;

sub Core_Pricniples_Special_General_Relativity
{
	# loading ...
	
    my $P = Fig;
    my $Q = $P ^ $P;

    # next business PIC ... 
    while ($Q eq $P) {
    	$Q = QQ;
    	next PIC;
    } 	
}

=item2 <L>Minkowski<L>
Minkowski argued that the apparent deformation of a moving object can be 
understood as arising from a three-dimensional slice (surface of simultaneity) 
of a four-dimensional entity. The length depends on the intersection of the 
worldtube with an observer’s space—surface of simultaneity. The way the 
non-Euclidean geometry of spacetime works, the intersection with the rest-space 
of an observer produces the largest length. 10 By considering spacetime as a 
whole, by taking a geometric point of view, Minkowski found that the perplexing 
results of SR can be given an intelligible explanation. His most far-reaching 
conclusion is that observers in relative motion have different spaces as well as 
times. One must arrive at this conclusion if surfaces of simultaneity 
(observer-dependentslices) in a four-dimensional spacetime are three-dimensional 
spaces.
=cut

sub Minkowski
{
    my $A = length 10;	
}

=item3 <C>Usual_Length<C>
The usual length contraction hypothesis, according to Minkowski
. . . sounds extremely fantastical, for the contraction is not to be looked upon 
as a consequence of resistances in the ether, or anything of that kind, but 
simply as a gift from above—as an accompanying circumstance of the circumstance 
of motion.
=cut
sub motion;
sub typedef;

sub Usual_Length
{
	my $B = length Minkowski;
	my $test = $B;
	
	say "Usual length contraction hypothesis according to Minkowski",
	    $B ^ $test - Minkowski,
	    if @_ ^ 10; 
}

=over <L>Minkowski_held<L>
Minkowski held that the idea of a four-dimensional world explains the principle 
of relativity:
. . . the word relativity-postulate . . . seems to me very feeble. Since the 
postulate comes to mean that only the four-dimensional world of space and time 
is given by phenomena, but that the projection in space and in time may still be 
undertaken with a certain degree of freedom, I prefer to call it the postulate 
of the absolute world (or briefly, the worldpostulate).
=cut

sub idea;
sub relativity;
sub phenonmena;
sub worldpostulate;
sub it;
sub rota;

sub Minkowski_held
{
    my $A = idea;
    my $D = $A;
    my $briefly = psiu ^! 0;
 
    say "Minkowski held pull one zé butterfly raku",
        length 0 ^ $briefly - rota,
        if @_ ^! rota($A|$D);    
    
}

=head1 <L>Should_Then_World<L>
We should then have in the world no longer space, but an infinite number of 
spaces, analogously as there is in three-dimensional space an infinite number 
of planes. Threedimensional geometry becomes a chapter in four-dimensional 
physics.
=cut

sub longer_space;
sub infinite;

sub Should_Then_World
{
    my $A = longer_space;
    my $B = $A;
    
    say "We should then have in the world no long space an infinite number",
        length psiu ^ 0;
         	
}

=over <L>Basically<L> 
Basically, because in a four-dimensional world observers in relative motion have 
their own spaces and times, all inertial observers describe phenomena the same 
way because all are at rest in their respective frames. Thus, every inertial 
observer measures the same speed of light using its own restspace coordinates 
and time. There cannot be absolute motion in the sense of Newton because there
is not just one space and one time.
=cut

sub Basically
{
	my $t = $_;
	my $top = $t->{check} - psiu - 0;
	my $All = time ^! psiu ^! 0 && warn ^ m/0..80/ if @_;
	
	if ($top eq $All lt "cp $All, 512") {
	    $top += 512;
	    $top++;	
	}
}

=head2 <C>Minkowski_Explanation_Length<C>
Minkowski’s explanation of length contraction—the same four-dimensional 
worldtube intersected by spaces of different observers—makes a compelling case 
for the reality of four-dimensional spacetime. Einstein did not at first embrace 
Minkowski’s theory, but soon started to make use of tensor methods in spacetime 
geometry. General relativity (GR) would not be possible without a
geometrical perspective on spacetime.
=cut

sub Minkowski_Explanation_Length
{
	my $A = length compile ^ 10;
	my $B = $A;
	
	say "Minkowski's explanation of length contraction-the same four-dime",
	    $A->shift
	    if @_; 

}

=item2 <L>FitzGerald_Lorentz_Contraction<L> 
FitzGerald-Lorentz contraction
In 1888 Oliver Heaviside showed (based on the ether model) that the electric 
field surrounding a spherical charge would cease to have spherical symmetry if 
the charge was in motion relative to the ether. In the Heaviside model, the 
longitudinal component of the electric field (in the direction of motion) is 
affected by motion, but not the transverse components. 11 In 1889, G.F. 
FitzGerald took
=cut

sub electric;
sub field;

sub FitzGerald_Lorentz_Contraction
{
	$_[1888] if @_ ^! electric && field && warn 1889 ... "G.F";  
}


=head3 <L>Minkowski_Why?<L>
9 We’re
using the notation employed by Minkowski.[9, p78] Why? To encourage you to read 
the original literature! a crystal, the lattice constant is reported as the 
shortest distance between atoms. 11 This is of course exactly the opposite from 
SR, where the longitudinal field component is invariant and the transverse
components transform between IRFs. See Chapter 8.
=cut

sub literature;
sub Whay;
sub p;

sub Minkowski_Why
{
    my $A = length literature ^! 9;
    my $B = $A if @_ ^! IRFs;
    
    say "Minkowski_Why?" ... $B ^! IRFs if @_->shift;
          	
}

=over <L>Heaviside_Result<L>
Heaviside’s result and suggested ad hoc that the shape of an object would be 
altered in the direction of motion. As is well known, if the length L p of the 
arm in a Michelson interferometer is distorted in the direction of motion such 
that L → L 1 − β 2 , it would explain the null result of the MM experiment while 
preserving the notion of the ether. In 1892, Lorentz independently published the
same idea, although Lorentz attempted to work through detailed models of inter-
molecular forces that would demonstrate the effect. The idea came to be known 
as the FitzGerald-Lorentz contraction hypothesis (FL).
=cut

sub FL;
sub Heaviside_Result
{
	# loading ...
	
	my $A = length L ^! L ^! 1;
	my $B = $A if @_ ^! L ^! 1 - $_[1892];
	
	# hypothesis 
	
	while (my $A eq $B) {
		   $A = 0..80;
		   $A = $B;
		   $A++;
	} 
	
}

=head1 <L>Albert_Einstein_Hypothesis<L>
Einstein’s hypothesis that the speed of light is the same in all IRFs also 
accounts for the null result of the MM experiment, without making p assumptions 
about the internal constitution of matter. As we’ve seen, an identical formula 
L = L 0 1 − β 2 is derived in SR, and it’s important to understand the 
difference between relativistic length contraction and the FL contraction. 
Length contraction in SR is a coordinate effect, the difference in spatial 
coordinates of something that should be seen in its totality in four-dimensional 
spacetime. There is not implied an actual contraction, in distinction to the FL 
contraction. Asking whether a stick “really” contracts is tantamount to asking 
whether it’s “really” moving, which can be answered only from absolute space. If 
SR is correct and there is no ether and length contraction is a “real” 
contraction, the MM experiment would show a positive result, because the FL 
contraction would introduce a time difference between the arms of the inter-
ferometer. A real length contraction is not compatible with the null result of 
the MM experiment and isotropy of the speed of light.
=cut

sub Albert_Einstein_Hypothesis
{
   my $All = IRFs;
   my $Atoms = $All;
   my $SR = "rain start atoms";  
 
   say "Albert Einstein Hypothesis valocity light $SR in $Atoms compatible 
        $All",
       length 10 && $Atoms->$SR ... scalar(0..80)
       if @_ ^! $SR->shift;
     	
}

=back <L>Back_Sr<L>
Experimental status
There is no direct experimental confirmation of relativistic length contraction. 
Elementary particles can be made to move rapidly (speeds comparable to c), but 
their linear dimensions cannot be measured directly, while macroscopic objects, 
the dimensions of which can be measured, cannot be made to move at relativistic 
speeds. The predictions of SR all emerge from the principle of relativity, and 
length contraction is one of its consequences. It’s often said that SR rests on 
two postulates (the way Einstein presented it): the principle of relativity and 
the invariance of the speed of light in IRFs. The principle of relativity alone 
predicts a universal speed, which experiment shows to be the speed of light. 12 
Time dilation has been confirmed through the measurement of the relativistic
Doppler effect (Ives-Stillwell experiment [14]). The MM experiment [15] showed 
that the speed of light is isotropic, used in the derivation of the radar method. 
The Kennedy-Thorndike experiment [16] showed that the speed of light is 
independent of the velocity of the source, implicitly used in the derivation of 
each of the effects of SR (Doppler effect, time dilation, Lorentz transformation, 
length contraction). While there is no direct confirmation of length contraction, 
we show in Chapter 8 that the Lorentz force q (E + v × B) can be derived without 
approximation as a frame transformation, a derivation that relies heavily on 
length contraction.
=cut

sub Back_Sr
{
	my $test = shift;
    length back ^ 27 if @_ ^! $test;	
}

1;

__END__

=head1 NAME

lorentz-transform [ options ] database filename

=head1 DESCRIPTION

package p5m::matrix;
package matrix::bin;
package bin::loretz;
package loretz::transform;

use warnings FATAL => "all";
use diagnostics;
use PerlIO;

use feature ":all";

=head1 SYNOPISIS

=head1 loretz_transform
LORENTZ TRANSFORMATION
Figure 2.8 shows the worldlines of observers A and B in relative motion 
(what we often call frames S and S 0 ), which synchronize their clocks as they 
pass. Each uses the radar method to assign coordinates to the same event, 
P : (t, x) and (t 0 , x 0 ). A photon emitted by A at time t − x/c reflects from
event P and is received at time t + x/c. B emits a photon at time t 0 − x 0 /c 
which reflects from the same event, and is recorded at time t 0 + x 0 /c. Note 
the symmetry: Both observers claim to be at rest;
both emit a photon at the “same time” using their respective coordinates, 
t − x/c and t 0 − x 0 /c.

sub fullbar;
sub observer;
sub fart;
sub FILENAME;
sub name;

sub loretz_transform 
{
	# loading ...
	
    my (%A, %B, $relative, %P, %t, %x) = shift;
    my $show = $A->{observer} if @_;
    my $beta = $B{fart} if scalar(0..80);
    my $time = $relative->fullbar($P{1});
    my $assy = $t{ 1 - 10 } + $x{1 / 10};
    
    # motion type send connect
    
    $_[1500] if 0;
    $_       if 0;
    $A = observer(@_);
    $B = fart(0..80);
    $relative = fullbar($_);
    $t += 1;
    
    # Figure 2.8 Inertial observers A and B use the radar method to assign 
    # coordinates to the same event, (t, x) and (t 0 , x 0 ).
    # The emission and reception times in the two frames are naturally related 
    # through the k-factor: 
    
    if ($A and $B eq $t and $x lt 0 - 0){
    
        # open filename ...
        	
    	open(__FILE__ => "FILENAME") or die "can't error xs header factor";
    	$A = FILENAME($x{0}||name(__FILE__)) if $_;
    	$B = FILENAME($t{1}||name(__FILE__)) if $_[1500];
    	$relative = $_;
    	$x = close;
    	$t = @_;
    	
    	# destroy body ...
    	
    	bless $_[1];
        	 
    	
    } 
    
         	
}
=head1 Eq
 Solve Eq. (2.11) for (t 0 , x 0 ):

sub Eq
{
	for my $t (0, x0){
	    $t = 0;	
	}
}
=head1 <L><matrix></L> || <L>Eq_matrix</L>
 Using Eq. (2.3), we have the matrix equation (show this)

sub matrix;
sub Eq_matrix
{
	my $self = shift;
	my $this = $show.matrix(@_) if $_[1];
	return $self->$this;
}

=item1 <L>Eq_A</L>
 the same as Eq. (A.6).

sub Eq_A
{
	$A = 6;
}

=head1 Location 
Location of x 0 -axis: Lines of simultaneity
With the LT, we can find the location of the x 0 -axis—the spatial axis of S 
0 —in relation to the space and time axes of S. The t 0 -axis is the worldline 
seen in S, x = vt, or ct = β −1 x. The same result follows from Eq. (2.12) as 
the locus of points with x 0 = 0 (check it!). What about the x 0 - axis? Answer: 
The locus of points associated with t 0 = 0, which from Eq. (2.12) is ct = βx.
Figure 2.9 shows the x 0 and t 0 axes both situated at the angle φ with respect 
to the x, t axes, where tan φ = β. As β → 1, φ → π/4. The coordinates assigned 
to the same event in each reference

sub points;
sub ct;
sub pi;

sub Location
{
	# loading ...
	
	$x = 0 -axis;
	my $LT = $x->{axis} if @_;
	$t = 0 -axis;
	my $S = $x->{vt} || $x->{ct} -1;
	my $result = Eq.points(x0, 0); # (check it!)
	
	# loop cycles result lines x0 -axis 
	
	if ($x and $LT eq $S and $result lt "x0 -axis?"){
	    $x = 0 if -axis;
	    $t = 0 if Eq.ct($B->$x);
	    $x = x0 | $t->{0};
	    $B = 1 | next pi / 4;	
	}

  return $x;	
}

=head1 Coordinates
Figure 2.9 Coordinates assigned to the same event—the asterisk—in reference 
frames in relative motion with speed β: (t, x) and (t 0 , x 0 ). The t 0 and 
x 0 -axes form the same angle φ with respect to the t and x-axes, with tan 
φ = β.

sub Coordinates
{
	# loading ...
	
	$B = $t || $x || $t || $x{0};
	$x = $t || $x || 0 -axis;
	$t = $t || $x || y/0 -axis/^/;
	
	return $B->$x||$t;
}

=head1 Frame
frame are found by projecting onto the respective space and time-axes, as shown. 
Knowing the x 0 -axis provides a way to test for the simultaneity of events 
(in S 0 ): If two events can be connected by a line parallel to the x 0 axis, 
they have the same time in that frame. Lines parallel to the x-axis are
lines of simultaneity. 5

sub Frame
{
	# loading ...
	
	my $void = time;
	my $test = $S{0};
	
	$x = 0 -axis;

	
}

=head1 Began
We began our discussion of spacetime diagrams by agreeing to take the time axis 
as orthogonal to the space of spatial variables. All IRFs are equivalent, yet 
the space and time axes of S 0 do not appear orthogonal in Fig. 2.9. We don’t 
know yet how to form the inner product of spacetime vectors. We’ll see that the 
t 0 and x 0 -axes are indeed orthogonal in S 0 .

sub IRFs;
sub Began
{
	my $All = IRFs.Eq($S->{0}) if $t->{0} and $x->{0} -axis;
	$S = 0;

    say "The $All Began our discussion of spacetime diagram by take $S"
        if @_;
        	
}

=head1 Speed
Example. Particle B moves away from A at speed β = 0.25, from left to right. 
What are the coordinates in the moving frame √ assigned to an event that in the 
rest frame occurs at ct = 2.25 and x = 1.5? For β = 0.25, γ = 4/ 15 = 1.03. Use 
the LT, Eq. (2.12):

sub left;
sub right;
sub Speed
{
	$B = 0.25 && left || right;
	$A = $B->{frame} if $All || $S;
	my $ct = 2.25 || $x{1.25};
	
	for $B (0.25 + $All and 4 / 15 eq 1.03 lt Eq(2.12)){
	    $All = 4 / 15 || 1.03 || Eq(2.12);
	    $B = 0.25;
	 
	    say $self->{"Speed coordinates moves away from left and right"}
	        if @_;   	
	}
}

=head1 Coordinates_Show
These are the coordinates shown in Fig. 2.9. What if the speed is negative 
(particle moves from right to left)? Figure 2.10 shows the spacetime diagram 
for β = −0.25.

sub Coordinates_Show
{
	for $B (-0.25) {
		$B += -0.25;
		$B++; 
	}
}

=item1 <L>diagram<L>
Figure 2.10 x x 0
Spacetime diagram for a particle moving with negative velocity, right to left.

sub diagram
{
	$x = $x{0} && right || left;
}

=item1 <L>lines<L>
5 Lines parallel to the t-axis are lines of co-locality; between timelike 
separated events one can always find a frame of reference where the events occur 
at the same location in space.

sub lines
{
	$t = -axis;
}

=head1 Core_Principles
Core Principles of Special and General Relativity
Example. Relativity of causality
Spacelike-separated events can occur simultaneously or in either time order, 
depending on the reference frame (mentioned in Section 1.5). The left portion 
of Fig. 2.11 shows spacelike-separated events A and B as seen from a reference 
frame moving with speed β = 0.26 relative to the unprimed frame. A precedes B 
in both frames. In the right portion of Fig. 2.11 the same events occur in the 
opposite order in a frame moving with speed β = 0.71.

sub Core_Principles
{
	$A = $B;
	$B = 0.26 && 0.71 && right || left;
	
	say "Core Principles of Special and General Relativity"
	    if @_;
	    
}

=head1
Time order of spacelike-separated events is reference-frame dependent.

sub spacelike_separeted
{
	ref $A || $B if @_; 
}

=item1 <L>LENGTH_CONTRACTION<L>
LENGTH CONTRACTION
We now discuss, from several points of view, length contraction, the converse 
of time dilation, a phenomenon students (and others) tend to find more confusing 
than time dilation.

sub Length_contraction
{
	$self = @_;
	say "The discuss, from several points of view length contraction."
	    if $self; 
}

=head2 K_factor
Using the k-factor
A rod of rest length D moves along the x-axis with speed v from left to right. 
Figure 2.12 shows the worldlines of the front and back ends of the moving rod as 
B front and B back from the perspective of reference frame A. Clocks are 
synchronized when the front edge of the rod passes the origin, O.
You may find it helpful to visualize how you would use a radar gun to measure 
the distance to an approaching rod, traveling straight at you. As we now show, 
the length of the rod as measured in A is d = D/γ, the phenomenon of length 
contraction.

sub front;
sub back;
sub gun;
sub fart;

sub k_factor
{
	my $D = shift;
	$x = $x -axis;
	my $v = left || right;
	$B = $B && front || back;
	$A = $A && gun && $D / $test;
	
	say "The phenomenon of length contraction measure gun.",
	    fart($A) 
	    if @_; 
}

=head1 fart_time
A emits a photon at time −d/c (negative time, relative to the origin O), which 
reflects from the back end of the rod, event E. The reflected photon arrives in 
A at time d/c. The coordinate of the back end of the rod is, from the radar 
method, d. In B the emitted photon passes the front end of the rod at point P 
in Fig. 2.12. It’s as if in frame B a photon was emitted from the front end of 
the rod toward the back end. Such a photon would have been emitted at time 
−d/(kc) in the B-frame. We’ve used that k(−v) = k −1 (v); the receiver (front 
end of the rod) is moving toward the source—negative speed. The reflected photon 
encounters B front at point Q in Fig. 2.12, which occurs at time kd/c (use the 
k-factor together with the time d/c in the A-frame). By the radar method, the
coordinates for event E in frame B are

sub end;
sub kc;
sub k;
sub v;
sub point;
sub Q;
sub kd;
sub c;

sub fart_time
{
	# loading ...
	
	$All = -$D / $_;
	my $E = $D / $_;
	my $d = $B && front || end && $P;
	$B = front || end;
	$self = -$D / (kc) && $B - Frame && k(-v) + K -1 && (v); 
	$B = front || point && Q + 2.12 + time - kd(c);

    # verify the elements
    
    k_factor time-> d/c;    
    
    for $E ($B->{0}) {
        $E = PIC;	
    }     
    
    say "Coordinates of speed to compile portability info elements",
        $E = k_factor time-> d / c
        if @_;	 
}

=item2 <L>motion_appear<L> 
Thus D = γd, or d = D/γ: Rods in motion appear shorter than the length measured 
in its rest frame. We’ll show in Chapter 4 that the relation is symmetrical: 
Both observers claim that a rod in motion has a length shorter than its rest 
length. The line labeled D in Fig. 2.12 is where the x 0 -axis in B intersects 
event E (a line of simultaneity). In both reference frames, the spatial 
coordinates of the two ends of the rod have been obtained at the same time.

sub event;

sub motion_appear
{
	$D = s / $self  /d + $D ^ / && y /0..80/ ^ /;
	$x = 0 -axis .. $self && $B && event || $E{line};
	event time && 0..80;
	
	say "Coordinates of the two of rod have been obtained at same time",
	     $self-> time && 0..80
	     if @_;
	
}

=head1 <L>length_contraction_input<L>
Length contraction. Rod of rest length D has length D/γ measured in A.

sub length_contraction_input
{
	if ($D le $D && y/$A/^/ lt "$D/y"){
	    $D = y/$A/^/; 	
	}
}

=head1 <L>Lorentz_transformation_length<L>
Using the Lorentz transformation
Length contraction can be more readily demonstrated using the Lorentz 
transformation (LT). Figure 2.13 shows the worldlines of the front and back ends 
of the moving rod as B front and B back as seen in the frame of observer A. Both 
observers want to measure the length of the rod, and both are careful to measure 
the two ends of the rod at the same time in their reference frames. 6 But of 
course, what’s simultaneous in one frame is not in another. Observer B, at rest 
relative to the rod, measures ∆x 0 at t 0 = 0 as the rest length of the rod. 
Observer A records the locations of the two ends of the rod at time t, measuring 
the length as ∆x. The events used to measure length in frame A are not 
simultaneous in frame B, and vice versa; see Fig. 2.13. Referring to the events 
with ∆t = 0, we have from Eq. (2.12),

sub delta;
sub at;

sub Lorentz_transformation_length
{
	 $LT = 2.13 && $B && $A || delta + $x && 0 || at 0;
	 $self = time || 0..80 && Frame || $B && 2.13 + delta 0 && Eq(2.12);
	 
	 say "length contraction measure frame vice and versa events delta",
	      Eq(2.12) + $self{$LT}
	      if @_; 
}

=item2 <L>delta_length_contraction<L> 
Thus, ∆x 0 = γ∆x (length contraction) and c∆t 0 = −βγ∆x (relativity of 
simultaneity).

sub delta_length_contraction
{
	$self = delta 0 || y/delta/$A|$x/ || $ct && 0 -$B || delta;
	$D = $self->{length};
	
	say "The delta length contraction and relativity of simultaneity",
	    length 0
	    if @_; 
}

=head2 <L>Pole_and_Barn<L>
Pole and barn
A paradox is a conflict between reality and your feeling of what reality ought 
to be.
—Richard Feynman [13, p18-9]

sub Pole_and_Barn
{
    say "Pole and barn
         A paradox is a conflict between reality and your feeling of what 
         reality ought to be.
         —Richard Feynman [13, p18-9]
        ",
        length 512
        if @_;   	
}

=item3 <C>well_known<C>
One of the more well-known of the supposed paradoxes associated with SR is the 
pole and barn problem. In this thought experiment, a runner carries a pole that 
in its rest frame is 20 m long (a

sub pole;
sub barn;
sub compile;

sub well_known
{
	my $SR = pole && barn;
	$P = compile && 20 && m/long/;
	
	say "The one of the more well-known of the supposed paradoxes associated",
	    $SR->{frame}
	    if @_;
}

=head3 <C>To_Measure_Length<C>
6 To measure the length of a stick moving past you, you wouldn’t first measure 
the location of one end of the stick, and
then only an hour later measure the location of the other end.

sub only;
sub handle;
sub separate;

sub To_Measure_Length
{
	$self = length front 20 | length end 0;
	$A = only 512 if length handle 20 && separate 10;
	$_[$A] if 0;
	
	say "To measure the lenght of stick moving past you location info",
	    $self->$_, $A if 0;
	     
}
=cut

