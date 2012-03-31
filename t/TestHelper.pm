package Model;

sub new   {  my $class = shift; bless { @_ }, $class }
sub name  { shift->{name} }
sub admin { shift->{admin} }

package TestHelper;

use Mojo::Base '-strict';
use Test::More;

require Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw(render_input user dom is_field_count is_field_attrs);

sub dom { shift->tx->res->dom }	# For Test::Mojo
sub qs  { join '&', @_ }

sub is_field_count
{ 
    my ($t, $field, $expect) = @_;
    # can't say ->input->size unless input() exists
    is(dom($t)->find($field)->size, $expect, "$field count");
}

sub is_field_attrs
{
    my ($t, $field, $expect) = @_;
    my $e = dom($t)->at($field);
    my $attrs = $e ? $e->attrs : {};
    is_deeply($attrs, $expect, "$field attributes");
}

sub user 
{ 
    my %attribs = @_;
    my %defaults = (admin => 1, name => 'sshaw');
    %attribs = (%defaults, %attribs);

    Model->new(%attribs);	
}

sub render_input
{
    my $c = shift;
    my $input = shift;

    my %options = @_;
    my $user = $c->param('user');
    $options{stash} ||= { user => user(%$user) };

    $c->stash(%{$options{stash}});
    # $c->stash(input => $input);
    # #$c->render('render_input');
    # #$c->render('render_input', package => __PACKAGE__);
    # $c->render_partial(
    # 	template => 'render_input',
    # 	format   => 'html',
    #     handler  => 'ep',
    #     template_class => __PACKAGE__
    # );
    $c->render(text => $c->field('user.name')->$input(@{$options{input}}));
}

1;

__DATA__

@@ render_input.html.ep
%= field('user.name')->$input


