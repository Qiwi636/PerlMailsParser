package module::DB::API;

use warnings FATAL => 'all';
use Data::Dumper;
use strict;

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw( prepare_sql );


sub prepare_sql {
    my ($dbh, $sql) = @_;

    return $dbh->prepare($sql);
}