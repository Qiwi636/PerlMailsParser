package module::Common;

use strict;
use warnings;
use DBI;
use JSON;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(getConfHash DBconnect getLogData);

sub getConfHash {
    my $config_file = shift;

    my $path = "D:\\DockerShit\\PerlTestQ\\conf\\" . $config_file;
    open my $fh, '<', $path or die "Не удалось открыть $config_file $!";
    my $json_text = do { local $/; <$fh> };
    close $fh;
    my $config = decode_json($json_text);

    return $config;
}

sub DBconnect {
    my $config = shift;

    my $dbh = DBI->connect(
        "dbi:mysql:$config->{'db_name'};host=$config->{'db_host'}",
        $config->{'db_user'},
        $config->{'db_pass'},
        { PrintError => 0, RaiseError => 1 }
    ) or die "Не удалось подключиться к базе данных: $DBI::errstr";

    return $dbh;
}

sub getLogData {
    my $log_name = shift;

    my $path = "D:\\DockerShit\\PerlTestQ\\log\\" . $log_name;

    open my $log_file, '<', $path or die "$log_name не сущетствует: $!";
    my $all_log_data = do { local $/; <$log_file> };
    close $log_file;

    return $all_log_data;
}