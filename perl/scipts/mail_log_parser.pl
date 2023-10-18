use warnings FATAL => 'all';
use Data::Dumper;
use strict;

use lib 'perl/module';
use DB::API;
use Common;

my $conf_name = 'mysql.json';
my $log_name  = 'out.log';

my $mysql_conf = getConfHash($conf_name);

sub prepareInsertMessage {
    my $dbh = shift;
    my $sql =
      qq{INSERT INTO message (created, id, int_id, str) VALUES (?, ?, ?, ?)};

    return prepare_sql( $dbh, $sql );
}

sub prepareInsertLog {
    my $dbh = shift;
    my $sql =
      qq{INSERT INTO log (created, int_id, str, address) VALUES (?, ?, ?, ?)};

    return prepare_sql( $dbh, $sql );
}

sub processingLog {
    my $path = "D:\\DockerShit\\PerlTestQ\\log\\" . $log_name;
    open my $log_file, '<', $path or die "$log_name не сущетствует: $!";

    my $dbh            = DBconnect($mysql_conf);
    my $insert_message = prepareInsertMessage($dbh);
    my $insert_log     = prepareInsertLog($dbh);

    while ( my $line = <$log_file> ) {
        chomp $line;
        my @fields = split /\s+/, $line;
        $fields[3] eq '<='
          ? $insert_message->execute( getIncomingMsg(@fields) )
          : $insert_log->execute( getMsg(@fields) );
    }

    $dbh->disconnect();
    close $log_file;
}

sub getMsg {
    my @fields = shift;

    my $created = "$fields[0] $fields[1]";
    my $int_id  = $fields[2];
    my $str     = join( ' ', @fields[ 2 .. $#fields ] );
    my $address = $fields[3] eq '=>' || $fields[3] eq '->' ? $fields[4] : '';

    return ( $created, $int_id, $str, $address );
}
sub getIncomingMsg {
    my @fields = shift;

    my $created = "$fields[0] $fields[1]";
    my $id      = ( $fields[2] =~ /id=(\w+)/ ) ? $1 : '';
    my $int_id  = $fields[2];
    my $str     = join( ' ', @fields[ 3 .. $#fields ] );

    return ( $created, $id, $int_id, $str );
}
