#!/usr/bin/perl
#!-*- coding: utf-8 -*-

package PDL::PP;
 
__END__

 
=head1 NAME
 
PDL::PP - Generate PDL routines from concise descriptions
 
=head1 SYNOPSIS
 
e.g.
 
        pp_def(
                'sumover',
                Pars => 'a(n); [o]b();',
                Code => q{
                        double tmp=0;
                        loop(n) %{
                                tmp += $a();
                        %}
                        $b() = tmp;
                },
        );
 
        pp_done();
 
=head1 FUNCTIONS
 
Here is a quick reference list of the functions provided by PDL::PP.
 
=head2 pp_add_boot
 
=for ref
 
Add code to the BOOT section of generated XS file
 
 
=head2 pp_add_exported
 
=for ref
 
Add functions to the list of exported functions
 
 
=head2 pp_add_isa
 
=for ref
 
Add entries to the @ISA list
 
 
=head2 pp_addbegin
 
=for ref
 
Sets code to be added at the top of the generate .pm file
 
 
=head2 pp_addhdr
 
=for ref
 
Add code and includes to C section of the generated XS file
 
 
=head2 pp_addpm
 
=for ref
 
Add code to the generated .pm file
 
 
=head2 pp_addxs
 
=for ref
 
Add extra XS code to the generated XS file
 
=head2 pp_beginwrap
 
=for ref
 
Add BEGIN-block wrapping to code for the generated .pm file
 
 
=head2 pp_bless
 
=for ref
 
Sets the package to which the XS code is added (default is PDL)
 
 
=head2 pp_boundscheck
 
=for ref
 
Control state of PDL bounds checking activity
 
 
=head2 pp_core_importList
 
=for ref
 
Specify what is imported from PDL::Core
 
 
=head2 pp_def
 
=for ref
 
Define a new PDL function
 
 
=head2 pp_deprecate_module
 
=for ref
 
Add runtime and POD warnings about a module being deprecated
 
 
=head2 pp_done
 
=for ref
 
Mark the end of PDL::PP definitions in the file
 
 
=head2 pp_export_nothing
 
=for ref
 
Clear out the export list for your generated module
 
 
=head2 pp_line_numbers
 
=for ref
 
Add line number information to simplify debugging of PDL::PP code
 
=head1 OVERVIEW
 
For an alternate introduction to PDL::PP, see L<Practical Magick with
C, PDL, and PDL::PP -- a guide to compiled add-ons for
PDL|https://arxiv.org/abs/1702.07753>.
 
Why do we need PP? Several reasons: firstly, we want to be able to
generate subroutine code for each of the PDL datatypes (PDL_Byte,
PDL_Short, etc).  AUTOMATICALLY.  Secondly, when referring to slices
of PDL arrays in Perl (e.g. C<< $x->slice('0:10:2,:') >> or other things such
as transposes) it is nice to be able to do this transparently and to
be able to do this 'in-place' - i.e, not to have to make a memory copy
of the section. PP handles all the necessary element and offset
arithmetic for you. There are also the notions of threading (repeated
calling of the same routine for multiple slices, see L<PDL::Indexing>)
and dataflow (see L<PDL::Dataflow>) which use of PP allows.
 
In much of what follows we will assume familiarity of the reader with
the concepts of implicit and explicit threading and index manipulations
within PDL. If you have not yet heard of these concepts or are not very
comfortable with them it is time to check L<PDL::Indexing>.
 
As you may appreciate from its name PDL::PP is a Pre-Processor, i.e.
it expands code via substitutions to make real C-code. Technically, the
output is XS code (see I<perlxs>) but that is very close to C.
 
So how do you use PP? Well for the most part you just write ordinary C
code except for special PP constructs which take the form:
 
   $something(something else)
 
or:
 
   PPfunction %{
     <stuff>
   %}
 
The most important PP construct is the form C<$array()>. Consider the very
simple PP function to sum the elements of a 1D vector (in fact this is
very similar to the actual code used by 'sumover'):
 
   pp_def('sumit',
       Pars => 'a(n);  [o]b();',
       Code => q{
           double tmp;
           tmp = 0;
           loop(n) %{
               tmp += $a();
           %}
           $b() = tmp;
       }
   );
 
What's going on? The C<< Pars => >> line is very important for PP - it
specifies all the arguments and their dimensionality. We call
this the I<signature> of the PP function (compare also the explanations in
L<PDL::Indexing>).  In this case the
routine takes a 1-D function as input and returns a 0-D scalar as
output.  The C<$a()> PP construct is used to access elements of the array
a(n) for you - PP fills in all the required C code.
 
You will notice that we are using the C<q{}> single-quote operator. This is
not an accident. You generally want to use single quotes to denote your
PP Code sections. PDL::PP uses C<$var()> for its parsing and if you don't
use single quotes, Perl will try to interpolate C<$var()>. Also, using the
single quote C<q> operator with curly braces makes it look like you are
creating a code block, which is What You Mean. (Perl is smart enough to look
for nested curly braces and not close the quote until it finds the matching
curly brace, so it's safe to have nested blocks.) Under other circumstances,
such as when you're stitching together a Code block using string
concatenations, it's often easiest to use real single quotes as 
 
 Code => 'something'.$interpolatable.'somethingelse;'
 
In the simple case here where all elements are accessed the PP construct
C<loop(n) %{ ... %}> is used to loop over all elements in dimension C<n>.
Note this feature of PP: ALL DIMENSIONS ARE SPECIFIED BY NAME.
 
This is made clearer if we avoid the PP loop() construct
and write the loop explicitly using conventional C:
 
   pp_def('sumit',
       Pars => 'a(n);  [o]b();',
       Code => q{
           PDL_Indx i,n_size;
           double tmp;
           n_size = $SIZE(n);
           tmp = 0;
           for(i=0; i<n_size; i++) {
               tmp += $a(n=>i);
           }
           $b() = tmp;
       },
   );
 
which does the same as before, but is more long-winded.
You can see to get element C<i> of a() we say C<< $a(n=>i) >> - we are
specifying the dimension by name C<n>. In 2D we might say:
 
 
   Pars=>'a(m,n);',
      ...
      tmp += $a(m=>i,n=>j);
      ...
 
The syntax C<< m=>i >> borrows from Perl hashes, which are in fact
used in the implementation of PP. One could also say
C<< $a(n=>j,m=>i) >> as order is not important.
 
You can also see in the above example the use of another PP
construct - C<$SIZE(n)> to get the length of the dimension C<n>.
 
It should, however, be noted that you shouldn't write an explicit C-loop
when you could have used the PP C<loop> construct since PDL::PP checks
automatically the loop limits for you, usage of C<loop> makes the code more
concise, etc. But there are certainly situations where you need explicit
control of the loop and now you know how to do it ;).
 
To revisit 'Why PP?' - the above code for sumit() will be
generated for each data-type. It will operate on slices
of arrays 'in-place'. It will thread automatically - e.g. if
a 2D array is given it will be called repeatedly for each
1D row (again check L<PDL::Indexing> for the details of threading).
And then b() will be a 1D array of sums of each row.
We could call it with $x->transpose to sum the columns instead.
And Dataflow tracing etc. will be available.
 
You can see PP saves the programmer from writing a lot of
needlessly repetitive C-code -- in our opinion this is
one of the best features of PDL making writing
new C subroutines for PDL an amazingly concise exercise. A second reason is
the ability to make PP expand your concise code definitions into different
C code based on the needs of the computer architecture in question. Imagine
for example you are lucky to have a supercomputer at your hands; in that
case you want PDL::PP certainly to generate code that takes advantage of
the vectorising/parallel computing features of your machine (this a project
for the future). In any case, the bottom line is that your unchanged code
should still expand to working XS code even if the internals of PDL
changed.
 
Also, because you are generating the code in an actual Perl script,
there are many fun things that you can do. Let's say that you need
to write both sumit (as above) and multit. With a little bit of creativity,
we can do
 
   for({Name => 'sumit', Init => '0', Op => '+='},
       {Name => 'multit', Init => '1', Op => '*='}) {
           pp_def($_->{Name},
                   Pars => 'a(n);  [o]b();',
                   Code => '
                        double tmp;
                        tmp = '.$_->{Init}.';
                        loop(n) %{
                          tmp '.$_->{Op}.' $a();
                        %}
                        $b() = tmp;
           ');
   }
 
which defines both the functions easily. Now, if you later need to
change the signature or dimensionality or whatever, you only need
to change one place in your code.
Yeah, sure, your editor does have 'cut and paste' and 'search and replace'
but it's still less bothersome and definitely more difficult to
forget just one place and have strange bugs creep in.
Also, adding 'orit' (bitwise or) later is a one-liner.
 
And remember, you really have Perl's full abilities with you -
you can very easily read any input file and make routines from
the information in that file. For simple cases like the above,
the author (Tjl) currently favors the hash syntax like the above -
it's not too much more characters than the corresponding array
syntax but much easier to understand and change.
 
We should mention here also the ability to get the pointer to the
beginning of the data in memory - a prerequisite for interfacing
PDL to some libraries. This is handled with the C<$P(var)> directive,
see below.
 
When starting work on a new pp_def'ined function, if you make a mistake, you
will usually find a pile of compiler errors indicating line numbers in the
generated XS file. If you know how to read XS files (or if you want to learn
the hard way), you could open the generated XS file and search for the line
number with the error. However, a recent addition to PDL::PP helps report
the correct line number of your errors: C<pp_line_numbers>. Working with the
original summit example, if you had a mis-spelling of tmp in your code, you
could change the (erroneous) code to something like this and the compiler
would give you much more useful information:
 
   pp_def('sumit',
       Pars => 'a(n);  [o]b();',
       Code => pp_line_numbers(__LINE__, q{
           double tmp;
           tmp = 0;
           loop(n) %{
               tmp += $a();
           %}
           $b() = rmp;
       })
   );
 
For the above situation, my compiler tells me:
 
 ...
 test.pd:15: error: 'rmp' undeclared (first use in this function)
 ...
 
In my example script (called test.pd), line 15 is exactly the line at which
I made my typo: C<rmp> instead of C<tmp>.
 
So, after this quick overview of the general flavour of programming
PDL routines using PDL::PP let's summarise in which circumstances you
should actually use this preprocessor/precompiler. You should use PDL::PP
if you want to
 
=over 3
 
=item *
 
interface PDL to some external library
 
=item *
 
write some algorithm that would be slow if coded in Perl
(this is not as often as you think; take a look at threading
and dataflow first).
 
=item *
 
be a PDL developer (and even then it's not obligatory)
 
=back
 
=head1 WARNING
 
Because of its architecture, PDL::PP can be both flexible and easy to use
on the one hand, yet exuberantly complicated at the same time. Currently,
part of the problem is that error messages are not very informative and if
something goes wrong, you'd better know what you are doing and be able to
hack your way through the internals (or be able to figure out by trial and
error what is wrong with your args to C<pp_def>). Although work is being
done to produce better warnings, do not be afraid to send your questions to
the mailing list if you run into trouble.
 
=head1 DESCRIPTION
 
Now that you have some idea how to use C<pp_def> to define new PDL functions
it is time to explain the general syntax of C<pp_def>.
C<pp_def> takes as arguments first the name of the function
you are defining and then a hash list that can contain various keys.
 
Based on these keys PP generates XS code and a .pm file. The function
C<pp_done> (see example in the SYNOPSIS) is used to tell PDL::PP that there
are no more definitions in this file and it is time to generate the .xs and
 .pm file.
 
As a consequence, there may be several pp_def() calls inside a file (by
convention files with PP code have the extension .pd or .pp) but generally
only one pp_done().
 
There are two main different types of usage of pp_def(),
the 'data operation' and 'slice operation' prototypes.
 
The 'data operation' is used to take some data, mangle it and
output some other data; this includes for example the '+' operation,
matrix inverse, sumover etc and all the examples we have talked about
in this document so far. Implicit and explicit threading and the creation
of the result are taken care of automatically in those operations. You
can even do dataflow with C<sumit>, C<sumover>, etc
(don't be dismayed if you don't understand the concept of dataflow
in PDL very well yet; it is still very much experimental).
 
The 'slice operation' is a different kind of operation: in a slice
operation, you are not changing any data, you are defining
correspondences between different elements of two ndarrays (examples include
the index manipulation/slicing function definitions in the file F<slices.pd>
that is part of the PDL distribution; but beware, this is not introductory
level stuff).
 
To support bad values, additional keys are required for C<pp_def>,
as explained below.
 
If you are just interested in communicating with some external
library (for example some linear algebra/matrix library), you'll usually
want the 'data operation' so we are going to discuss that first.
 
=head1 Data operation
 
=head2 A simple example
 
In the data operation, you must know what dimensions of data
you need. First, an example with scalars:
 
        pp_def('add',
                Pars => 'a(); b(); [o]c();',
                Code => '$c() = $a() + $b();'
        );
 
That looks a little strange but let's dissect it. The first
line is easy: we're defining a routine with the name 'add'.
The second line simply declares our parameters and the parentheses
mean that they are scalars. We call the string that defines our parameters
and their dimensionality the I<signature> of that function. For its
relevance with regard to threading and index manipulations check the
L<PDL::Indexing> man page.
 
The third line is the actual operation. You need to use the
dollar signs and parentheses to refer to your parameters
(this will probably change at some point in the future, once
a good syntax is found).
 
These lines are all that is necessary to actually define the function
for PDL (well, actually it isn't; you additionally need to write a
Makefile.PL (see below) and build the module (something like 'perl
Makefile.PL; make'); but let's ignore that for the moment). So now you
can do
 
        use MyModule;
        $x = pdl 2,3,4;
        $y = pdl 5;
 
        $c = add($x,$y);
        # or
        add($x,$y,($c=null)); # Alternative form, useful if $c has been
                              # preset to something big, not useful here.
 
and have threading work correctly (the result is $c == [7 8 9]).
 
=head2 The Pars section: the signature of a PP function
 
Seeing the above example code you will most probably ask: what is this
strange C<$c=null> syntax in the second call to our new C<add> function? If
you take another look at the definition of C<add> you will notice that
the third argument C<c> is flagged with the qualifier C<[o]> which
tells PDL::PP that this is an output argument. So the above call to
add means 'create a new $c from scratch with correct dimensions' -
C<null> is a special token for 'empty ndarray' (you might ask why we
haven't used the value C<undef> to flag this instead of the PDL
specific C<null>; we are currently thinking about it ;).
 
[This should be explained in some other section of the manual
as well!!]
The reason for having this syntax as an alternative is that if you have
really huge ndarrays, you can do
 
        $c = PDL->null;
        for(some long loop) {
                # munge a,b
                add($x,$y,$c);
                # munge c, put something back to x,y
        }
 
and avoid allocating and deallocating $c each time. It is allocated
once at the first add() and thereafter the memory stays until $c is
destroyed.
 
If you just say
 
  $c =  add($x,$y);
 
the code generated by PP will automatically fill in C<$c=null>
and return
the result. If you want to learn more
about the reasons why PDL::PP supports this style where output arguments
are given as last arguments check the
L<PDL::Indexing> man page.
 
C<[o]> is not the only qualifier a pdl argument can have in the signature.
Another important qualifier is the C<[t]> option which flags a pdl as
temporary.  What does that mean? You tell PDL::PP that this pdl is only
used for temporary results in the course of the calculation and you are
not interested in its value after the computation has been completed. But
why should PDL::PP want to know about this in the first place?  The reason
is closely related to the concepts of pdl auto creation (you heard
about that above) and implicit threading. If you use implicit threading
the dimensionality of automatically created pdls is actually larger than
that specified in the signature. With C<[o]> flagged pdls will be created
so that they have the additional dimensions as required by the number
of implicit thread dimensions. When creating a temporary pdl, however,
it will always only be made big enough so that it can hold the result
for one iteration in a thread loop, i.e. as large as required by the signature.
So less memory is wasted when you flag a pdl as temporary. Secondly, you
can use output auto creation with temporary pdls even when you are using
explicit threading which is forbidden for normal output pdls flagged with
C<[o]> (see L<PDL::Indexing>).
 
Here is an example where we use the [t] qualifier. We define the function
C<callf> that calls a C routine C<f> which needs a temporary array of the
same size and type as the array C<a> (sorry about the forward reference
for C<$P>; it's a pointer access, see below) :
 
  pp_def('callf',
        Pars => 'a(n); [t] tmp(n); [o] b()',
        Code => 'PDL_Indx ns = $SIZE(n);
                 f($P(a),$P(b),$P(tmp),ns);
                '
  );
 
Another possible qualifier is C<[phys]>. If given, this means the pdl
will have L<PDL::Core/make_physical> called on it.
 
Additionally, if it has a specified dimension C<d> that has value 1,
C<d> will not magically be grown if C<d> is larger in another pdl with
specified dimension C<d>, and instead an exception will be thrown. E.g.:
 
  pp_def('callf',
        Pars => 'a(n); [phys] b(n); [o] c()',
        # ...
  );
 
If C<a> had lead dimension of 2 and C<b> of 3, an exception will always
be thrown. However, if C<b> has lead dimension of 1, it would be silently
repeated as if it were 2, if it were not a C<phys> parameter.
 
=head2 Argument dimensions and the signature
 
Now we have just talked about dimensions of pdls and the signature. How
are they related? Let's say that we want to add a scalar + the index
number to a vector:
 
        pp_def('add2',
                Pars => 'a(n); b(); [o]c(n);',
                Code => 'loop(n) %{
                                $c() = $a() + $b() + n;
                         %}'
        );
 
There are several points to notice here: first, the C<Pars>
argument now contains the I<n> arguments to show that we have a single
dimensions in I<a> and I<c>. It is important to note that dimensions
are actual entities that are accessed by name so this declares
I<a> and I<c> to have the B<same> first dimensions. In most PP definitions
the size of named dimensions will be set from the respective dimensions
of non-output pdls (those with no C<[o]> flag) but sometimes you might
want to set the size of a named dimension explicitly through an integer
parameter. See below in the description of the C<OtherPars> section how
that works.
 
=head2 Constant argument dimensions in the signature
 
Suppose you want an output ndarray to be created
automatically and you know that on every call its dimension
will have the same size (say 9) regardless of the dimensions
of the input ndarrays. In this case you use the following
syntax in the Pars section to specify the size of the dimension: 
 
    ' [o] y(n=9); '
 
As expected, extra dimensions required by threading will be
created if necessary. If you need to assign a named dimension according
to a more complicated formula (than a constant) you must use the 
C<RedoDimsCode> key described below.
 
=head2 Type conversions and the signature
 
The signature also determines the type conversions that will be performed
when a PP function is invoked. So what happens when we invoke one of
our previously defined functions with pdls of different type, e.g.
 
  add2($x,$y,($ret=null));
 
where $x is of type C<PDL_Float> and $y of type C<PDL_Short>? With the signature
as shown in the definition of C<add2> above the datatype of the operation
(as determined at runtime) is that of the pdl with the 'highest' type
(sequence is byte < short < ushort < long < float < double). In the add2
example the datatype of the operation is float ($x has that datatype). All
pdl arguments are then type converted to that datatype (they are not
converted inplace but a copy with the right type is created if a pdl argument
doesn't have the type of the operation).
Null pdls don't contribute a type
in the determination of the type of the operation.
However, they will be
created with the datatype of the operation; here, for example, $ret will be
of type float. You should be aware of these rules when calling PP functions
with pdls of different types to take the additional storage and runtime
requirements into account.
 
These type conversions are correct for most functions you normally define
with C<pp_def>. However, there are certain cases where slightly modified
type conversion behaviour is desired. For these cases additional qualifiers
in the signature can be used to specify the desired properties with regard
to type conversion. These qualifiers can be combined with those we have
encountered already (the I<creation qualifiers> C<[o]> and C<[t]>). Let's
go through the list of qualifiers that change type conversion behaviour.
 
The most important is the C<indx> qualifier which comes in handy when a
pdl argument represents indices into another pdl. Let's take a look at
an example from C<PDL::Ufunc>:
 
   pp_def('maximum_ind',
          Pars => 'a(n); indx [o] b()',
          Code => '$GENERIC() cur;
                   PDL_Indx curind;
                   loop(n) %{
                    if (!n || $a() > cur) {cur = $a(); curind = n;}
                   %}
                   $b() = curind;',
   );
 
The function C<maximum_ind> finds the index of the largest element of
a vector. If you look at the signature you notice that the output
argument C<b> has been declared with the additional C<indx> qualifier.
This has the following consequences for type conversions: regardless of
the type of the input pdl C<a> the output pdl C<b> will be of type
C<PDL_Indx> which makes sense since C<b> will represent an index into
C<a>.
 
Note that 'curind' is declared as type C<PDL_Indx> and not C<indx>.
While most datatype declarations in the 'Pars' section use the same
name as the underlying C type, C<indx> is a type which is sufficient
to handle PDL indexing operations.  For 32-bit installs, it can be
a 32-bit integer type.  For 64-bit installs, it will be a 64-bit integer
type.
 
Furthermore, if you call the function with an existing output
pdl C<b> its type will not influence the datatype of the operation (see
above). Hence, even if C<a> is of a smaller type than C<b> it will not
be converted to match the type of C<b> but stays untouched, which saves
memory and CPU cycles and is the right thing to do when C<b> represents
indices. Also note that you can use the 'indx' qualifier together with
other qualifiers (the C<[o]> and C<[t]> qualifiers). Order is significant --
type qualifiers precede creation qualifiers (C<[o]> and C<[t]>).
 
The above example also demonstrates typical usage of the C<$GENERIC()>
macro.  It expands to the current type in a so called generic
loop. What is a generic loop? As you already heard a PP function has a
runtime datatype as determined by the type of the pdl arguments it has
been invoked with.  The PP generated XS code for this function
therefore contains a switch like C<switch (type) {case PDL_Byte: ... case
PDL_Double: ...}> that selects a case based on the runtime
datatype of the function (it's called a type ``loop''
because there is a loop in PP code that generates the cases).
In any case your code is inserted once for each PDL type
into this switch statement. The C<$GENERIC()> macro just expands to
the respective type in each copy of your parsed code in this C<switch>
statement, e.g., in the C<case PDL_Byte> section C<cur> will expand to
C<PDL_Byte> and so on for the other case statements. I guess you
realise that this is a useful macro to hold values of pdls in some
code.
 
There are a couple of other qualifiers with similar effects as C<indx>.
For your convenience there are the C<float> and C<double> qualifiers
with analogous consequences on type conversions as C<indx>. Let's
assume you have a I<very> large array for which you want to compute
row and column sums with an equivalent of the C<sumover> function.
However, with the normal definition of C<sumover> you might run
into problems when your data is, e.g. of type short. A call like
 
  sumover($large_pdl,($sums = null));
 
will result in C<$sums> be of type short and is therefore prone to
overflow errors if C<$large_pdl> is a very large array. On the other
hand calling
 
  @dims = $large_pdl->dims; shift @dims;
  sumover($large_pdl,($sums = zeroes(double,@dims)));
 
is not a good alternative either. Now we don't have overflow problems with
C<$sums> but at the expense of a type conversion of C<$large_pdl> to
double, something bad if this is really a large pdl. That's where C<double>
comes in handy:
 
  pp_def('sumoverd',
         Pars => 'a(n); double [o] b()',
         Code => 'double tmp=0;
                  loop(n) %{ tmp += a(); %}
                  $b() = tmp;',
  );
 
This gets us around the type conversion and overflow problems. Again,
analogous to the C<indx> qualifier C<double> results in C<b> always being of
type double regardless of the type of C<a> without leading to a
type conversion of C<a> as a side effect.
 
There is also a special type, C<real>. The others above are all actual
PDL/C datatypes, but C<real> is a modifier; if the operation type is real,
it has no effect; if it is complex, then the parameter will be the real
version - so C<cdouble> becomes C<double>, etc.
 
There is also the converse, C<complex>. If the operation is already
complex, there is no effect; if not, the output will be promoted to the
type's L<PDL::Type/complexversion>, which defaults to C<cfloat>. Note this
is controlled both by the L<PDL::Types> data, and the code in L<PDL::PP>.
B<NB> Because this outputs floating-point data, the inputs will by
definition be turned into such. Therefore, it only makes sense to have
floating-point C<GenericTypes> inputs. If you want to default to coercing
inputs to C<float>, give that as the last C<GenericTypes> as the generated
XS function defaults to the last-given one. Hence (with the C<PMCode>
and C<Doc> omitted):
 
  pp_def('r2C',
    GenericTypes=>[reverse qw(F D G C)], # last one is default so here = F
    Pars => 'r(); complex [o]c()',
    Code => '$c() = $r();'
  );
 
Finally, there are the C<type+> qualifiers where type is one of C<int>
or C<float>. What shall that mean. Let's illustrate the C<int+>
qualifier with the actual definition of sumover:
 
  pp_def('sumover',
         Pars => 'a(n); int+ [o] b()',
         Code => '$GENERIC(b) tmp=0;
                  loop(n) %{ tmp += a(); %}
                  $b() = tmp;',
  );
 
As we had already seen for the C<int>, C<float> and C<double>
qualifiers, a pdl marked with a C<type+> qualifier does not influence
the datatype of the pdl operation. Its meaning is "make this pdl at
least of type C<type> or higher, as required by the type of the
operation". In the sumover example this means that when you call the
function with an C<a> of type PDL_Short the output pdl will be of type
PDL_Long (just as would have been the case with the C<int>
qualifier). This again tries to avoid overflow problems when using
small datatypes (e.g. byte images).  However, when the datatype of the
operation is higher than the type specified in the C<type+> qualifier
C<b> will be created with the datatype of the operation, e.g. when
C<a> is of type double then C<b> will be double as well. We hope you
agree that this is sensible behaviour for C<sumover>. It should be
obvious how the C<float+> qualifier works by analogy.
It may become necessary to be able to specify a set of alternative
types for the parameters. However, this will probably not be
implemented until someone comes up with a reasonable use for it.
 
Note that we now had to specify the C<$GENERIC> macro with the name
of the pdl to derive the type from that argument. Why is that? If you
carefully followed our explanations you will have realised that in some
cases C<b> will have a different type than the type of the operation.
Calling the '$GENERIC' macro with C<b> as argument makes sure that
the type will always the same as that of C<b> in that part of the
generic loop.
 
This is about all there is to say about the C<Pars> section in a
C<pp_def> call. You should remember that this section defines the I<signature>
of a PP defined function, you can use several options to qualify certain
arguments as output and temporary args and all dimensions that you can
later refer to in the C<Code> section are defined by name.
 
It is important that you understand the meaning of the signature since
in the latest PDL versions you can use it to define threaded functions
from within Perl, i.e. what we call I<Perl level threading>. Please check
L<PDL::Indexing> for details.
 
=head2 The Code section
 
The C<Code> section contains the actual XS code that will be in the
innermost part of a thread loop (if you don't know what a thread loop is then
you still haven't read L<PDL::Indexing>; do it now ;) after any PP macros
(like C<$GENERIC>) and PP functions have been expanded (like the
C<loop> function we are going to explain next).
 
Let's quickly reiterate the C<sumover> example:
 
  pp_def('sumover',
         Pars => 'a(n); int+ [o] b()',
         Code => '$GENERIC(b) tmp=0;
                  loop(n) %{ tmp += a(); %}
                  $b() = tmp;',
  );
 
The C<loop> construct in the C<Code> section also refers to the
dimension name so you don't need to specify any limits: the loop is
correctly sized and everything is done for you, again.
 
Next, there is the surprising fact that C<$a()> and C<$b()> do B<not>
contain the index. This is not necessary because we're looping over
I<n> and both variables know which dimensions they have so
they automatically know they're being looped over.
 
This feature comes in very handy in many places and makes for
much shorter code. Of course, there are times when you want to
circumvent this; here is a function which make a matrix symmetric
and serves as an example of how to code explicit looping:
 
        pp_def('symm',
                Pars => 'a(n,n); [o]c(n,n);',
                Code => 'loop(n) %{
                                int n2;
                                for(n2=n; n2<$SIZE(n); n2++) {
                                        $c(n0 => n, n1 => n2) =
                                        $c(n0 => n2, n1 => n) =
                                         $a(n0 => n, n1 => n2);
                                }
                        %}
                '
        );
 
Let's dissect what is happening. Firstly, what is this function supposed to
do? From its signature you see that it takes a 2D matrix with equal numbers
of columns and rows and outputs a matrix of the same size. From a given
input matrix $a it computes a symmetric output matrix $c (symmetric in
the matrix sense that A^T = A where ^T means matrix transpose, or in PDL
parlance $c == $c->transpose). It does this by using only the values
on and below the diagonal of $a. In the output matrix $c all values on
and below the diagonal are the same as those in $a while those above the
diagonal are a mirror image of those below the diagonal (above and below
are here interpreted in the way that PDL prints 2D pdls). If this explanation
still sounds a bit strange just go ahead, make a little file into which you
write this definition, build the new PDL extension (see section on Makefiles
for PP code) and try it out with a couple of examples.
 
Having explained what the function is supposed to do there are a
couple of points worth noting from the syntactical point of
view. First, we get the size of the dimension named C<n> again by
using the C<$SIZE> macro. Second, there are suddenly these funny C<n0>
and C<n1> index names in the code though the signature defines only
the dimension C<n>. Why this? The reason becomes clear when you note
that both the first and second dimension of $a and $b are named C<n>
in the signature of C<symm>. This tells PDL::PP that the first and
second dimension of these arguments should have the same
size. Otherwise the generated function will raise a runtime error.
However, now in an access to C<$a> and C<$c> PDL::PP cannot figure out
which index C<n> refers to any more just from the name of the index.
Therefore, the indices with equal dimension names get numbered from
left to right starting at 0, e.g. in the above example C<n0> refers to
the first dimension of C<$a> and C<$c>, C<n1> to the second and so on.
 
In all examples so far, we have only used the C<Pars> and C<Code>
members of the hash that was passed to C<pp_def>. There are certainly
other keys that are recognised by PDL::PP and we will hear about some
of them in the course of this document. Find a (non-exhaustive) list
of keys in Appendix A.  A list of macros and PPfunctions (we have only
encountered some of those in the examples above yet) that are expanded
in values of the hash argument to C<pp_def> is summarised in Appendix
B.
 
At this point, it might be appropriate to mention that
PDL::PP is not a completely static, well designed set of routines (as
Tuomas puts it: "stop thinking of PP as a set of routines carved in
stone") but rather a collection of things that the PDL::PP author
(Tuomas J. Lukka) considered he would have to write often into his PDL
extension routines. PP tries to be expandable so that in the future,
as new needs arise, new common code can be abstracted back into it. If
you want to learn more on why you might want to change PDL::PP and how
to do it check the section on PDL::PP internals.
 
=head2 Handling bad values
 
There are several keys and macros used when writing code to handle
bad values. The first one is the C<HandleBad> key:
 
=over 4
 
=item HandleBad => 0
 
This flags a pp-routine as I<NOT> handling bad values. If this routine
is sent ndarrays with their C<badflag> set, then a warning message is
printed to STDOUT and the ndarrays are processed as if the value used to
represent bad values is a valid number. The C<badflag> value is
not propagated to the output ndarrays.
 
An example of when this is used is for FFT routines, which generally
do not have a way of ignoring part of the data.
 
=item HandleBad => 1
 
This causes PDL::PP to write extra code that ensures the BadCode
section is used, and that the C<$ISBAD()> macro (and its brethren)
work.
 
=item HandleBad is not given
 
If any of the input ndarrays have their C<badflag> set, then the
output ndarrays will have their C<badflag> set, but any supplied
BadCode is ignored.
 
=back
 
The value of C<HandleBad> is used to define the contents of
the C<BadDoc> key, if it is not given.
 
To handle bad values, code must be written somewhat differently;
for instance, 
 
 $c() = $a() + $b();
 
becomes something like
 
 if ( $a() != BADVAL && $b() != BADVAL ) {
    $c() = $a() + $b();
 } else {
    $c() = BADVAL;
 }
 
However, we only want the second version if bad values are present in
the input ndarrays (and that bad-value support is wanted!) - otherwise 
we actually want the original code. This is where the C<BadCode>
key comes in; you use it to specify the code to execute if bad values
may be present, and PP uses both it and the C<Code> section to create
something like:
 
 if ( bad_values_are_present ) {
    fancy_threadloop_stuff {
       BadCode
    }
 } else {
    fancy_threadloop_stuff {
       Code
    }
 }
 
This approach means that there is virtually no overhead when 
bad values are not present (i.e. the L<badflag|PDL::Bad/badflag> routine
returns 0).
 
The C preprocessor symbol C<PDL_BAD_CODE> is defined when the bad code
is compiled, so that you can reduce the amount of code you write.  The
BadCode section can use the same macros and looping constructs as the
Code section.  However, it wouldn't be much use without the following
additional macros:
 
=over 4
 
=item $ISBAD(var)
 
To check whether an ndarray's value is bad, use the C<$ISBAD> macro:
 
 if ( $ISBAD(a()) ) { printf("a() is bad\n"); }
 
You can also access given elements of an ndarray:
 
 if ( $ISBAD(a(n=>l)) ) { printf("element %d of a() is bad\n", l); }
 
=item $ISGOOD(var)
 
This is the opposite of the C<$ISBAD> macro.
 
=item $SETBAD(var)
 
For when you want to set an element of an ndarray bad.
 
=item $ISBADVAR(c_var,pdl)
 
If you have cached the value of an ndarray C<$a()> into a c-variable (C<foo> say),
then to check whether it is bad, use C<$ISBADVAR(foo,a)>.
 
=item $ISGOODVAR(c_var,pdl)
 
As above, but this time checking that the cached value
isn't bad.
 
=item $SETBADVAR(c_var,pdl)
 
To copy the bad value for an ndarray into a c variable, use
C<$SETBADVAR(foo,a)>.
 
=back
 
I<TODO:> mention C<$PPISBAD()> etc macros.
 
Using these macros, the above code could be specified as:
 
 Code => '$c() = $a() + $b();',
 BadCode => '
    if ( $ISBAD(a()) || $ISBAD(b()) ) {
       $SETBAD(c());
    } else {
       $c() = $a() + $b();
    }',
 
Since this is Perl, TMTOWTDI, so you could also write:
 
 BadCode => '
    if ( $ISGOOD(a()) && $ISGOOD(b()) ) {
       $c() = $a() + $b();
    } else {
       $SETBAD(c());
    }',
 
You can reduce code repetition using the C C<PDL_BAD_CODE> macro,
using the same code for both of the C<Code> and C<BadCode> sections:
 
    #ifdef PDL_BAD_CODE
    if ( $ISGOOD(a()) && $ISGOOD(b()) ) {
    #endif PDL_BAD_CODE
 
       $c() = $a() + $b();
 
    #ifdef PDL_BAD_CODE
    } else {
       $SETBAD(c());
    }
    #endif PDL_BAD_CODE
 
If you want access to the value of the badflag for a given
ndarray, you can use the PDL STATE macros:
 
=over 4
 
=item $ISPDLSTATEBAD(pdl)
 
=item $ISPDLSTATEGOOD(pdl)
 
=item $SETPDLSTATEBAD(pdl)
 
=item $SETPDLSTATEGOOD(pdl)
 
=back
 
I<TODO:> mention the C<FindBadStatusCode> and
C<CopyBadStatusCode> options to C<pp_def>, as well as the
C<BadDoc> key.
 
=head2 Interfacing your own/library functions using PP
 
Now, consider the following: you have your own C function
(that may in fact be part of some library you want to interface to PDL)
which takes as arguments two pointers to vectors of double:
 
        void myfunc(int n,double *v1,double *v2);
 
The correct way of defining the PDL function is
 
        pp_def('myfunc',
                Pars => 'a(n); [o]b(n);',
                GenericTypes => ['D'],
                Code => 'myfunc($SIZE(n),$P(a),$P(b));'
        );
 
The C<$P(>I<par>C<)> syntax returns a pointer to the first
element and the other elements are guaranteed to lie after that.
 
Notice that here it is possible to make many mistakes. First,
C<$SIZE(n)> must be used instead of C<n>. Second, you shouldn't put
any loops in this code. Third, here we encounter a new hash key
recognised by PDL::PP : the C<GenericTypes> declaration tells PDL::PP
to ONLY GENERATE THE TYPELOOP FOP THE LIST OF TYPES SPECIFIED. In
this case C<double>. This has two advantages. Firstly the size of
the compiled code is reduced vastly, secondly if non-double arguments
are passed to C<myfunc()> PDL will automatically convert them to
double before passing to the external C routine and convert them
back afterwards.
 
One can also use C<Pars> to qualify the types of individual
arguments. Thus one could also write this as:
 
        pp_def('myfunc',
                Pars => 'double a(n); double [o]b(n);',
                Code => 'myfunc($SIZE(n),$P(a),$P(b));'
        );
 
The type specification in C<Pars> exempts the argument from
variation in the typeloop - rather it is automatically converted
to and from the type specified. This is obviously useful in
a more general example, e.g.:
 
        void myfunc(int n,float *v1,long *v2);
 
        pp_def('myfunc',
                Pars => 'float a(n); long [o]b(n);',
                GenericTypes => ['F'],
                Code => 'myfunc($SIZE(n),$P(a),$P(b));'
        );
 
Note we still use C<GenericTypes> to reduce the size of the
type loop, obviously PP could in principle spot this and do
it automatically though the code has yet to attain that
level of sophistication!
 
Finally note when types are converted automatically one MUST
use the C<[o]> qualifier for output variables or you hard-won
changes will get optimised away by PP!
 
If you interface a large library you can automate the interfacing even
further. Perl can help you again(!) in doing this. In many libraries
you have certain calling conventions. This can be exploited. In short,
you can write a little parser (which is really not difficult in Perl) that
then generates the calls to C<pp_def> from parsed descriptions of the
functions in that library. For an example, please check the I<Slatec>
interface in the C<Lib> tree of the PDL distribution. If you want to check
(during debugging) which calls to PP functions your Perl code generated
a little helper package comes in handy which replaces the PP functions
by identically named ones that dump their arguments to stdout.
 
Just say
 
   perl -MPDL::PP::Dump myfile.pd
 
to see the calls to C<pp_def> and friends. Try it with F<ops.pd> and
F<slatec.pd>. If you're interested (or want to enhance it), the source
is in Basic/Gen/PP/Dump.pm
 
=head2 Other macros and functions in the Code section
 
Macros: So far we have encountered the C<$SIZE>, C<$GENERIC> and C<$P> macros.
Now we are going to quickly explain the other macros that are expanded in the
C<Code> section of PDL::PP along with examples of their usage.
 
=over 3
 
=item C<$T>
 
The C<$T> macro is used for type switches. This is very useful when you have
to use different external (e.g. library) functions depending on the input
type of arguments. The general syntax is
 
        $Ttypeletters(type_alternatives)
 
where C<typeletters> is a permutation of a subset of the letters
C<BSULNQFD> which stand for Byte, Short, Ushort, etc. and
C<type_alternatives> are the expansions when the type of the PP
operation is equal to that indicated by the respective letter. Let's
illustrate this incomprehensible description by an example. Assuming
you have two C functions with prototypes
 
  void float_func(float *in, float *out);
  void double_func(double *in, double *out);
 
which do basically the same thing but one accepts float and the other
double pointers. You could interface them to PDL by defining a generic
function C<foofunc> (which will call the correct function depending
on the type of the transformation):
 
  pp_def('foofunc',
        Pars => ' a(n); [o] b();',
        Code => ' $TFD(float,double)_func ($P(a),$P(b));'
        GenericTypes => [qw(F D)],
  );
 
There is a limitation that the comma-separated values cannot have
parentheses.
 
=item C<$PP>
 
The C<$PP> macro is used for a so called I<physical pointer access>. The
I<physical> refers to some internal optimisations of PDL (for those who
are familiar with the PDL core we are talking about the vaffine
optimisations). This macro is mainly for internal use and you shouldn't
need to use it in any of your normal code.
 
=item C<$COMP> (and the C<OtherPars> section)
 
The C<$COMP> macro is used to access non-pdl values in the code section. Its
name is derived from the implementation of transformations in PDL. The
variables you can refer to using C<$COMP> are members
of the ``compiled'' structure that represents the PDL transformation in question
but does not yet contain any information about dimensions
(for further details check L<PDL::Internals>). However, you can treat
C<$COMP> just as a black box without knowing anything about the
implementation of transformations in PDL. So when would you use this
macro? Its main usage is to access values of arguments that are
declared in the C<OtherPars> section of a C<pp_def> definition. But
then you haven't heard about the C<OtherPars> key yet?!  Let's have
another example that illustrates typical usage of both new features:
 
  pp_def('pnmout',
        Pars => 'a(m)',
        OtherPars => "char* fd",
        GenericTypes => [qw(B U S L)],
        Code => 'PerlIO *fp;
                 IO *io;
 
               io = GvIO(gv_fetchpv($COMP(fd),FALSE,SVt_PVIO));
                 if (!io || !(fp = IoIFP(io)))
                        croak("Can\'t figure out FP");
 
                 if (PerlIO_write(fp,$P(a),len) != len)
                                croak("Error writing pnm file");
  ');
 
This function is used to write data from a pdl to a file. The file descriptor
is passed as a string into this function. This parameter does not go into
the C<Pars> section since it cannot be usefully treated like a pdl but rather
into the aptly named C<OtherPars> section. Parameters in the C<OtherPars>
section follow those in the C<Pars> section when invoking the function, i.e.
 
   open FILE,">out.dat" or die "couldn't open out.dat";
   pnmout($pdl,'FILE');
 
When you want to access this parameter inside the code section you
have to tell PP by using the C<$COMP> macro, i.e. you write
C<$COMP(fd)> as in the example. Otherwise PP wouldn't know that the
C<fd> you are referring to is the same as that specified in the
C<OtherPars> section.
 
Another use for the C<OtherPars> section is to set a named dimension
in the signature. Let's have an example how that is done:
 
  pp_def('setdim',
        Pars => '[o] a(n)',
        OtherPars => 'int ns => n',
        Code => 'loop(n) %{ $a() = n; %}',
  );
 
This says that the named dimension C<n> will be initialised from the
value of the I<other parameter> C<ns> which is of integer type (I guess
you have realised that we use the C<CType From =E<gt> named_dim> syntax).
Now you can call this function in the usual way:
 
  setdim(($x=null),5);
  print $x;
    [ 0 1 2 3 4 ]
 
Admittedly this function is not very useful but it demonstrates how it
works. If you call the function with an existing pdl and you don't need
to explicitly specify the size of C<n> since PDL::PP can figure it out
from the dimensions of the non-null pdl. In that case you just give the
dimension parameter as C<-1>:
 
  $x = hist($y);
  setdim($x,-1);
 
That should do it.
 
=back
 
 
 
 
The only PP function that we have used in the examples so far is C<loop>.
Additionally, there are currently two other functions which are recognised
in the C<Code> section:
 
=over 2
 
=item threadloop
 
As we heard above the signature of a PP defined function defines the
dimensions of all the pdl arguments involved in a I<primitive> operation.
However, you often call the functions that you defined with PP with pdls
that have more dimensions than those specified in the signature. In this
case the primitive operation is performed on all subslices of appropriate
dimensionality in what is called a I<thread loop> (see also overview above
and L<PDL::Indexing>). Assuming you have some notion of this concept you
will probably appreciate that the operation specified in the code section
should be optimised since this is the tightest loop inside a thread loop.
However, if you revisit the example where we define the C<pnmout> function,
you will quickly realise that looking up the C<IO> file descriptor
in the inner thread loop is not very efficient when writing a pdl with
many rows. A better approach would be to look up the C<IO> descriptor
once outside the thread loop and use its value then inside the tightest
thread loop. This is exactly where the C<threadloop> function comes in
handy. Here is an improved definition of C<pnmout> which uses this
function:
 
  pp_def('pnmout',
        Pars => 'a(m)',
        OtherPars => "char* fd",
        GenericTypes => [qw(B U S L)],
        Code => 'PerlIO *fp;
                 IO *io;
                 int len;
 
               io = GvIO(gv_fetchpv($COMP(fd),FALSE,SVt_PVIO));
                 if (!io || !(fp = IoIFP(io)))
                        croak("Can\'t figure out FP");
 
                 len = $SIZE(m) * sizeof($GENERIC());
 
                 threadloop %{
                    if (PerlIO_write(fp,$P(a),len) != len)
                                croak("Error writing pnm file");
                 %}
  ');
 
This works as follows. Normally the C code you write inside the
C<Code> section is placed inside a thread loop (i.e. PP generates the
appropriate wrapping XS code around it). However, when you explicitly
use the C<threadloop> function, PDL::PP recognises this and doesn't
wrap your code with an additional thread loop. This has the effect that
code you write outside the thread loop is only executed once per
transformation and just the code with in the surrounding C<%{ ... %}>
pair is placed within the tightest thread loop. This also comes in
handy when you want to perform a decision (or any other code,
especially CPU intensive code) only once per thread, i.e.
 
  pp_addhdr('
    #define RAW 0
    #define ASCII 1
  ');
  pp_def('do_raworascii',
         Pars => 'a(); b(); [o]c()',
         OtherPars => 'int mode',
       Code => ' switch ($COMP(mode)) {
                    case RAW:
                        threadloop %{
                            /* do raw stuff */
                        %}
                        break;
                    case ASCII:
                        threadloop %{
                            /* do ASCII stuff */
                        %}
                        break;
                    default:
                        croak("unknown mode");
                   }'
   );
 
 
=item types
 
The types function works similar to the C<$T> macro. However, with the
C<types> function the code in the following block (delimited by C<%{>
and C<%}> as usual) is executed for all those cases in which the datatype
of the operation is I<any of> the types represented by the letters in the
argument to C<type>, e.g.
 
     Code => '...
 
             types(BSUL) %{
                 /* do integer type operation */
             %}
             types(FD) %{
                 /* do floating point operation */
             %}
             ...'
 
You are encouraged to use this idiom (from L<PDL::Math>) in order to
minimise effort needed to make your code work with new types:
 
  use PDL::Types qw(types);
  my @Rtypes = grep $_->real, types();
  my @Ctypes = grep !$_->real, types();
  # ...
    my $got_complex = PDL::Core::Dev::got_complex_version($name, 2);
    my $complex_bit = join "\n",
      map 'types('.$_->ppsym.') %{$'.$c.'() = c'.$name.$_->floatsuffix.'($'.$x.'(),$'.$y.'());%}',
      @Ctypes;
    my $real_bit = join "\n",
      map 'types('.$_->ppsym.') %{$'.$c.'() = '.$name.'($'.$x.'(),$'.$y.'());%}',
      @Rtypes;
    ($got_complex ? $complex_bit : '') . $real_bit;
 
=back
 
=head2 The RedoDimsCode Section
 
The C<RedoDimsCode> key is an optional key that is used to
compute dimensions of ndarrays at runtime in case the
standard rules for computing dimensions from the signature
are not sufficient. The contents of the C<RedoDimsCode> entry
is interpreted in the same way that the Code section is
interpreted-- I<i.e.>, PP macros are expanded and the result
is interpreted as C code. The purpose of the code is to set
the size of some dimensions that appear in the
signature. Storage allocation and threadloops and so forth
will be set up as if the computed dimension had appeared in
the signature. In your code, you first compute the desired
size of a named dimension in the signature according to
your needs and then assign that value to it via the $SIZE()
macro.
 
As an example, consider the following situation. You are
interfacing an external library routine that requires an
temporary array for workspace to be passed as an
argument. Two input data arrays that are passed are C<p(m)>
and C<x(n)>. The output data array is C<y(n)>. The routine
requires a workspace array with a length of n+m*m, and you'd
like the storage created automatically just like it would be
for any ndarray flagged with [t] or [o].  What you'd like is to
say something like
 
 pp_def( "myexternalfunc",
  Pars => " p(m);  x(n);  [o] y; [t] work(n+m*m); ", ...
 
but that won't work, because PP can't interpret expressions with arithmetic
in the signature. Instead you write
 
  pp_def(
      "myexternalfunc",
      Pars         => ' p(m);  x(n);  [o] y(); [t] work(wn); ',
      RedoDimsCode => '
        PDL_Indx im = $PDL(p)->dims[0];
        PDL_Indx in = $PDL(x)->dims[0];
        PDL_Indx min = in + im * im;
        PDL_Indx inw = $PDL(work)->dims[0];
        $SIZE(wn) = inw >= min ? inw : min;
      ',
      Code => '
        externalfunc( $P(p), $P(x), $SIZE(m), $SIZE(n), $P(work) );
      '
  );
 
This code works as follows: The macro $PDL(p) expands to a
pointer to the pdl struct for the ndarray p.  You don't want
a pointer to the data ( ie $P ) in this case, because you
want to access the methods for the ndarray on the C
level. You get the first dimension of each of the ndarrays
and store them in integers. Then you compute the minimum
length the work array can be. If the user sent an ndarray
C<work> with sufficient storage, then leave it alone. If the
user sent, say a null pdl, or no pdl at all, then the size
of wn will be zero and you reset it to the minimum
value. Before the code in the Code section is executed PP
will create the proper storage for C<work> if it does not
exist. Note that you only took the first dimension of C<p>
and C<x> because the user may have sent ndarrays with extra
threading dimensions. Of course, the temporary ndarray C<work> (note the
[t] flag) should not be given any thread dimensions anyway.
 
You can also use C<RedoDimsCode> to set the dimension of a
ndarray flagged with [o]. In this case you set the dimensions
for the named dimension in the signature using $SIZE() as in
the preceding example.  However, because the ndarray is
flagged with [o] instead of [t], threading dimensions will
be added if required just as if the size of the dimension
were computed from the signature according to the usual
rules. Here is an example from PDL::Math
 
 pp_def("polyroots",
      Pars => 'cr(n); ci(n); [o]rr(m); [o]ri(m);',
      RedoDimsCode => 'PDL_Indx sn = $PDL(cr)->dims[0]; $SIZE(m) = sn-1;',
 
The input ndarrays are the real and imaginary parts of
complex coefficients of a polynomial. The output ndarrays are
real and imaginary parts of the roots. There are C<n> roots
to an C<n>th order polynomial and such a polynomial has
C<n+1> coefficients (the zero-th through the C<n>th). In
this example, threading will work correctly. That is, the
first dimension of the output ndarray with have its dimension
adjusted, but other threading dimensions will be assigned
just as if there were no C<RedoDimsCode>.
 
=head2 Typemap handling in the C<OtherPars> section
 
The C<OtherPars> section discussed above is very often absolutely
crucial when you interface external libraries with PDL. However in
many cases the external libraries either use derived types or
pointers of various types.
 
The standard way to handle this in Perl is to use a C<typemap> file.
This is discussed in some detail in L<perlxs> in the standard
Perl documentation. In PP the functionality is very similar, so you can
create a C<typemap> file in the directory where your PP file resides and
when it is built it is automatically read in to figure out the appropriate
translation between the C type and Perl's built-in type.
 
That said, there are a couple of important differences from the general 
handling of types in XS. The first, and probably most important, is that
at the moment pointers to types are not allowed in the C<OtherPars>
section. To get around this limitation you must use the C<IV> type
(thanks to Judd Taylor for pointing out that this is necessary for
portability).
 
It is probably best to illustrate this with a couple of code-snippets:
 
For instance the C<gsl_spline_init> function has the following C 
declaration:
 
    int  gsl_spline_init(gsl_spline * spline,
          const double xa[], const double ya[], size_t size);
 
Clearly the C<xa> and C<ya> arrays are candidates for being passed
in as ndarrays and the C<size> argument is just the length of these
ndarrays so that can be handled by the C<$SIZE()> macro in PP. The
problem is the pointer to the C<gsl_spline> type. The natural solution
would be to write an C<OtherPars> declaration of the form
 
    OtherPars => 'gsl_spline *spl'
 
and write a short C<typemap> file which handled this type. This does
not work at present however! So what you have to do is to go around
the problem slightly (and in some ways this is easier too!):
 
 
The solution is to declare C<spline> in the C<OtherPars> section using
an "Integer Value", C<IV>. This hides the nature of the variable from
PP and you then need to (well to avoid compiler warnings at least!) 
perform a type cast when you use the variable in your code. Thus
C<OtherPars> should take the form:
 
    OtherPars => 'IV spl'
 
and when you use it in the code you will write
 
    INT2PTR(gsl_spline *, $COMP(spl))
 
where the Perl API macro C<INT2PTR> has been used to handle the pointer
cast to avoid compiler warnings and problems for machines with mixed 32bit
and 64bit Perl configurations.  Putting this together as Andres Jordan has
done (with the modification using C<IV> by Judd Taylor) in the
C<gsl_interp.pd> in the distribution source you get:
 
     pp_def('init_meat',
            Pars => 'double x(n); double y(n);',
            OtherPars => 'IV spl',
            Code =>'
         gsl_spline_init,( INT2PTR(gsl_spline *, $COMP(spl)), $P(x),$P(y),$SIZE(n)));'
    );
 
where I have removed a macro wrapper call, but that would obscure the
discussion.
 
The other minor difference as compared to the standard typemap handling
in Perl, is that the user cannot specify non-standard typemap locations or
typemap filenames using the C<TYPEMAPS> option in MakeMaker... Thus you
can only use a file called C<typemap> and/or the C<IV> trick above.
 
 
 
=head2 Other useful PP keys in data operation definitions
 
You have already heard about the C<OtherPars> key. Currently, there are not
many other keys for a data operation that will be useful in normal (whatever
that is) PP programming. In fact, it would be interesting to hear about
a case where you think you need more than what is provided at the moment.
Please speak up on one of the PDL mailing lists. Most other keys recognised
by C<pp_def> are only really useful for what we call I<slice operations>
(see also above).
 
One thing that is strongly being planned is variable number
of arguments, which will be a little tricky.
 
An incomplete list of the available keys:
 
=over 4
 
=item Inplace
 
Setting this key marks the routine as working inplace - ie
the input and output ndarrays are the same. An example is
C<$x-E<gt>inplace-E<gt>sqrt()> (or C<sqrt(inplace($x))>).
 
=over 4
 
=item Inplace => 1
 
Use when the routine is a unary function, such as C<sqrt>.
 
=item Inplace => ['a']
 
If there are more than one input ndarrays, specify the name
of the one that can be changed inplace using an array reference.
 
=item Inplace => ['a','b']
 
If there are more than one output ndarray, specify the name
of the input ndarray and output ndarray in a 2-element array
reference. This probably isn't needed, but left in for
completeness.
 
=back
 
If bad values are being used, care must be taken to ensure the
propagation of the badflag when inplace is being used;
consider this excerpt from F<Basic/Bad/bad.pd>:
 
  pp_def('replacebad',HandleBad => 1,
    Pars => 'a(); [o]b();',
    OtherPars => 'double newval',
    Inplace => 1,
    CopyBadStatusCode => 
    '/* propagate badflag if inplace AND it has changed */
     if ( a == b && $ISPDLSTATEBAD(a) )
       PDL->propagate_badflag( b, 0 );
 
     /* always make sure the output is "good" */
     $SETPDLSTATEGOOD(b);
    ',
    ...
 
Since this routine removes all bad values, the output ndarray had
its bad flag cleared. If run inplace (so C<a == b>), then we have to
tell all the children of C<a> that the bad flag has been cleared (to
save time we make sure that we call C<PDL-E<gt>propagate_badgflag> only
if the input ndarray had its bad flag set).
 
NOTE: one idea is that the documentation for the routine could be 
automatically flagged to indicate that it can be executed inplace,
ie something similar to how C<HandleBad> sets C<BadDoc> if it's not 
supplied (it's not an ideal solution).
 
=back
 
=head2 Other PDL::PP functions to support concise package definition
 
So far, we have described the C<pp_def> and C<pp_done> functions. PDL::PP
exports a few other functions to aid you in writing concise PDL extension
package definitions.
 
=head3 pp_addhdr
 
Often when you interface library functions as in the above example
you have to include additional C include files. Since the XS file is
generated by PP we need some means to make PP insert the appropriate
include directives in the right place into the generated XS file.
To this end there is the C<pp_addhdr> function. This is also the function
to use when you want to define some C functions for internal use by some
of the XS functions (which are mostly functions defined by C<pp_def>).
By including these functions here you make sure that PDL::PP inserts your
code before the point where the actual XS module section begins and will
therefore be left untouched by xsubpp (cf. I<perlxs> and I<perlxstut>
man pages).
 
A typical call would be
 
  pp_addhdr('
  #include <unistd.h>       /* we need defs of XXXX */
  #include "libprotos.h"    /* prototypes of library functions */
  #include "mylocaldecs.h"  /* Local decs */
 
  static void do_the real_work(PDL_Byte * in, PDL_Byte * out, int n)
  {
        /* do some calculations with the data */
  }
  ');
 
This ensures that all the constants and prototypes you need will be properly
included and that you can use the internal functions defined here in the
C<pp_def>s, e.g.:
 
  pp_def('barfoo',
         Pars => ' a(n); [o] b(n)',
         GenericTypes => ['B'],
         Code => ' PDL_Indx ns = $SIZE(n);
                   do_the_real_work($P(a),$P(b),ns);
                 ',
  );
 
=head3 pp_addpm
 
In many cases the actual PP code (meaning the arguments to C<pp_def>
calls) is only part of the package you are currently
implementing. Often there is additional Perl code and XS code
you would normally have written into the pm and XS files which are now
automatically generated by PP. So how to get this stuff into those
dynamically generated files? Fortunately, there are a couple of
functions, generally called C<pp_addXXX> that assist you in doing
this.
 
Let's assume you have additional Perl code that should go into the
generated B<pm>-file. This is easily achieved with the C<pp_addpm> command:
 
   pp_addpm(<<'EOD');
 
   =head1 NAME
 
   PDL::Lib::Mylib -- a PDL interface to the Mylib library
 
   =head1 DESCRIPTION
 
   This package implements an interface to the Mylib package with full
   threading and indexing support (see L<PDL::Indexing>).
 
   =cut
 
   use PGPLOT;
 
   =head2 use_myfunc
        this function applies the myfunc operation to all the
        elements of the input pdl regardless of dimensions
        and returns the sum of the result
   =cut
 
   sub use_myfunc {
        my $pdl = shift;
 
        myfunc($pdl->clump(-1),($res=null));
 
        return $res->sum;
   }
 
   EOD
 
=head3 pp_add_exported
 
You have probably got the idea. In some cases you also want to export
your additional functions. To avoid getting into trouble with PP which
also messes around with the C<@EXPORT> array you just tell PP to add
your functions to the list of exported functions:
 
  pp_add_exported('use_myfunc gethynx');
 
=head3 pp_add_isa
 
The C<pp_add_isa> command works like the the C<pp_add_exported> function. 
The arguments to C<pp_add_isa> are added the @ISA list, e.g.
 
  pp_add_isa(' Some::Other::Class ');
 
=head3 pp_bless
 
If your pp_def routines are to be used as object methods use
C<pp_bless> to specify the package (i.e. class) to which
your I<pp_def>ed methods will be added. For example,
C<pp_bless('PDL::MyClass')>. The default is C<PDL> if this is
omitted.
 
=head3 pp_addxs
 
Sometimes you want to add extra XS code of your own
(that is generally not involved with any threading/indexing issues
but supplies some other functionality you want to access from the Perl
side) to the generated XS file, for example
 
  pp_addxs('','
 
  # Determine endianness of machine
 
  int
  isbigendian()
     CODE:
       unsigned short i;
       PDL_Byte *b;
 
       i = 42; b = (PDL_Byte*) (void*) &i;
 
       if (*b == 42)
          RETVAL = 0;
       else if (*(b+1) == 42)
          RETVAL = 1;
       else
          croak("Impossible - machine is neither big nor little endian!!\n");
       OUTPUT:
         RETVAL
  ');
 
Especially C<pp_add_exported> and C<pp_addxs> should be used with care. PP uses
PDL::Exporter, hence letting PP export your function means that they get added
to the standard list of function exported by default (the list defined by the
export tag ``:Func''). If you use C<pp_addxs> you shouldn't try to do anything
that involves threading or indexing directly. PP is much better at generating
the appropriate code from your definitions.
 
=head3 pp_add_boot
 
Finally, you may want to add some code to the BOOT section of the XS file
(if you don't know what that is check I<perlxs>). This is easily done
with the C<pp_add_boot> command:
 
  pp_add_boot(<<EOB);
        descrip = mylib_initialize(KEEP_OPEN);
 
        if (descrip == NULL)
           croak("Can't initialize library");
 
        GlobalStruc->descrip = descrip;
        GlobalStruc->maxfiles = 200;
  EOB
 
=head3 pp_export_nothing
 
By default, PP.pm puts all subs defined using the pp_def function into the output .pm
file's EXPORT list. This can create problems if you are creating a subclassed
object where you don't want any methods exported. (i.e. the methods will only
be called using the $object->method syntax).
 
For these cases you can call pp_export_nothing() to clear out the export list. Example (At 
the end of the .pd file):
 
 
  pp_export_nothing();
  pp_done();
 
=head3 pp_core_importList
 
By default, PP.pm puts the 'use Core;' line into the output .pm file. This imports Core's
exported names into the current namespace, which can create 
problems if you are over-riding one of Core's methods in the current file.
You end up getting messages like "Warning: sub sumover redefined in file
subclass.pm" when running the program.
 
For these cases the pp_core_importList can be used to change what is imported from Core.pm. 
For example: 
 
  pp_core_importList('()') 
 
This would result in 
 
  use Core();
 
being generated in the output .pm file. This would result in no names being imported
from Core.pm. Similarly, calling 
 
  pp_core_importList(' qw/ barf /')
 
would result in
 
  use Core qw/ barf/;
 
being generated in the output .pm file. This would result in just 'barf'
being imported from Core.pm.
 
=head3 pp_setversion
 
Simultaneously set the F<.pm> and F<.xs> files' versions, thus avoiding
unnecessary version-skew between the two. To use this, simply do this
in your .pd file, probably near the top:
 
 our $VERSION = '0.0.3';
 pp_setversion($VERSION);
 
 # Then, in your Makefile.PL:
 my @package = qw(FFTW3.pd FFTW3 PDL::FFTW3);
 my %descriptor = pdlpp_stdargs(\@package);
 $descriptor{VERSION_FROM} = 'FFTW3.pd'; # EUMM can parse the format above
 
However, don't use this if you use L<Module::Build::PDL>. See that
module's documentation for details.
 
=head3 pp_deprecate_module
 
If a particular module is deemed obsolete, this function can be used to mark it
as deprecated. This has the effect of emitting a warning when a user tries to
C<use> the module. The generated POD for this module also carries a deprecation
notice. The replacement module can be passed as an argument like this:
 
 pp_deprecate_module( infavor => "PDL::NewNonDeprecatedModule" );
 
Note that function affects I<only> the runtime warning and the POD.
 
=head1 Making your PP function "private"
 
Let's say that you have a function in your module called PDL::foo that
uses the PP function C<bar_pp> to do the heavy lifting. But you don't
want to advertise that C<bar_pp> exists. To do this, you must move your
PP function to the top of your module file, then call
 
 pp_export_nothing()
 
to clear the C<EXPORT> list. To ensure that no documentation (even the
default PP docs) is generated, set
 
 Doc => undef
 
and to prevent the function from being added to the symbol table, set
 
 PMFunc => ''
 
in your pp_def declaration (see Image2D.pd for an example). This will
effectively make your PP function "private." However, it is I<always>
accessible via PDL::bar_pp due to Perl's module design. But making
it private will cause the user to go very far out of his or her way
to use it, so he or she shoulders the consequences!
 
=head1 Slice operation
 
The slice operation section of this manual is provided using
dataflow and lazy evaluation: when you need it, ask Tjl to write it.
a delivery in a week from when I receive the email is 95% probable and
two week delivery is 99% probable.
 
And anyway, the slice operations require a much more intimate knowledge
of PDL internals than the data operations. Furthermore, the complexity
of the issues involved is considerably higher than that in the average
data operation. If you would like to convince yourself of this fact
take a look at the F<Basic/Slices/slices.pd> file in the PDL
distribution :-). Nevertheless,
functions generated using the slice operations are at the heart of the
index manipulation and dataflow capabilities of PDL.
 
Also, there are a lot of dirty issues with virtual ndarrays and
vaffines which we shall entirely skip here.
 
=head2 Slices and bad values
 
Slice operations need to be able to handle bad values.  The easiest
thing to do is look at F<Basic/Slices/slices.pd> to see how this works.
 
Along with C<BadCode>, there are also the C<BadBackCode> and 
C<BadRedoDimsCode> keys for C<pp_def>. However, any
C<EquivCPOffsCode> should I<not> need changing, since 
any changes are absorbed into the definition of the
C<$EQUIVCPOFFS()> macro (i.e. it is handled automatically
by PDL::PP).
 
=head2 A few notes on writing a slicing routine...
 
The following few paragraphs describe writing of a new slicing routine
('range'); any errors are CED's. (--CED 26-Aug-2002)
 
=head1 Handling of C<warn> and C<barf> in PP Code
 
For printing warning messages or aborting/dieing, you can call C<warn> or C<barf> from PP code.
However, you should be aware that these calls have been redefined using C preprocessor
macros to C<< PDL->barf >> and C<< PDL->warn >>. These redefinitions are in place to keep
you from inadvertently calling perl's C<warn> or C<barf> directly, which can cause segfaults during
pthreading (i.e. processor multi-threading).
 
PDL's own versions of C<barf> and C<warn> will queue-up warning or barf messages until after pthreading
is completed, and then call the perl versions of these routines.
 
See L<PDL::ParallelCPU> for more information on pthreading.
 
=head1 USEFUL ROUTINES
 
The PDL C<Core> structure, defined in F<Basic/Core/pdlcore.h.PL>, contains
pointers to a number of routines that may be useful to you.  The majority
of these routines deal with manipulating ndarrays, but some are more general:
 
=over 4
 
=item PDL->qsort_B( PDL_Byte *xx, PDL_Indx a, PDL_Indx b )
 
Sort the array C<xx> between the indices C<a> and C<b>.
There are also versions for the other PDL datatypes,
with postfix C<_S>, C<_U>, C<_L>, C<_N>, C<_Q>, C<_F>, and C<_D>.
Any module using this must ensure that C<PDL::Ufunc>
is loaded.
 
=item PDL->qsort_ind_B( PDL_Byte *xx, PDL_Indx *ix, PDL_Indx a, PDL_Indx b )
 
As for C<PDL-E<gt>qsort_B>, but this time sorting the indices
rather than the data.
 
=back
 
The routine C<med2d> in F<Lib/Image2D/image2d.pd> shows how such routines are 
used.
 
=head1 MAKEFILES FOR PP FILES
 
If you are going to generate a package from your PP file (typical file
extensions are C<.pd> or C<.pp> for the files containing PP code) it
is easiest and safest to leave generation of the appropriate commands
to the Makefile. In the following we will outline the typical format
of a Perl Makefile to automatically build and install your package
from a description in a PP file. Most of the rules to build the xs, pm
and other required files from the PP file are already predefined in
the PDL::Core::Dev package. We just have to tell MakeMaker to use
it.
 
In most cases you can define your Makefile like
 
  # Makefile.PL for a package defined by PP code.
 
  use PDL::Core::Dev;            # Pick up development utilities
  use ExtUtils::MakeMaker;
 
  $package = ["mylib.pd",Mylib,PDL::Lib::Mylib];
  %hash = pdlpp_stdargs($package);
  $hash{OBJECT} .= ' additional_Ccode$(OBJ_EXT) ';
  $hash{clean}->{FILES} .= ' todelete_Ccode$(OBJ_EXT) ';
  WriteMakefile(%hash);
 
  sub MY::postamble { pdlpp_postamble($package); }
 
Here, the list in $package is: first: PP source file name,
then the prefix for the produced files and finally the whole package name.
You can modify the hash in whatever way you like but it would be reasonable
to stay within some limits so that your package will continue to work
with later versions of PDL.
 
If you don't want to use prepackaged arguments,
here is a generic F<Makefile.PL> that you can adapt for your own
needs:
 
  # Makefile.PL for a package defined by PP code.
 
  use PDL::Core::Dev;            # Pick up development utilities
  use ExtUtils::MakeMaker;
 
  WriteMakefile(
   'NAME'       => 'PDL::Lib::Mylib',
   'VERSION_FROM'       => 'mylib.pd',
   'TYPEMAPS'     => [&PDL_TYPEMAP()],
   'OBJECT'       => 'mylib$(OBJ_EXT) additional_Ccode$(OBJ_EXT)',
   'PM'         => { 'Mylib.pm'            => '$(INST_LIBDIR)/Mylib.pm'},
   'INC'          => &PDL_INCLUDE(), # add include dirs as required by your lib
   'LIBS'         => [''],   # add link directives as necessary
   'clean'        => {'FILES'  =>
                          'Mylib.pm Mylib.xs Mylib$(OBJ_EXT)
                          additional_Ccode$(OBJ_EXT)'},
  );
 
  # Add genpp rule; this will invoke PDL::PP on our PP file
  # the argument is an array reference where the array has three string elements:
  #   arg1: name of the source file that contains the PP code
  #   arg2: basename of the xs and pm files to be generated
  #   arg3: name of the package that is to be generated
  sub MY::postamble { pdlpp_postamble(["mylib.pd",Mylib,PDL::Lib::Mylib]); }
 
To make life even easier PDL::Core::Dev defines the function C<pdlpp_stdargs>
that returns a hash with default values that can be passed (either
directly or after appropriate modification) to a call to WriteMakefile.
Currently, C<pdlpp_stdargs> returns a hash where the keys are filled in
as follows:
 
        (
         'NAME'         => $mod,
         'TYPEMAPS'     => [&PDL_TYPEMAP()],
         'OBJECT'       => "$pref\$(OBJ_EXT)",
         PM     => {"$pref.pm" => "\$(INST_LIBDIR)/$pref.pm"},
         MAN3PODS => {"$src" => "\$(INST_MAN3DIR)/$mod.\$(MAN3EXT)"},
         'INC'          => &PDL_INCLUDE(),
         'LIBS'         => [''],
         'clean'        => {'FILES'  => "$pref.xs $pref.pm $pref\$(OBJ_EXT)"},
        )
 
Here, C<$src> is the name of the source file with PP code, C<$pref> the
prefix for the generated .pm and .xs files and C<$mod> the name of the
extension module to generate.
 
=head1 INTERNALS
 
The internals of the current version consist of a large
table which gives the rules according to which things are translated
and the subs which implement these rules.
 
Later on, it would be good to make the table modifiable by the user
so that different things may be tried.
 
[Meta comment: here will hopefully be more in the future; currently,
your best bet will be to read the source code :-( or ask on the list
(try the latter first) ]
 
=head1 Appendix A: Some keys recognised by PDL::PP
 
Unless otherwise specified, the arguments are strings.
 
=over 4
 
=item Pars
 
define the signature of your function
 
=item OtherPars
 
arguments which are not pdls. Default: nothing. This is a semi-colon
separated list of arguments, e.g.,
C<< OtherPars=>'int k; double value; char* fd' >>. See C<$COMP(x)> and
also the same entry in L<Appendix B|/Appendix B: PP macros and functions>.
 
=item Code
 
the actual code that implements the functionality; several PP macros and
PP functions are recognised in the string value
 
=item HandleBad
 
If set to 1, the routine is assumed to support bad values and the code in
the BadCode key is used if bad values are present;
it also sets things up so that the C<$ISBAD()> etc macros can be used.
If set to 0, cause the routine to print a warning if any of the input ndarrays 
have their bad flag set.
 
=item BadCode
 
Give the code to be used if bad values may be present in the input ndarrays.
Only used if C<HandleBad =E<gt> 1>.
 
=item GenericTypes
 
An array reference. The array may contain any subset of the one-character
strings given below, which specify which types your operation will
accept. The meaning of each type is:
 
 B - signed byte (i.e. signed char)
 S - signed short (two-byte integer)
 U - unsigned short
 L - signed long (four-byte integer, int on 32 bit systems)
 N - signed integer for indexing ndarray elements (platform & Perl-dependent size)
 Q - signed long long (eight byte integer)
 F - float
 D - double
 G - complex float
 C - complex double
 
This is very useful (and important!) when interfacing an external library.
Default: [qw/B S U L N Q F D/]
 
=item Inplace
 
Mark a function as being able to work inplace. 
 
 Inplace => 1          if  Pars => 'a(); [o]b();'
 Inplace => ['a']      if  Pars => 'a(); b(); [o]c();'
 Inplace => ['a','b']  if  Pars => 'a(); b(); [o]c(); [o]d();'
 
If bad values are being used, care must be taken to ensure the
propagation of the badflag when inplace is being used;
for instance see the code for C<replacebad> in F<Basic/Bad/bad.pd>. 
 
=item Doc
 
Used to specify a documentation string in Pod format. See PDL::Doc
for information on PDL documentation conventions. Note: in
the special case where the PP 'Doc' string is one line this is
implicitly used for the quick reference AND the documentation!
 
If the Doc field is omitted PP will generate default documentation
(after all it knows about the Signature).
 
If you really want the function NOT to be documented in any way at this point
(e.g. for an internal routine, or because you are doing it elsewhere in the
code) explicitly specify C<Doc=E<gt>undef>.
 
=item BadDoc
 
Contains the text returned by the C<badinfo> command (in C<perldl>) or
the C<-b> switch to the C<pdldoc> shell script. In many cases, you will
not need to specify this, since the information can be automatically
created by PDL::PP. However, as befits computer-generated text, it's
rather stilted; it may be much better to do it yourself!
 
=item NoPthread
 
Optional flag to indicate the PDL function should B<not> use processor threads (i.e.
pthreads or POSIX threads) to split up work across multiple CPU cores. This option
is typically set to 1 if the underlying PDL function is not threadsafe. If this option
isn't present, then the function is assumed to be threadsafe. This option only
applies if PDL has been compiled with POSIX threads enabled. 
 
=cut
 
# FTypes is specified only in the two internal slice functions
# converttypei and flowconvert.
 
# converttypei is pp_def-ed in slices.pd, which generates converttypei_NN
# which is installed as global PDL."converttypei_new" (as that is the
# "GlobalNew" value in the pp_def) in PDL::Slices's BOOT section.
# converttypei_new is then used in pdlapi.c's get_convertedpdl which is
# used in PP::coerce_types if Pars are given type constraints.
 
# flowconvert, on the other hand, claims that it 'converts vaffine
# ndarrays without physicalizing them'. However, its only use, in Core.pm,
# is followed immediately by a "->make_physical->sever", so I don't see the
# advantage of not making things physical. At any rate, FTypes needs to be
# documented.

 
=item PMCode
 
  pp_def('funcname',
    Pars => 'a(); [o] b();',
    PMCode => 'sub PDL::funcname {
      return PDL::_funcname_int(@_) if @_ == 2; # output arg "b" supplied
      PDL::_funcname_int(@_, my $out = PDL->null);
      $out;
    }',
    # ...
  );
 
PDL functions allow C<[o]> ndarray arguments into which you want the output
saved. This is handy because you can allocate an output ndarray once and
reuse it many times; the alternative would be for PDL to create a new ndarray
each time, which may waste compute cycles or, more likely, RAM.
 
PDL functions check the number of arguments they are given, and call
C<croak> if given the wrong number. By default (with no C<PMCode>
supplied), any output arguments may be omitted, and PDL::PP provides
code that can handle this by creating C<null> objects, passing them to
your code, then returning them on the stack.
 
If you I<do> supply C<PMCode>, the rest of PDL::PP assumes it will be
a string that defines a Perl function with the function's name in the
C<pp_bless> package (C<PDL> by default). As the example implies,
the PP-generated function name will change from C<< <funcname> >>, to
C<< _<funcname>_int >>. As also shown above,
you will need to supply all ndarrays in the exact
order specified in the signature: output ndarrays are not optional, and the
PP-generated function will not return anything.
 
=item PMFunc
 
When pp_def generates functions, it typically defines them in the PDL
package. Then, in the .pm file that it generates for your module, it
typically adds a line that essentially copies that function into your current
package's symbol table with code that looks like this:
 
 *func_name = \&PDL::func_name;
 
It's a little bit smarter than that (it knows when to wrap that sort of
thing in a BEGIN block, for example, and if you specified something different
for pp_bless), but that's the gist of it. If you don't care to import the
function into your current package's symbol table, you can specify
 
 PMFunc => '',
 
PMFunc has no other side-effects, so you could use it to insert arbitrary
Perl code into your module if you like. However, you should use pp_addpm
if you want to add Perl code to your module.
 
=back
 
=head1 Appendix B: PP macros and functions
 
=head2 Macros
 
=over 7
 
=item $I<variablename_from_sig>()
 
access a pdl (by its name) that was specified in the signature
 
=item $COMP(x)
 
access a value in the private data structure of this transformation (mainly
used to use an argument that is specified in the C<OtherPars> section)
 
=item $SIZE(n)
 
replaced at runtime by the actual size of a I<named> dimension (as specified
in the I<signature>)
 
=item $GENERIC()
 
replaced by the C type that is equal to the runtime type of the operation
 
=item $P(a)
 
a pointer to the data of the PDL named C<a> in the signature. Useful for
interfacing to C functions
 
=item $PP(a)
 
a physical pointer access to pdl C<a>; mainly for internal use
 
=item $TXXX(Alternative,Alternative)
 
expansion alternatives according to runtime type of operation,
where XXX is some string that is matched by C</[BSULNQFD+]/>.
 
=item $PDL(a)
 
return a pointer to the pdl data structure (pdl *) of ndarray C<a>
 
=item $ISBAD(a())
 
returns true if the value stored in C<a()> equals the bad value
for this ndarray. 
Requires C<HandleBad> being set to 1.
 
=item $ISGOOD(a())
 
returns true if the value stored in C<a()> does not equal the bad value
for this ndarray.
Requires C<HandleBad> being set to 1.
 
=item $SETBAD(a())
 
Sets C<a()> to equal the bad value for this ndarray.
Requires C<HandleBad> being set to 1.
 
=back
 
=head2 functions
 
=over 3
 
=item C<loop(DIMS) %{ ... %}>
 
loop over named dimensions; limits are generated automatically by PP
 
=item C<threadloop %{ ... %}>
 
enclose following code in a thread loop
 
=item C<types(TYPES) %{ ... %}>
 
execute following code if type of operation is any of C<TYPES>
 
=back
 
=head1 Appendix C: Functions imported by PDL::PP
 
A number of functions are imported when you C<use PDL::PP>. These include
functions that control the generated C or XS code, functions that control
the generated Perl code, and functions that manipulate the packages and
symbol tables into which the code is created.
 
=head2 Generating C and XS Code
 
PDL::PP's main purpose is to make it easy for you to wrap the threading
engine around your own C code, but you can do some other things, too.
 
=over
 
=item pp_def
 
Used to wrap the threading engine around your C code. Virtually all of this
document discusses the use of pp_def.
 
=item pp_done
 
Indicates you are done with PDL::PP and that it should generate its .xs
and .pm files based upon the other pp_* functions that you have called.
This function takes no arguments.
 
=item pp_addxs
 
This lets you add XS code to your .xs file. This is useful if you want to
create Perl-accessible functions that invoke C code but cannot or should not
invoke the threading engine. XS is the standard means by which you wrap
Perl-accessible C code. You can learn more at L<perlxs>.
 
=item pp_add_boot
 
This function adds whatever string you pass to the XS BOOT section. The BOOT
section is C code that gets called by Perl when your module is loaded and is
useful for automatic initialization. You can learn more about XS and the BOOT
section at L<perlxs>.
 
=item pp_addhdr
 
Adds pure-C code to your XS file. XS files are structured such that pure C
code must come before XS specifications. This allows you to specify such
C code.
 
=item pp_boundscheck
 
PDL normally checks the bounds of your accesses before making them. You can
turn that on or off at runtime by setting MyPackage::set_boundscheck. This
function allows you to remove that runtime flexibility and B<never> do bounds
checking. It also returns the current boundschecking status if called
without any argumens.
 
NOTE: I have not found anything about bounds checking in other documentation.
That needs to be addressed.
 
=back
 
=head2 Generating Perl Code
 
Many functions imported when you use PDL::PP allow you to modify the
contents of the generated .pm file. In addition to pp_def and pp_done,
the role of these functions is primarily to add code to various parts of
your generated .pm file.
 
=over
 
=item pp_addpm
 
Adds Perl code to the generated .pm file. PDL::PP actually keeps track of
three different sections of generated code: the Top, the Middle, and the
Bottom. You can add Perl code to the Middle section using the one-argument
form, where the argument is the Perl code you want to supply. In the
two-argument form, the first argument is an anonymous hash with only
one key that specifies where to put the second argument, which is the string
that you want to add to the .pm file. The hash is one of these three:
 
 {At => 'Top'}
 {At => 'Middle'}
 {At => 'Bot'}
 
For example:
 
 pp_addpm({At => 'Bot'}, <<POD);
  
 =head1 Some documentation
  
 I know I'm typing this in the middle of my file, but it'll go at
 the bottom.
  
 =cut
  
 POD
 
Warning: If, in the middle of your .pd file, you put documentation meant for
the bottom of your pod, you will thoroughly confuse CPAN. On the other hand,
if in the middle of your .pd file, you add some Perl code destined for the
bottom or top of your .pm file, you only have yourself to confuse. :-)
 
=item pp_beginwrap
 
Adds BEGIN-block wrapping. Certain declarations can be wrapped in BEGIN
blocks, though the default behavior is to have no such wrapping.
 
=item pp_addbegin
 
Sets code to be added to the top of your .pm file, even above code that you
specify with C<< pp_addpm({At => 'Top'}, ...) >>. Unlike pp_addpm, calling
this overwrites whatever was there before. Generally, you probably shouldn't
use it.
 
=back
 
=head2 Tracking Line Numbers
 
When you get compile errors, either from your C-like code or your Perl
code, it can help to make those errors back to the line numbers in the source
file at which the error occurred.
 
=over
 
=item pp_line_numbers
 
Takes a line number and a (usually long) string of code. The line number
should indicate the line at which the quote begins. This is usually Perl's
C<__LINE__> literal, unless you are using heredocs, in which case it is
C<__LINE__ + 1>. The returned string has #line directives interspersed to
help the compiler report errors on the proper line.
 
=back
 
=head2 Modifying the Symbol Table and Export Behavior
 
PDL::PP usually exports all functions generated using pp_def, and usually
installs them into the PDL symbol table. However, you can modify this
behavior with these functions.
 
=over
 
=item pp_bless
 
Sets the package (symbol table) to which the XS code is added. The default
is PDL, which is generally what you want. If you use the default blessing
and you create a function myfunc, then you can do the following:
 
 $ndarray->myfunc(<args>);
 PDL::myfunc($ndarray, <args>);
 
On the other hand, if you bless your functions into another package, you
cannot invoke them as PDL methods, and must invoke them as:
 
 MyPackage::myfunc($ndarray, <args>);
 
Of course, you could always use the PMFunc key to add your function to the
PDL symbol table, but why do that?
 
=item pp_add_isa
 
Adds to the list of modules from which your B<module> inherits. The default
list is
 
 qw(PDL::Exporter DynaLoader)
 
=item pp_core_importlist
 
At the top of your generated .pm file is a line that looks like this:
 
 use PDL::Core;
 
You can modify that by specifying a string to pp_core_importlist. For
example,
 
 pp_core_importlist('::Blarg');
 
will result in
 
 use PDL::Core::Blarg;
 
You can use this, for example, to add a list of symbols to import from
PDL::Core. For example:
 
 pp_core_importlist(" ':Internal'");
 
will lead to the following use statement:
 
 use PDL::Core ':Internal';
 
=item pp_setversion
 
Sets your module's version. The version must be consistent between the .xs
and the .pm file, and is used to ensure that your Perl's libraries do not
suffer from version skew.
 
=item pp_add_exported
 
Adds to the export list whatever names you give it.  Functions created using
pp_def are automatically added to the list. This function is useful if you
define any Perl functions using pp_addpm or pp_addxs that you want exported
as well.
 
=item pp_export_nothing
 
This resets the list of exported symbols to nothing. This is probably better
called C<pp_export_clear>, since you can add exported symbols after calling
C<pp_export_nothing>. When called just before calling pp_done, this ensures
that your module does not export anything, for example, if you only want
programmers to use your functions as methods.
 
=back
 
=head1 SEE ALSO
 
I<PDL>
 
For the concepts of threading and slicing check L<PDL::Indexing>.
 
L<PDL::Internals>
 
L<PDL::BadValues> for information on bad values
 
I<perlxs>, I<perlxstut>
 
L<Practical Magick with C, PDL, and PDL::PP -- a guide to compiled
add-ons for PDL|https://arxiv.org/abs/1702.07753>
 
=head1 CURRENTLY UNDOCUMENTED
 
Almost everything having to do with L<Slice operation>. This includes much of the following (each entry is followed by a guess/description of where it is used or defined):
 
=over 3
 
=item MACROS
 
$CDIM()
 
$CHILD()
    PDL::PP::Rule::Substitute::Usual
 
$CHILD_P()
    PDL::PP::Rule::Substitute::Usual
 
$CHILD_PTR()
    PDL::PP::Rule::Substitute::Usual
 
$COPYDIMS()
 
$COPYINDS()
 
$CROAK()
    PDL::PP::Rule::Substitute::dosubst_private()
 
$DOCOMPDIMS()
    Used in slices.pd, defined where?
 
$DOPRIVDIMS()
    Used in slices.pd, defined where?
    Code comes from PDL::PP::CType::get_malloc, which is called by PDL::PP::CType::get_copy, which is called by PDL::PP::CopyOtherPars, PDL::PP::NT2Copies__, and PDL::PP::make_incsize_copy.  But none of those three at first glance seem to have anything to do with $DOPRIVDIMS
 
 
$EQUIVCPOFFS()
 
$EQUIVCPTRUNC()
 
$PARENT()
    PDL::PP::Rule::Substitute::Usual
 
$PARENT_P()
    PDL::PP::Rule::Substitute::Usual
 
$PARENT_PTR()
    PDL::PP::Rule::Substitute::Usual
 
 
$PDIM()
 
$PRIV()
    PDL::PP::Rule::Substitute::dosubst_private()
 
$RESIZE()
 
$SETDELTATHREADIDS()
    PDL::PP::Rule::MakeComp
 
$SETDIMS()
    PDL::PP::Rule::MakeComp
 
$SETNDIMS()
    PDL::PP::Rule::MakeComp
 
$SETREVERSIBLE()
    PDL::PP::Rule::Substitute::dosubst_private()
 
=item Keys
 
AffinePriv
 
BackCode
 
BadBackCode
 
CallCopy
 
Comp (related to $COMP()?)
 
DefaultFlow
 
EquivCDimExpr
 
EquivCPOffsCode
 
EquivDimCheck
 
EquivPDimExpr
 
FTypes (see comment in this POD's source file between NoPthread and PMCode.)
 
GlobalNew
 
Identity
 
MakeComp
 
NoPdlThread
 
P2Child
 
ParentInds
 
Priv
 
ReadDataFuncName
 
RedoDims (related to RedoDimsCode ?)
 
Reversible
 
WriteBckDataFuncName
 
XCHGOnly
 
=back
 
=head1 BUGS
 
Although PDL::PP is quite flexible and thoroughly used, there are surely
bugs. First amongst them: this documentation needs a thorough revision.
 
=head1 AUTHOR
 
Copyright(C) 1997 Tuomas J. Lukka (lukka@fas.harvard.edu), Karl
Glaazebrook (kgb@aaocbn1.aao.GOV.AU) and Christian Soeller
(c.soeller@auckland.ac.nz). All rights reserved.
Documentation updates Copyright(C) 2011 David Mertens
(dcmertens.perl@gmail.com). This documentation is licensed under the same
terms as Perl itself.