#!/usr/bin/perl
#!-*- coding: utf-8 -*-

=encoding utf8
 
=head1 NAME
 
Inline::CPP - Write Perl subroutines and classes in C++.
 
=head1 SYNOPSIS
 
    use Inline CPP;
 
    print "9 + 16 = ", add(9, 16), "\n";
    print "9 - 16 = ", subtract(9, 16), "\n";
 
    __END__
    __CPP__
 
    int add(int x, int y) {
      return x + y;
    }
 
    int subtract(int x, int y) {
      return x - y;
    }
 
=head1 DESCRIPTION
 
The L<Inline::CPP> module allows you to put C++ source code directly
"inline" in a Perl script or module. You code classes or functions in
C++, and you can use them as if they were written in Perl.
 
=head1 RATIONALE
 
"I<We should forget about small efficiencies, say about 97% of the time:
premature optimization is the root of all evil. Yet we should not pass up our
opportunities in that critical 3%. A good programmer will not be lulled into
complacency by such reasoning, he will be wise to look carefully at the
critical code; but only after that code has been identified>" -- Donald Knuth
 
L<Inline::CPP> is about that critical 3%.
 
Tom "Duff's Device" Duff once wrote the following: "I<The alternative to
genuflecting before the god of code-bumming is finding a better algorithm...
...If your code is too slow, you must make it faster.  If no better algorithm
is available, you must trim cycles.>"
 
Often, well written Perl is fast enough.  But when one comes across a situation
where performance isn't fast enough, and no better algorithm exists, getting
closer to the metal is one way to trim cycles, assuming it's done well.
L<Inline::CPP> minimizes the pain in binding C++ code to Perl via XS.
 
Performance can also be evaluated in terms of memory requirements.  Perlish
datastructures are beautifully simple to use, and quite powerful.  But this
beauty and power comes at the cost of memory and speed.  If you are finding that
it is too memory-expensive to hold your data in a Perl array, and a
disk-based solution is, for whatever reason, not an option, the memory burden
can be aleviated to some degree by holding the data in a C++ data type.
 
This can only go so far.  But the common saying is that if you consider a
reasonable amount of memory to hold a data structure, double it, and then
multiply by ten, you'll have a pretty good feel for how much memory Perl needs
to hold it.  Inline::CPP can facilitate a leaner alternative.
 
"I<The standard library saves programmers from having to reinvent the wheel.>"
-- Bjarne Stroustrup
 
L<Inline::CPP> is also about not reinventing the wheel.
 
There are many C and C++ libraries already in existence that provide
functionality that is well tested, well debuged, and well understood.  There is
often no great benefit aside from portability in rewriting such libraries in
pure Perl.  Even re-writing them in XS is cumbersome and prone to bugs.
Inline::CPP can be used to quickly develop Perl bindings to existing C++
libraries.
 
"I<Brian Ingerson got fed up with writing XS and ended up writing
a very clever Perl module called L<Inline> to do it for him.>"
 
Face it, XS has a big fat learning curve, lots of boilerplate, and is easy to
botch it up in difficult to find ways.  Inline::CPP exists to make that process
easier.  By lightening the cognative load and boilerplate drudgery associated
with pure XS, Inline::CPP can aid the developer in producing less buggy
extension code.  It won't shield you entirely from C<perlguts>, but it will
take the edge off of it.
 
=head1 Choosing a C++ Compiler
 
Inline::CPP just parses the subroutine and class signatures within your C++
code and creates bindings to them. Like Inline::C, you will need a suitable
compiler the first time you run the script.
 
If you're one of the fortunate majority, you will accept the defaults as you
install Inline::CPP; the correct C++ compiler and standard libraries will be
configured for you.  If you're one of the unfortunate (and shrinking) minority,
read on.
 
Here's the rule: use a C++ compiler that's compatible with the compiler
which built C<perl>. For instance, if C<perl> was built with C<gcc>,
use C<g++>.  If you're on a Sun or an IRIX box and the system C compiler
C<cc> built C<perl>, then use the system C++ compiler, C<CC>.
 
Some compilers actually compile both C and C++ with the same compiler.
Microsoft's C<cl.exe> is one such compiler -- you pass it the <-TP> flag
to convince it that you want C++ mode.  Hopefully this will be deduced
by default at install time.
 
If you're using the GNU C++ compiler, make sure that you have the g++ front
end installed (some Linux distros don't install it by default, but provide
it via their package management utilities).
 
=head1 Using Inline::CPP
 
Inline::CPP is very similar to Inline::C, and in most cases can be used in
place of Inline::C without changing a single line of Perl or C code. If you
haven't done so already, you should stop reading right now and read the
documentation for L<Inline::C>, including the L<Inline::C-Cookbook>.
 
This module uses a  grammar to parse your C++ code, and binds to functions or
classes which are recognized. If a function is recognized, it will be available
from Perl space. If the function's signature is not recognized, it will not
be available from Perl, but will be available from other functions or classes
within the C++ code.
 
The following example shows how C++ snippets map to Perl:
 
Example 1:
 
    use Inline CPP => <<'END';
 
    using namespace std;
 
    int doodle() { }
 
    class Foo {
     public:
       Foo();
       ~Foo();
 
       int get_data() { return data; }
       void set_data(int a) { data = a; }
     private:
       int data;
    };
 
    Foo::Foo() { cout << "creating a Foo()" << endl; }
    Foo::~Foo() { cout << "deleting a Foo()" << endl; }
 
    END
 
After running the code above, your Perl runtime would look similar to if
following code had been run:
 
    sub main::doodle { }
 
    package main::Foo;
 
    sub new { print "creating a Foo()\n"; bless {}, shift }
    sub DESTROY { print "deleting a Foo()\n" }
 
    sub get_data { my $o=shift; $o->{data} }
    sub set_data { my $o=shift; $o->{data} = shift }
 
The difference, of course, is that in the latter, Perl does the work. In the
Inline::CPP example, all function calls get sent off to your C++ code. That
means that things like this won't work:
 
    my $obj = new Foo;
    $obj->{extrafield} = 10;
 
It doesn't work because C<$obj> is not a blessed hash. It's a blessed
reference to a C++ object.
 
=head1 C++ Compilation Phase
 
The first time you run a program that uses Inline::CPP, the C++ code will be
compiled into an C<_Inline/> or C<.Inline/> folder within the working directory.
The first run will incur a startup time penalty associated with compiling C++
code.  However, the compiled code is cached, and assuming it's not modified,
subsequent runs will skip the C++ compilation, and startup time will be fast.
 
=head1 Where to put C++ code
 
Inline C++ code can reside just about anywhere you want within your Perl code.
Much of this is documented more fully in the L<Inline> POD, but here are some
basics:
 
    use Inline CPP => 'DATA';
 
    # Perl code here
 
    __DATA__
    __CPP__
 
    // C++ code here.
 
Or....
 
    use Inline CPP => <<'END_CPP';
        // C++ code here.
    END_CPP
 
Structurally where does it belong?  For simple one-off scripts, just put it
anywhere you want.  But in the spirit of code reusability, it's often better to
simply create a module that houses the functionality build upon C++ code:
 
    # Foo/Bar.pm
    package Foo::Bar;
    use Inline CPP => 'DATA';
 
    # Perl code here, including Exporter mantra, if needed.
 
    __DATA__
    __CPP__
    // C++ here.....
 
Where you place your module's file(s) follows the same rules as plain old Perl,
which is beyond the scope of this POD, but fortunatly no different from what
you're used to (assuming you're used to writing Perl modules).
 
Of course, modules can be shared by multiple scripts while only incurring that
compilation startup penalty one time, ever.
 
=head1 Basing (CPAN) Distributions on Inline::CPP
 
Taking the concept of code-reuse one step further, it is entirely possible to
package a distribution with an Inline::CPP dependency.  When the user installs
the distribution (aka, the module), the C++ code will be compiled during module
build time, and never again (unless the user upgrades the module).  So the user
will never see the startup lag associated with C++ code compilation.
 
An example and proof-of-concept for this approach can be found in the CPAN
module L<Math::Prime::FastSieve>.
 
This approach involves using L<Inline::MakeMaker>, and is well documented in
the L<Inline> POD under the heading
L<Writing Modules with Inline|http://search.cpan.org/perldoc?Inline#Writing_Modules_with_Inline>
 
However, you may wish to remove the Inline::CPP dependency altogether from the
code that you bundle into a distribution.  This can be done using
L<InlineX::CPP2XS>, which converts the Inline::CPP generated code to
Perl XS code, fit for distribution without the Inline::CPP dependency.
L<InlineX::CPP2XS> includes an example/ directory that actually converts
Math::Prime::FastSieve to pure XS.
 
Some extension authors choose to implement first in Inline::CPP, and then
manually tweak, then copy and paste the resulting XS file into their own
distribution, with similar effect (and possibly a little finer-grained control)
to the CPP2XS approach.
 
=head2 Perl Namespaces
 
Let's say you use Inline::CPP like this:
 
    package Some::Foo;
    use Inline CPP => <<'END_CPP';
 
    #include <iostream>
    using namespace std;
 
    class Foo {
      private:
        int data;
      public:
        Foo()  { cout << "creating a Foo()" << endl; }
        ~Foo() { cout << "deleting a Foo()" << endl; }
    };
 
    END_CPP
    1;
 
The issue is that the C++ class, "C<Foo>" will be mapped to Perl below the
C<Some::Foo> namespace, as C<Some::Foo::Foo>, and would need to be instantiated
like this: C<< my $foo = Some::Foo::Foo->new() >>.  This probably isn't what
the user intended. Use the L<namespace> configuration option to set your base
namespace:
 
    use Inline CPP => config => namespace => 'Some';
 
Now, C<Foo> falls under the C<Some> heirarchy: C<Some::Foo>, and can be
instantiated as C<< my $foo = Some::Foo->new() >>.  This probably I<is> what the
user intended.
 
=head1 C++ Configuration Options
 
For information on how to specify Inline configuration options, see
L<Inline>. This section describes each of the configuration options
available for C/C++. Most of the options correspond either to the MakeMaker
or XS options of the same name. See L<ExtUtils::MakeMaker> and
L<perlxs>.
 
All configuration options, including the word C<config> are case insensitive.
C<CPP>, and C<DATA> are not configuration options, and are not insensitive to
case.
 
=head2 altlibs
 
Adds a new entry to the end of the list of alternative libraries to
bind with. MakeMaker will search through this list and use the first
entry where all the libraries are found.
 
    use Inline CPP => config => altlibs => '-L/my/other/lib -lfoo';
 
See also the C<libs> config option, which appends to the last entry in
the list.
 
=head2 auto_include
 
Specifies extra statements to be automatically included. They will be
added on to the defaults. A newline char will automatically be added.
 
    use Inline CPP => config => auto_include => '#include "something.h"';
 
=head2 boot
 
Specifies code to be run when your code is loaded. May not contain any
blank lines. See L<perlxs> for more information.
 
    use Inline CPP => config => boot => 'foo();';
 
=head2 cc
 
Specifies which compiler to use.  In most cases the configuration default is
adequate.
 
    use Inline CPP => config => cc => '/usr/bin/g++-4.6';
 
=head2 ccflags
 
Specifies extra compiler flags. Corresponds to the MakeMaker option.
 
    use Inline CPP => config => ccflags => '-std=c++11';
 
=head2 classes
 
    use Inline CPP => config =>
        classes => { 'CPPFoo' => 'PerlFoo', 'CPPBar' => 'PerlBar' };
 
    use Inline CPP => config =>
        namespace => 'Qux' =>
        classes => { 'CPPFoo' => 'PerlFoo', 'CPPBar' => 'PerlBar' };
 
    use Inline CPP => config =>
        classes => sub {
            my $cpp_class = shift;
            ...
            return($perl_package);
        };
 
Override C++ class name.
 
Under default behavior, a C++ class naming conflict will arise by attempting
to implement the C++ classes C<Foo::Bar::MyClass> and C<Foo::Qux::MyClass>
which depend upon one another in some way, because C++ sees both classes as
named only C<MyClass>.  We are unable to solve this C++ conflict by using just
the C<namespace> config option, because C<namespace> is only applied to the
Perl package name, not the C++ class name.
 
In the future, this issue may be solved via Inline::CPP suport for the native
C++ C<namespace> operator and/or C++ class names which contain the C<::>
double-colon scope token.
 
For now, this issue is solved by using the C<classes> config option, which
accepts either a hash reference or a code reference.  When a hash reference
is provided, each hash key is a C++ class name, and each hash value is a
corresponding Perl class name.  This hash reference serves as a C++-to-Perl
class name mapping mechanism, and may be used in combination with the
C<namespace> config option to exercise full control over class and package
naming.
 
When a code reference is provided, it must accept as its sole argument the C++
class name, and return a single string value containing the generated Perl
package name.  When a code reference is provided for the C<classes> config
option, the value of the C<namespace> config option is ignored.
 
The hash reference may be considered a manual mapping method, and the code
reference an automatic mapping method.
 
Example file C</tmp/Foo__Bar__MyClass.c>:
 
    class MyClass {
      private:
        int a;
      public:
        MyClass() :a(10) {}
        int fetch () { return a; }
    };
 
Example file C</tmp/Foo__Qux__MyClass.c>:
 
    #include "/tmp/Foo__Bar__MyClass.c"
    class MyClass {
      private:
        int a;
      public:
        MyClass() :a(20) {}
        int fetch () { return a; }
        int other_fetch () { MyClass mybar; return mybar.fetch(); }
    };
 
We encounter the C++ class naming conflict when we
 
    use Inline CPP => '/tmp/Foo__Qux__MyClass.c' => namespace => 'Foo::Qux';
 
The C++ compiler sees two C<MyClass> classes and gives a redefinition error:
 
    _08conflict_encounter_t_9d68.xs:25:7: error: redefinition of ‘class MyClass’
     class MyClass {
           ^
    In file included from _08conflict_encounter_t_9d68.xs:24:0:
    /tmp/Foo__Bar__MyClass.c:1:7: error: previous definition of ‘class MyClass’
     class MyClass {
           ^
 
The solution is to rename each C<MyClass> to utilize unique class names, such as
C<Foo__Bar__MyClass> and C<Foo__Qux__MyClass>, and use the C<classes> config option.
 
Updated example file C</tmp/Foo__Bar__MyClass.c>:
 
    class Foo__Bar__MyClass {
      private:
        int a;
      public:
        Foo__Bar__MyClass() :a(10) {}
        int fetch () { return a; }
    };
 
Updated example file C</tmp/Foo__Qux__MyClass.c>:
 
    #include "/tmp/Foo__Bar__MyClass.c"
    class Foo__Qux__MyClass {
      private:
        int a;
      public:
        Foo__Qux__MyClass() :a(20) {}
        int fetch () { return a; }
        int other_fetch () { Foo__Bar__MyClass mybar; return mybar.fetch(); }
    };
 
First, consider the following updated call to Inline using the hash reference
method to manually map the namespace and class names.  This example does not
give any C++ errors, and runs correctly in both C++ and Perl:
 
    use Inline  CPP => '/tmp/Foo__Qux__MyClass.c' =>
                namespace => 'Foo' =>
                classes => { 'Foo__Bar__MyClass' => 'Bar::MyClass',
                             'Foo__Qux__MyClass' => 'Qux::MyClass' };
 
Next, consider another updated call to Inline using the code reference method
to automatically map the namespace and class names, which may be deployed across
more complex codebases.  This example automates the mapping of the '__' double-
underscore to the '::' double-colon scope token.
 
    use Inline CPP => config =>
        classes => sub { join('::', split('__', shift)); };
 
For more information, please see the runnable examples:
C<t/classes/07conflict_avoid.t>
C<t/classes/08auto.t>
C<t/classes/09auto_mixed.t>
 
=head2 filters
 
Specifies one (or more, in an array ref) filter which is to be applied to
the code just prior to parsing. The filters are executed one after another,
each operating on the output of the previous one. You can pass in a code
reference or the name of a prepackaged filter.
 
    use Inline CPP => config => filters => [Strip_POD => \&myfilter];
    use Inline CPP => config => filters => 'Preprocess';  # Inline::Filters
 
The filter may do anything. The code is passed as the first argument, and
it returns the filtered code.  For a set of prefabricated filters, consider
using L<Inline::Filters>.
 
=head2 inc
 
Specifies extra include directories. Corresponds to the MakeMaker
parameter.
 
    use Inline CPP => config => inc => '-I/my/path';
 
=head2 ld
 
Specifies the linker to use.
 
=head2 lddlflags
 
Specifies which linker flags to use.
 
NOTE: These flags will completely override the existing flags, instead
of just adding to them. So if you need to use those too, you must
respecify them here.
 
=head2 libs
 
Specifies external libraries that should be linked into your
code. Corresponds to the MakeMaker parameter.
 
    use Inline CPP => config => libs => '-L/your/path -lyourlib';
 
Unlike the C<libs> configuration parameter used in Inline::C, successive
calls to C<libs> append to the previous calls. For example,
 
    use Inline CPP => config => libs => '-L/my/path', libs => '-lyourlib';
 
will work correctly, if correct is for both C<libs> to be in effect. If you
want to add a new element to the list of possible libraries to link with, use
the Inline::CPP configuration C<altlibs>.
 
=head2 make
 
Specifies the name of the 'C<make>' utility to use.
 
=head2 myextlib
 
Specifies a user compiled object that should be linked in. Corresponds
to the MakeMaker parameter.
 
    use Inline CPP => config => myextlib => '/your/path/something.o';
 
=head2 namespace
 
    use Inline CPP => config => namespace => 'Foo';
    use Inline CPP => config => namespace => 'main';
    use Inline CPP => config => namespace => q{};
 
Override default base namespace.
 
Under default behavior, a C++ class C<Foo> created by invoking L<Inline::CPP>
from C<package Bar> will result in the C++ C<Foo> class being accessible from
Perl as C<Bar::Foo>.  While this default behavior may be desirable in some
cases, it might be undesirable in others.  An example would be creating a C<Foo>
class while invoking Inline::CPP from package C<Foo>.  The resulting class will
bind to Perl as C<Foo::Foo>, which is probably not what was intended.
 
This default behavior can be overridden by specifying an alternate base
C<namespace>.  Examples are probably the best way to explain this:
 
 
    package Foo;
    use Inline CPP => config => namespace => 'Bar';
    use Inline CPP => <<'EOCPP';
 
    class Baz {
      private:
        int a;
      public:
        Baz() :a(20) {}
        int fetch () { return a; }
    };
    EOCPP
 
    package main;
    my $b = Bar::Baz->new();
    print $b->fetch, "\n"; # 20.
 
 
As demonstrated here, the namespace in which "Baz" resides can now be made
independent of the package from which L<Inline::CPP> has been invoked.
Consider instead the default behavior:
 
 
    package Foo;
    use Inline CPP => <<'EOCPP';
    class Foo {
      private:
        int a;
      public:
        Baz() :a(20) {}
        int fetch () { return a; }
    };
    EOCPP
 
    package main;
    my $b = Foo::Foo->new();
    print $b->fetch, "\n"; # 20.
 
 
It is probably, in this case, undesirable for the C++ class C<Foo> to reside in
the Perl C<Foo::Foo> namespace.  We can fix this by adding our own namespace
configuration:
 
 
    package Foo;
    use Inline CPP => config => namespace => q{};  # Disassociate from
                                                   # calling package.
    use Inline CPP => <<'EOCPP';
 
    class Baz {
      private:
        int a;
      public:
        Baz() :a(20) {}
        int fetch () { return a; }
    };
    EOCPP
 
    package main;
    my $b = Foo->new();
    print $b->fetch, "\n"; # 20.
 
=head2 prefix
 
Specifies a prefix that will automatically be stripped from C++
functions when they are bound to Perl. Less useful than in C, because
C++ mangles its function names to facilitate function overloading.
 
    use Inline CPP config => prefix => 'ZLIB_';
 
This only affects C++ function names, not C++ class names or methods.
 
=head2 preserve_ellipsis
 
By default, Inline::CPP replaces C<...> in bound functions with three
spaces, since the arguments are always passed on the Perl Stack, not on
the C stack. This is usually desired, since it allows functions with
no fixed arguments (most compilers require at least one fixed argument).
 
    use Inline CPP config => preserve_ellipsis => 1;
or
    use Inline CPP config => enable => 'preserve_ellipsis';
 
For an example of why C<preserve_ellipsis> is normally not needed, see the
examples section, below.
 
=head2 std_iostream
 
By default, Inline::CPP includes the standard iostream header at the top
of your code.  Inline::CPP will try to make the proper selection between
C<iostream.h> (for older compilers) and C<iostream> (for newer "Standard
compliant" compilers).
 
This option assures that C<iostream> (with no C<.h>) is included, which is the
ANSI-compliant version of the header. For most compilers the use of this
configuration option should no longer be necessary, as detection is done at
module install time.  The configuration option is still included only to
maintain backward compatibility with code that used to need it.
 
    use Inline CPP => config => enable => 'std_iostream';
 
=head2 structs
 
Specifies whether to bind C structs into Perl using L<Inline::Struct>.
NOTE: Support for this option is experimental. L<Inline::CPP> already binds
to structs defined in your code. In C++, structs and classes are treated the
same, except that a struct's initial scope is public, not private.
L<Inline::Struct> provides autogenerated get/set methods, an overloaded
constructor, and several other features not available in L<Inline::CPP>.
 
You can invoke C<structs> in several ways:
 
    use Inline CPP config => structs => 'Foo';
or
    use Inline CPP config => structs => ['Bar', 'Baz'];
 
Binds the named structs to Perl. Emits warnings if a struct was requested
but could not be bound for some reason.
 
    use Inline CPP config => enable => 'structs';
or
    use Inline CPP config => structs => 1;
 
Enables binding structs to Perl. All structs which can be bound, will. This
parameter overrides all requests for particular structs.
 
    use Inline CPP config => disable => 'structs';
or
    use Inline CPP config => structs => 0;
 
Disables binding structs to Perl. Overrides any other settings.
 
See L<Inline::Struct> for more details about how C<Inline::Struct>
binds C structs to Perl.
 
=head2 typemaps
 
Specifies extra typemap files to use. These types will modify the
behaviour of C++ parsing. Corresponds to the MakeMaker parameter.
 
    use Inline CPP config => typemaps => '/your/path/typemap';
 
=head1 C++-Perl Bindings
 
This section describes how the C<Perl> variables get mapped to C<C++>
variables and back again.
 
Perl uses a stack to pass arguments back and forth to subroutines. When
a sub is called, it pops off all its arguments from the stack; when it's
done, it pushes its return values back onto the stack.
 
XS (Perl's language for creating C or C++ extensions for Perl) uses
"typemaps" to turn SVs into C types and back again. This is done through
various XS macro calls, casts, and the Perl API. XS also allows you to
define your own mappings.
 
C<Inline::CPP> uses a much simpler approach. It parses the system's
typemap files and only binds to functions with supported types. You
can tell C<Inline::CPP> about custom typemap files too.
 
If you have non-trivial data structures in either C++ or Perl,
you should probably just pass them as an SV* and do the conversion yourself in
your C++ function.
 
In C++, a struct is a class whose default scope is public, not
private.  Inline::CPP binds to structs with this in mind -- get/set
methods are not yet auto-generated (although this feature may be added to
an upcoming release).
 
If you have a C struct, you can use Inline::Struct to allow Perl
complete access to the internals of the struct. You can create and
modify structs from inside Perl, as well as pass structs into C++
functions and return them from functions. Please note that
Inline::Struct does not understand any C++ features, so constructors
and member functions are not supported. See L<Inline::Struct> for more
details.
 
=head2 Example
 
Say you want to use a C++ standard C<string> type. A C++ method that
takes or returns such will be ignored unless you tell Perl how to map
it to and from Perl data types.
 
Put this in a file called F<typemap>:
 
  TYPEMAP
  string  T_CPPSTRING
 
  INPUT
 
  T_CPPSTRING
          $var = ($type)SvPV_nolen($arg)
 
  OUTPUT
 
  T_CPPSTRING
          sv_setpv((SV*)$arg, $var.c_str());
 
Then this script will work:
 
  use Inline CPP => config => typemaps => "typemap";
  use Inline CPP => <<'END';
 
  #ifdef __INLINE_CPP_STANDARD_HEADERS
  #include <string>
  #else
  #include <string.h>
  #endif
 
  #ifdef __INLINE_CPP_NAMESPACE_STD
  using namespace std;
  #endif
 
  class Abstract {
    public:
          virtual string greet2() {
              string retval = "yo";
              return retval;
          }
  };
 
  class Impl : public Abstract {
    public:
      Impl() {}
      ~Impl() {}
  };
  END
 
  my $o = Impl->new;
  print $o->greet2, "\n";
 
See F<t/grammar/09purevt.t> for this within the test suite.
 
=head1 <iostream>, Standard Headers, C++ Namespaces, and Portability Solutions
 
Inline::CPP automatically includes <iostream>, or <iostream.h>, depending on the
preference of the target compiler.  This distinction illustrates a potential
problem when trying to write portable code in C++.  Legacy C++
(pre-ANSI-Standard) used headers named, for example, <iostream.h>.  As legacy
C++ didn't support namespaces, these standard tools were not segregated into a
separate namespace.
 
ANSI Standard C++ changed that.  Headers were renamed without the '.h' suffix,
and standard tools were placed in the 'C<std>' namespace.  The
C<using namespace std> and C<using std::string> constructs were also added to
facilitate working with namespaces.
 
So pre-Standard (Legacy) C++ code might look like this:
 
   #include <iostream.h>
   int main() {
       cout << "Hello world.\n";
       return 0;
   }
 
Modern "ANSI Standard C++" compilers would require code like this:
 
   #include <iostream>
   using namespace std;
   int main() {
       cout << "Hello world.\n";
       return 0;
   }
 
... or ...
 
   #include <iostream>
   int main() {
       std::cout << "Hello world.\n";
       return 0;
   }
 
... or even ...
 
   #include <iostream>
   int main() {
       using std::cout;
       cout << "Hello world.\n";
       return 0;
   }
 
The first snippet is going to be completely incompabible with the second, third
or fourth snippets.  This is no problem for a C++ developer who knows his target
compiler.  But Perl runs just about everywhere.  If similar portability
(including backward compatibility) is a design goal, Inline::CPP helps by
providing two C<#define> constants that may be checked to ascertain which style
of headers are being used.  The constants are:
 
   __INLINE_CPP_STANDARD_HEADERS
   __INLINE_CPP_NAMESPACE_STD
 
C<__INLINE_CPP_STANDARD_HEADERS> will be defined if the target compiler
accepts ANSI Standard headers, such as <iostream>.
C<__INLINE_CPP_NAMESPACE_STD> will be defined if the target compiler supports
namespaces.  Realistically the two are synonymous; ANSI Standard C++ uses
namespaces, places standard library tools in the C<std> namespace, and
invokes headers with the modern (no '.h' suffix) naming convention.  So if
one is defined they both should be.
 
They can be used as follows:
 
    use Inline CPP => 'DATA';
 
    greet();
 
    __DATA__
    __CPP__
 
    #ifdef __INLINE_CPP_STANDARD_HEADERS
    #include <string>
    #else
    #include <string.h>
    #endif
 
    #ifdef __INLINE_CPP_NAMESPACE_STD
    using namespace std;
    #endif
 
    void greet() {
        string mygreeting = "Hello world!\n";
        cout << mygreeting;
    }
 
You may decide that you don't care about maintaining portability with
compilers that lock you in to pre-Standadr C++ -- more than a decade behind us.
But if you do care (maybe you're basing a CPAN module on Inline::CPP), use these
preprocessor definitions as a tool in building a widely portable solution.
 
If you wish, you may C<#undef> either of those defs.  The definitions are
defined before any C<auto_include>s -- even <iostream>.  Consequently, you may
even list C<#undef __INLINE_CPP_....> within an C<auto_include> configuration
directive.  I'm not sure why it would be necessary, but could be useful in
testing.
 
Regardless of the header type, Inline::CPP will create the following definition
in all code it generates:
 
    #define __INLINE_CPP 1
 
This can be useful in constructing preprocessor logic that behaves differently
under Inline::CPP than under a non-Inline::CPP environment.
 
=head1 EXAMPLES
 
Here are some examples.
 
=head2 Example 1 - Farmer Bob
 
This example illustrates how to use a simple class (C<Farmer>) from
Perl. One of the new features in Inline::CPP is binding to classes
with inline method definitions:
 
   use Inline CPP;
 
   my $farmer = new Farmer("Ingy", 42);
   my $slavedriver = 1;
   while($farmer->how_tired < 420) {
     $farmer->do_chores($slavedriver);
     $slavedriver <<= 1;
   }
 
   print "Wow! The farmer worked ", $farmer->how_long, " hours!\n";
 
   __END__
   __CPP__
 
   class Farmer {
   public:
     Farmer(char *name, int age);
     ~Farmer();
 
     int how_tired() { return tiredness; }
     int how_long() { return howlong; }
     void do_chores(int howlong);
 
   private:
     char *name;
     int age;
     int tiredness;
     int howlong;
   };
 
   Farmer::Farmer(char *name, int age) {
     this->name = strdup(name);
     this->age = age;
     tiredness = 0;
     howlong = 0;
   }
 
   Farmer::~Farmer() {
     free(name);
   }
 
   void Farmer::do_chores(int hl) {
     howlong += hl;
     tiredness += (age * hl);
   }
 
=head2 Example 2 - Plane and Simple
 
This example demonstrates some new features of Inline::CPP: support for
inheritance and abstract classes. The defined methods of the abstract
class C<Object> are bound to Perl, but there is no constructor or
destructor, meaning you cannot instantiate an C<Object>.
 
The C<Airplane> is a fully-bound class which can be created and
manipulated from Perl.
 
   use Inline 'CPP';
 
   my $plane = new Airplane;
   $plane->print;
   if ($plane->isa("Object")) { print "Plane is an Object!\n"; }
   unless ($plane->can("fly")) { print "This plane sucks!\n"; }
 
   __END__
   __CPP__
 
   using namespace std;
 
   /* Abstract class (interface) */
   class Object {
   public:
     virtual void print() { cout << "Object (" << this << ")" << endl; }
     virtual void info() = 0;
     virtual bool isa(char *klass) = 0;
     virtual bool can(char *method) = 0;
   };
 
   class Airplane : public Object {
   public:
     Airplane() {}
     ~Airplane() {}
 
     virtual void info() { print(); }
     virtual bool isa(char *klass) { return strcmp(klass, "Object")==0; }
     virtual bool can(char *method) {
       bool yes = false;
       yes |= strcmp(method, "print")==0;
       yes |= strcmp(method, "info")==0;
       yes |= strcmp(method, "isa")==0;
       yes |= strcmp(method, "can")==0;
       return yes;
     }
   };
 
=head2 Example 3 - The Ellipsis Abridged
 
One of the big advantages of Perl over C or C++ is the ability to pass an
arbitrary number of arguments to a subroutine. You can do it in C, but it's
messy and difficult to get it right. All of this mess is necessary because
C doesn't give the programmer access to the stack. Perl, on the other hand,
gives you access to everything.
 
Here's a useful function written in Perl that is relatively slow:
 
   sub average {
      my $average = 0;
      for (my $i=0; $i<@_; $i++) {
         $average *= $i;
         $average += $_[$i];
         $average /= $i + 1;
      }
      return $average;
   }
 
Here's the same function written in C:
 
   double average() {
      Inline_Stack_Vars;
      double avg = 0.0;
      for (int i=0; i<Inline_Stack_Items; i++) {
         avg *= i;
         avg += SvNV(Inline_Stack_Item(i));
         avg /= i + 1;
      }
      return avg;
   }
 
Here's a benchmark program that tests which is faster:
 
    use Inline 'CPP';
    my @numbers = map { rand } (1 .. 10000);
    my ($a, $stop);
    $stop = 200;
    if (@ARGV) {
      $a = avg(@numbers) while $stop--;
    }
    else {
      $a = average(@numbers) while $stop--;
    }
    print "The average of 10000 random numbers is: ", $a, "\n";
 
    sub average {
       my $average = 0;
       for (my $i=0; $i<@_; $i++) {
           $average *= $i;
           $average += $_[$i];
           $average /= $i + 1;
       }
       return $average;
    }
 
    __END__
    __CPP__
 
    double avg(...) {
       Inline_Stack_Vars;
       double avg = 0.0;
       for (int i=0; i<items; i++) {
           avg *= i;
           avg += SvNV(ST(i));
           avg /= i + 1;
       }
       return avg;
    }
 
Look at the function declaration:
 
    double avg(...)
 
Why didn't we need to use varargs macros to get at the arguments? Why didn't
the compiler complain that there were no required arguments? Because
Inline::C++ actually compiled this:
 
    double avg(   )
 
When it bound to the function, it noticed the ellipsis and decided to get rid
of it. Any function bound to Perl that has an ellipsis in it will have its
arguments passed via the Perl stack, not the C stack. That means if you write
a function like this:
 
    void myprintf(char *format, ...);
 
then you'd better be reading things from the Perl stack. If you aren't, then
specify the PRESERVE_ELLIPSIS option in your script. That will leave the
ellipsis in the code for the compiler to whine about. :)
 
=head2 Example 4 - Stacks and Queues
 
Everyone who learns to program with C++ writes a stack and queue class sooner
or later. I might as well try it from Inline. But why reinvent the wheel?
Perl has a perfectly good Array type, which can easily implement both
a Queue and a Stack.
 
This example implements a Queue and a Stack class, and shows off just
a few more new features of Inline::CPP: default values to arguments,
 
    use Inline 'CPP';
 
    my $q = new Queue;
    $q->q(50);
    $q->q("Where am I?");
    $q->q("In a queue.");
    print "There are ", $q->size, " items in the queue\n";
    while($q->size) {
        print "About to dequeue:  ", $q->peek, "\n";
        print "Actually dequeued: ", $q->dq, "\n";
    }
 
    my $s = new Stack;
    $s->push(42);
    $s->push("What?");
    print "There are ", $s->size, " items on the stack\n";
    while($s->size) {
        print "About to pop:    ", $s->peek, "\n";
        print "Actually popped: ", $s->pop, "\n";
    }
 
    __END__
    __CPP__
 
    class Queue {
      public:
        Queue(int sz=0) { q = newAV(); if (sz) av_extend(q, sz-1); }
        ~Queue() { av_undef(q); }
 
        int size() {return av_len(q) + 1; }
 
        int q(SV *item) { av_push(q, SvREFCNT_inc(item)); return av_len(q)+1; }
        SV *dq() { return av_shift(q); }
        SV *peek() { return size() ? SvREFCNT_inc(*av_fetch(q,0,0)): &PL_sv_undef;}
 
      private:
        AV *q;
    };
 
    class Stack {
      public:
        Stack(int sz=0) { s = newAV(); if (sz) av_extend(s, sz-1); }
        ~Stack() { av_undef(s); }
 
        int size() { return av_len(s) + 1; }
 
        int push(SV *i) { av_push(s, SvREFCNT_inc(i)); return av_len(s)+1; }
        SV *pop() { return av_pop(s); }
        SV *peek() { return size() ? SvREFCNT_inc(*av_fetch(s,size()-1,0)) : &PL_sv_undef; }
 
      private:
        AV *s;
    };
 
=head2 Example 5 - Elipses Revisited (and Overloading or Templates)
 
This example of how to use elipses is adapted from a discussion on Perl Monks.
The issue was that someone wanted to call overloaded functions.  Perl doesn't
understand C++'s overloading rules, and C++ has no idea how Perl intends to call
the functions here.  So we write a wrapper to take control ourselves:
 
    use Inline CPP => 'DATA';
 
    say multiadd( 1 );          # No dispatch; just return the value.
    say multiadd( 1, 2 );       # Dispatch add( int, int ).
    say multiadd( 1, 2, 3 );    # Dispatch add( int, int, int ).
    say multiadd( 1, 2, 3, 4 ); # No dispatch; throw an exception.
    __DATA__
    __CPP__
 
    #include <stdexcept>
 
    // Inline::CPP won't create predictable bindings to overloaded functions.
 
    int add ( int a, int b ) {
      return a + b;
    }
 
    int add ( int a, int b, int c ) {
      return a + b + c;
    }
 
    // But a function call with elipses can dispatch to overloaded functions since
    // no Perl binding is required in reaching those functions.
    int multiadd ( SV * a, ... ) {
      dXSARGS;  // Creates a variable 'items' that contains a paramater count.
      try{
        switch ( items ) {
          case 1:  return SvIV(ST(0));
          case 2:  return add( SvIV(ST(0)), SvIV(ST(1)) );
          case 3:  return add( SvIV(ST(0)), SvIV(ST(1)), SvIV(ST(2)) );
          default: throw std::runtime_error(
            "multiadd() - Too many args in function call"
          );
        }
      }
      catch ( std::runtime_error msg ) {
        croak( msg.what() );  // Perl likes croak for exceptions.
      }
    }
 
Technically one of the versions of add() will bind to Perl, but it's fragile to
use it, as the rules for which one binds are undefined.  This example overcomes
the issue of Perl/XS not understanding overloading by simply wrapping the
calls to overloaded functions in a function that does understand.  And we use
elipses to deal with a variable number of arguments.  This same approach can be
applied to calling template-generated code as well.
 
=head1 Minimum Perl version requirements
 
As L<Inline> currently requires Perl 5.8.1 or later. Since L<Inline::CPP>
depends on L<Inline>, Perl 5.8.1 is also required for L<Inline::CPP>.  It's
hard to imagine anyone still using a Perl older than 5.8.1 wanting to
interface with C++, but if you're in that camp, you'll need to roll back
L<Inline> and L<Inline::CPP> to older versions through the magic of backpan.
L<Inline::CPP> version 0.25 was still compatible with Perl 5.005_03.  Review
the Changes file from the L<Inline> distribution to decide which L<Inline>
version is appropriate for your pre-5.8.1 Perl.
 
 
=head1 C++11 Standard
 
Is Inline::CPP is ready for the C++11 standard?  The short answer to that
question is "Mostly, to the extent that your compiler is C++11 standard
compliant."  There are two issues to consider.  First, what is your compiler
capable of (and how to you enable those capabilities), and second, what does
Perl need to care about.
 
Taking the first question first (because it's the easiest): Use the C<ccflags>
option shown above to pass the proper flag to your compiler to enable C++11
features.  Most of what your compiler will support, C<Inline::CPP> will deal
with.
 
You also may need to use the C<cc> flag to specify a newer version of the
compiler, if you happen to have more than one installed -- one that handles
C++11 and one that doesn't.
 
Now for the question of what Perl needs to care about:  L<Inline::CPP> doesn't
look inside of functions or methods.  That code is treated as a black box that
passes directly through to your compiler.  So inside of your functions and
methods, feel free to use whatever C++11 features you want.
 
The critical areas are function headers, class definitions, and code that falls
outside of functions or classes.  Take Enums for example:
 
    enum Colors { RED, GREEN, BLUE };
 
How should this map to Perl?  There's no clear answer.  C++11 adds the concept
of scope to enums:
 
    enum class Colors { RED, GREEN, BLUE };
 
How this should bind to Perl becomes even more difficult.  The fact is that
L<Inline::CPP> won't bind either to Perl.  And you're probably better off with
that approach than suddenly having $Colors::RED = 0; showing up in your Perl
code. Do keep in mind, however, the construct is passed directly through to
your C++ compiler, so feel free to use it within the C++ code.  It just won't
leak out into your Perl namespaces.
 
At the moment the most glaring omission from L<Inline::CPP> of valid C++11
syntax is the new "late return type" syntax.  C++11 introduced the following
legal syntax:
 
    auto add ( int x, int y ) -> int { return x + y; }
 
This omission is only going to be a factor for functions that you want to bind
to Perl.  If you don't need the function to bind to Perl, the syntax is fine;
L<Inline::CPP> just ignores the function.  It's important to note that the most
common uses of this syntax involve templates and lambdas.  Templates don't make
sense to L<Inline::CPP> anyway. And lambdas are still fine, because they take
place inside of functions, so L<Inline::CPP> doesn't see them anyway.  For now,
just don't use the late return type syntax in the header of functions that need
to bind to Perl.  This may get fixed in future revisions to the grammar.
 
Another issue is C<constexpr>:
 
    constexpr int multiply ( int x, int y ) { return x * y; }
 
C<constexpr> isn't recognized by Inline::CPP, so this function won't bind to
Perl.  I don't I<think> that C<constexpr> functions can even generate external
bindings, because they're resolved to a constant at compile-time.  They really
don't make sense for external use (the compiler can't know how you will call
them).  Consequently, they'll be ignored by Inline::CPP (and will pass through
to your compiler, so they I<will> work I<within> your C++ code).
 
And finally, I<Rvalue references>:
 
L<Inline::CPP> doesn't (yet) understand this:
 
    int x = 100;
 
    int getInt ()
    {
        return x;
    }
 
    int && getRvalueInt ()
    {
        return std::move( x );
    }
 
The C<getInt()> function will bind to Perl, but the C<&&> syntax isn't
recognized by Inline::CPP, and won't result in a binding being generated.  So
C<getRvalueInt()> will be invisible to Perl.  However, it is perfectly legal to
use within your C++ code as long as you don't need it to bind to Perl.
 
Aside from that (as far as I know), you're good to go!  Go ahead and use the
new version of C<for( auto it: x ) {...}>, or even...
 
    for_each( v.begin(), v.end(), [] (int val) { std::cout << val; } );
 
The beauty of Inline::CPP is that what goes on inside the black boxes of
functions or methods is irrelevant to the binding process.  These examples
will "just work", assuming your C++ compiler understands them.
 
=head1 BUGS AND DEFICIENCIES
 
There are bound to be bugs in code this uncivilized.  If you find one, please
file a bug report.  Patches are even better.  Patches accompanied by tests are
like the holy grail.
 
When reporting a bug, please do the following:
 
 - If possible, create a brief stand-alone snippet of code that
   demonstrates the issue.
 - Use  L<Github Issues|https://github.com/daoswald/Inline-CPP/issues> to file
   your bug report.
 - Patches are always welcome, as are tests that tickle a newfound bug.
 
 - Pull requests should avoid touching irrelevant sections of code/POD, and
   tests are required before they can be considered for merge.
 
...or...
 
 - Put "use Inline REPORTBUG;" at the top of your code, or
   use the command line option "perl -MInline=REPORTBUG ...".
 - Run your code.
 - Follow the printed instructions.
 
B<Get involved!>  Module development is being tracked on a github
repository: L<https://github.com/daoswald/Inline-CPP>.
 
The master branch should always be buildable and usable.
 
Official releases have version numbers in the following format: 'x.xx', and
are usually tagged with the CPAN release number.
 
Various development branches will hold a combination of minor commits and CPAN
"Developer" releases (these may have a version number formatted as:
'x.xx_xxx' to designate a developer-only CPAN release).
 
Most discussion relating to this module (user or developer) occurs on
the Inline mailing list, inline.perl.org, and in C<#inline> on C<irc.perl.org>.
See L<http://lists.perl.org/list/inline.html> for details on subscribing.
 
Here are some things to watch out for:
 
The grammar used for parsing C++ is still quite simple, and does not
allow several features of C++:
 
=over 4
 
=item Templates: You may use template libraries in your code, but
L<Inline::CPP> won't know how to parse and bind template definitions.  The
core problem is that the C++ compiler has no idea how a dynamic language like
Perl intends to invoke template-generated code, and thus, cannot know what
code to generate from the templates.  Keep the templates encapsulated away from
the interface that will be exposed to Perl by wrapping calls in functions that
will give the compiler a type to work with.
 
=item Operator overloading
 
=item Function overloading -- This is a similar issue to the template problem.
Perl doesn't know about C++'s function overload resolution rules.  And C++
doesn't know about Perl.  XS was never designed to deal with this sort of
mismatch.  This prevents implementing the I<Rule of Three> for code that is
intended to bind with Perl, but because Perl handles your bindings, that's
probably not an issue.
 
These three issues (Templates, Operator Overloading, and Function Overloading)
are situations where the C++ language and the Perl language simply do not map
well to one another.  The sooner you get used to this disconnect, the sooner
you'll get a feel for what is going to work and what isn't.  Templates are how
a static language like C++ deals with the concept of generic programming.  Perl
is such a dynamic language, that templates (which are resolved entirely at
compile time) cannot be resolved when called by Perl.  Perl's concept of
parameter passing is so dynamic that function signatures (which C++ uses in
resolving overloads) also can't be mapped meaningfully.  There will be other
features of C++ don't map into Perl, and vice versa.  Consider C++ enums.
Should Perl treat them as constants by mapping them via the constant pragma?
The answer is unclear, and the fact is they won't be bound into Perl at all.
 
=item Multiple inheritance doesn't work right (yet).
 
=item Multi-dimensional arrays as member data aren't implemented (yet).
 
=item Declaring a paramater type of void isn't implemented.  Just use
C<int myfunc();> instead of C<int myfunc(void);>.  This is C++, not C. It's ok,
really.
 
=item Exceptions: While it's ok to throw an exception using 'throw', Perl
won't know how to recover from it, and you'll get a core-dump instead of a
Perlish death.  The solution is simple, C<croak("Message")>.  Perl will treat
that as a call to C<die>.  The fifth example above demonstrates how to get
the best of both worlds: C++'s rich exception handling, and Perl's C<die>.
 
The gist of it is this: Catch your throws.  And anything that can't be dealt
with gracefully, re-throw back to Perl using C<croak>.
 
=back
 
Other grammar problems will probably be discovered.  This is Perl, C++, and
XS all sealed into one can of worms.  But it can be fun, which is a description
never applicable to raw XS.
 
=head1 SEE ALSO
 
For general information about how C<Inline> binds code to Perl, see
L<Inline>.
 
For information on using C with Perl, see L<Inline::C> and
L<Inline::C-Cookbook>. For I<WMTYEWTK>, see L<perlguts>, L<perlxs>,
L<perlxstut>, L<perlapi>, and L<perlcall>.  The literature for Inline::C
(including the cookbook) is relevant and useful in learning Inline::CPP too;
just about everything that works for Inline::C will work for Inline::CPP.
Rather than reiterate all those great examples here, it's better to just refer
the reader to Inline::C and Inline::C-Cookbook's documentation.
 
For converting an Inline::CPP module to pure XS (for simpler
distribution), see L<InlineX::CPP2XS>.  This method is usually preferable to
distributing with an Inline::CPP dependency, however, if you want to do
I<that>, read on...
 
L<Math::Prime::FastSieve> is a module based on Inline::CPP (using Inline::CPP
and Inline::MakeMaker as dependencies).  It serves as a proof of concept,
another example of Inline::CPP at work, and a working example of basing a CPAN
distribution on Inline::CPP.
 
B<< User and development discussion for Inline modules, including
Inline::CPP occurs on the inline.perl.org mailing list.  See
L<http://lists.perl.org/list/inline.html> to learn how to subscribe. >>
 
The maintainer has found I<Advanced Perl Programming, 2nd Edition> (O'Reilly)
helpful, although its discussion is focused on Inline::C.
 
 
=head1 AUTHOR
 
Neil Watkiss <NEILW@cpan.org> was the original author.
 
David Oswald <DAVIDO@cpan.org> is the current maintainer.
David Oswald's Inline::CPP GitHub repo is:
L<https://github.com/daoswald/Inline-CPP>
 
Ingy döt Net <INGY@cpan.org> is the author of C<Inline>, and C<Inline::C>.
 
=head1 CONTRIBUTING
 
Issues are tracked, and may be reported at the distribution's
L<GitHub issue tracker|https://github.com/daoswald/Inline-CPP/issues>.
 
Contributors may also fork the repo and issue a pull requests.  Tests
should accompany pull requests, and effort should be made to minimize the
scope of any single pull request.
 
Pull requests should not add author names. Non-trivial contributions
generally warrant attribution in the log maintained in the C<Changes>
file, though the decision to do at the discretion of the maintainers.
 
Please refer to the Artistic 2.0 license, contained in the C<LICENSE> file,
included with this distribution for further explanation.
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2000 - 2003 Neil Watkiss.
Copyright (c) 2011 - 2014 David Oswald.
 
All Rights Reserved. This module is free software, licensed under
the Artistic license, version 2.0.
 
See http://www.perlfoundation.org/artistic_license_2_0
 
=cut