package HTML::PrettyPrinter;

require 5.005_62;
use strict;
use warnings;

use HTML::TreeBuilder;


our $VERSION = '0.01';


# Preloaded methods go here.
sub HTML::Element::dump_html
{
    my($self, $fh, $depth) = @_;
    $fh = *STDOUT{IO} unless defined $fh;
    $depth = 0 unless defined $depth;
    print $fh
      "  " x $depth,   $self->starttag, "\n";
    for (@{$self->{'_content'}}) {
        if (ref $_) {  # element
            $_->dump_html($fh, $depth+1);  # recurse
        } else {  # text node
            print $fh "  " x ($depth + 1);
            if(length($_) > 65 or m<[\x00-\x1F]>) {
              # it needs prettyin' up somehow or other
              my $x = (length($_) <= 65) ? $_ : (substr($_,0,65) . '...');
              $x =~ s<([\x00-\x1F])>
                     <'\\x'.(unpack("H2",$1))>eg;
              print $fh qq{"$x"\n};
            } else {
              print $fh qq{"$_"\n};
            }
        }
    }
}

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

HTML::PrettyPrinter - HTML::TreeBuilder extension for pretty-printing HTML

=head1 SYNOPSIS

  use HTML::PrettyPrinter;

  my $file = 'dump.html';
  my $tree = HTML::TreeBuilder->new_from_file($file);
  $tree->dump_html; # works via inheritance

=head1 DESCRIPTION

This will pretty print your HTML files. No config options at the moments.
Patches welcome.

=head2 EXPORT

None.


=head1 AUTHOR

T. M. Brannon, <tbone@cpan.org>

=head1 Acknowledgements

This is nothing but a ripoff of HTML::Element::dump() which gets rid of the
<$self->address> printing. And while we are discussing C<dump>,
take a look at this HTML document, which HTML::TreeBuilder's dump()
method has annotated each node of the HTML document with a unique
identitifer:   


 <html> @0
  <head> @0.0 (IMPLICIT)
  <body> @0.1 (IMPLICIT)
    <table supply="_aref::load_data"> @0.1.0
      <tr iterator="supply.Next"> @0.1.0.0
        <th> @0.1.0.0.0
          "name"
        <th> @0.1.0.0.1
          "age"
        <th> @0.1.0.0.2
          "weight"
        <td builder="_text::iterator.name"> @0.1.0.0.3
        <td builder="_text::iterator.age"> @0.1.0.0.4
        <td builder="_text::iterator.weight"> @0.1.0.0.5


It would be possible to tie each identifier to an anonymous subroutine: 

 my %dynamic_html = (
 '@0.1.0.0.5' => sub { my $node = shift; $node->splice_content(0,1,'new text'}}

for pure Perl and pure HTML templating (ie, absolutely no foreign
elements in the HTML.  

However, the problem would be that the mapping would have to change each time that the HTML changed the tree-numbering.



=head1 SEE ALSO

HTML::TreeBuilder, HTML::Seamstress.

=cut
