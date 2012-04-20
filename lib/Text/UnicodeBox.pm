package Text::UnicodeBox;

use Moose;

use Text::UnicodeBox::Control qw(:all);
use Text::UnicodeBox::Text qw(:all);
use Text::UnicodeBox::Utility qw(fetch_box_character);
use Scalar::Util qw(blessed);

has 'buffer_ref' => ( is => 'rw', default => sub { my $buffer = '';  return \$buffer } );
has 'last_line'  => ( is => 'rw' );
has 'whitespace_character' => ( is => 'ro', default => ' ' );

sub buffer {
	my $self = shift;
	return ${ $self->buffer_ref };
}

sub add_line {
	my $self = shift;
	my @parts;

	# Read off each arg, validate, then push onto @parts as objects
	foreach my $part (@_) {
		if (ref $part && blessed $part && ($part->isa('Text::UnicodeBox::Control') || $part->isa('Text::UnicodeBox::Text'))) {
			push @parts, $part;
		}
		elsif (ref $part) {
			die "add_line() takes only strings or Text::UnicodeBox:: objects as arguments";
		}
		else {
			push @parts, STRING($part);
		}
	}

	my %current_line = (
		parts => \@parts,
		parts_at_position => {},
	);

	# Generate this line as text
	my $line = '';
	{
		my $position = 0;
		my %context;
		foreach my $part (@parts) {
			$current_line{parts_at_position}{$position} = $part;
			$line .= $part->to_string(\%context);
			$position += $part->can('length') ? $part->length : 1;
		}
		$line .= "\n";
		$current_line{final_position} = $position;
	}

	## Generate the top of the box if needed

	my $box_border_line;
	if (grep { $_->can('top') && $_->top } @parts) {
		$box_border_line = $self->_generate_box_border_line(\%current_line);
	}
	elsif (grep { $_->can('bottom') && $_->bottom } @{ $self->last_line->{parts} }) {
		$box_border_line = $self->_generate_box_border_line(\%current_line);
	}

	# Store this for later reference
	$self->last_line(\%current_line);

	# Add lines to the buffer ref
	my $buffer_ref = $self->buffer_ref;
	$$buffer_ref .= $box_border_line if defined $box_border_line;
	$$buffer_ref .= $line;
}

sub render {
	my $self = shift;

	my @box_bottoms = grep { $_->can('bottom') && $_->bottom } @{ $self->last_line->{parts} };
	if (@box_bottoms) {
		my $box_border_line = $self->_generate_box_border_line();
		my $buffer_ref = $self->buffer_ref;
		$$buffer_ref .= $box_border_line;
	}

	return $self->buffer();
}

sub _find_part_at_position {
	my ($position_hash, $position) = @_;
	while ($position >= 0) {
		if ($position_hash->{$position}) {
			return $position_hash->{$position};
		}
		$position--;
	}
	return;
}

sub _generate_box_border_line {
	my ($self, $current_line) = @_;

	my ($below_box_style, $above_box_style);
		
	my %last_parts_at_position = $self->last_line ? %{ $self->last_line->{parts_at_position} } : ();
	my %current_parts_at_position = $current_line ? %{ $current_line->{parts_at_position} } : ();

	my $final_position = $current_line ? $current_line->{final_position} : $self->last_line->{final_position};

	my $line = '';

	foreach my $position (0..$final_position - 1) {
		my $above_part = _find_part_at_position(\%last_parts_at_position, $position);
		my $below_part = _find_part_at_position(\%current_parts_at_position, $position);

		my %symbol;
		# First, let the above part specify styling
		if ($above_part && $above_part->isa('Text::UnicodeBox::Control')) {
			$symbol{up} = $above_part->style || 'light';
			if ($above_part->position eq 'start' && $above_part->bottom) {
				$above_box_style = $above_part->bottom;
				$symbol{right} = $above_box_style;
			}
			elsif ($above_part->position eq 'end') {
				$symbol{left} = $above_box_style;
				$above_box_style = undef;
			}
			elsif ($above_part->position eq 'middle') {
				$symbol{left} = $symbol{right} = $above_box_style;
			}
		}

		# Next, let the below part override
		if ($below_part && $below_part->isa('Text::UnicodeBox::Control')) {
			$symbol{down} = $below_part->style || 'light';
			if ($below_part->position eq 'start' && $below_part->top) {
				$below_box_style = $below_part->top;
				$symbol{right} = $below_box_style if $below_box_style;
			}
			elsif ($below_part->position eq 'end') {
				$symbol{left} = $below_box_style if $below_box_style;
				$below_box_style = undef;
			}
			elsif ($below_part->position eq 'middle') {
				$symbol{left} = $symbol{right} = $below_box_style if $below_box_style;
			}
		}

		if (! keys %symbol) {
			$symbol{horizontal} = $below_box_style ? $below_box_style : $above_box_style ? $above_box_style : undef;
			delete $symbol{horizontal} unless defined $symbol{horizontal};
		}

		if (! keys %symbol) {
			$line .= $self->whitespace_character();
		}
		else {
			$line .= fetch_box_character(%symbol) || '';
		}
	}

	$line .= "\n";

	return $line;
}

1;
