use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'HTML::PrettyPrinter',
    'VERSION_FROM'	=> 'PrettyPrinter.pm', # finds $VERSION
    'PREREQ_PM'		=> { HTML::TreeBuilder => 1.0 }, # e.g., Module::Name => 1.1
);
