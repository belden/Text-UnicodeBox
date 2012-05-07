use strict;
use warnings;
use utf8;
use Test::More;

BEGIN {
	use_ok 'Text::UnicodeBox';
	use_ok 'Text::UnicodeBox::Control', qw(:all);
};

$Text::UnicodeBox::Utility::report_on_failure = 1;

my $box = Text::UnicodeBox->new(
	whitespace_character => '.',
);
isa_ok $box, 'Text::UnicodeBox';

my @multiline = (
	'While I pondered weak and weary',
	'over many a quaint and curious ',
	'volume of forgotten lore       '
);

$box->add_line('.', BOX_START( style => 'light', top => 'double' ), " $multiline[0] ", BOX_END(), '.');
$box->add_line('.', BOX_START( style => 'light' ), " $multiline[1] ", BOX_END(), '.');
$box->add_line('.', BOX_START( style => 'light', bottom => 'double' ), " $multiline[2] ", BOX_END(), '.');

is $box->render, <<END_BOX, "Double top/bottom multiline box";
.\x{2552}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2555}.
.\x{2502} While I pondered weak and weary \x{2502}.
.\x{2502} over many a quaint and curious  \x{2502}.
.\x{2502} volume of forgotten lore        \x{2502}.
.\x{2558}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{255b}.
END_BOX

# Multi-column and row

$box = Text::UnicodeBox->new(
	whitespace_character => '.',
);

$box->add_line(
	BOX_START( style => 'heavy', top => 'heavy', bottom => 'heavy' ),
	' id ', BOX_RULE, ' ts                  ', BOX_RULE, ' log                 ',
	BOX_END()
);

is $box->render, <<END_BOX, "Multi-column box";
\x{250f}\x{2501}\x{2501}\x{2501}\x{2501}\x{2533}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2533}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2513}
\x{2503} id \x{2503} ts                  \x{2503} log                 \x{2503}
\x{2517}\x{2501}\x{2501}\x{2501}\x{2501}\x{253b}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{253b}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{251b}
END_BOX

# Multi-column and multi-row

$box = Text::UnicodeBox->new(
	whitespace_character => '.',
);

$box->add_line(
	BOX_START( style => 'heavy', top => 'heavy', bottom => 'heavy' ),
	' id ', BOX_RULE, ' ts                  ', BOX_RULE, ' log                 ',
	BOX_END()
);

$box->add_line(
	BOX_START( style => 'light', bottom => 'light' ),
	' 2  ', BOX_RULE, ' 2012-04-16 16:30:43 ', BOX_RULE, ' Eric was here       ',
	BOX_END()
);

is $box->render, <<END_BOX, "Multi-column, multi-row box with separation";
\x{250f}\x{2501}\x{2501}\x{2501}\x{2501}\x{2533}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2533}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2513}
\x{2503} id \x{2503} ts                  \x{2503} log                 \x{2503}
\x{2521}\x{2501}\x{2501}\x{2501}\x{2501}\x{2547}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2547}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2529}
\x{2502} 2  \x{2502} 2012-04-16 16:30:43 \x{2502} Eric was here       \x{2502}
\x{2514}\x{2500}\x{2500}\x{2500}\x{2500}\x{2534}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2534}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2500}\x{2518}
END_BOX

# Fanciness

$box = Text::UnicodeBox->new(
	whitespace_character => '.',
);

$box->add_line(
	BOX_START( style => 'double', top => 'double', bottom => 'double' ),
	'  id  ', BOX_RULE, ' ts                  ', BOX_RULE, ' log                  ', BOX_END()
);
$box->add_line(
	' ', BOX_START(),
	' 2  ', BOX_RULE, ' 2012-04-16 16:30:43   ', BOX_RULE, ' Eric was here      ', BOX_END()
);
$box->add_line(
	' ', BOX_START(),
	' 3  ', BOX_RULE, ' 2012-04-16 16:31:43   ', BOX_RULE, ' Eric was here 2    ', BOX_END()
);
$box->add_line(
	BOX_START( style => 'heavy', top => 'heavy', bottom => 'heavy' ),
	' id ', BOX_RULE, ' ts                  ', BOX_RULE, ' log                    ', BOX_END()
);

is "\n" . $box->render, <<END_BOX, "Complex layout with many styles";

\x{2554}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2566}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2566}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2557}
\x{2551}  id  \x{2551} ts                  \x{2551} log                  \x{2551}
\x{255a}\x{2564}\x{2550}\x{2550}\x{2550}\x{2550}\x{2564}\x{2569}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2569}\x{2564}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2550}\x{2564}\x{255d}
 \x{2502} 2  \x{2502} 2012-04-16 16:30:43   \x{2502} Eric was here      \x{2502}
 \x{2502} 3  \x{2502} 2012-04-16 16:31:43   \x{2502} Eric was here 2    \x{2502}
\x{250f}\x{2537}\x{2501}\x{2501}\x{2501}\x{2533}\x{2537}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2533}\x{2501}\x{2501}\x{2537}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2537}\x{2513}
\x{2503} id \x{2503} ts                  \x{2503} log                    \x{2503}
\x{2517}\x{2501}\x{2501}\x{2501}\x{2501}\x{253b}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{253b}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{2501}\x{251b}
END_BOX

done_testing;
