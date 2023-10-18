#!/usr/bin/perl

use strict;
use warnings;
use FCGI;
use DBI;

use lib 'perl/module';
use DB::API;
use Common;

my $mysql_conf = getConfHash('mysql.conf');
unless (defined $mysql_conf) {
    print "Statistic.pm: Can't read config file : technadzor.conf \n";
    exit;
}

my $request = FCGI::Request();

while ($request->Accept() >= 0) {
    my $html;
    my ($head_html, $end_html) = get_default();

    if ($request->Param('address')) {
        my $address = $request->Param('address');
        my $log_entries = get_log_entries($address);
        $html = get_filled_html($address, $log_entries);
    } else {
        $html = get_empty_html();
    }

    return $head_html . $html . $end_html;
}

sub get_default {
    my ($head, $end) = ('', '');
    $head .= "Content-Type: text/html\r\n\r\n";
    $head .= "<html><head><title>Логи почты</title></head><body>";

    $end .= "</body></html>";

    return ($head, $end);
}

sub get_filled_html {
    my ($address, $log_entries) = @_;
    my $html = "<h1>Логи почты для '$address'</h1>";
    $html .= get_field();
    $html .= "<ul>";
    foreach my $entry (@$log_entries) {
        $html .= "<li>$entry</li>";
    }
    $html .= "</ul>";
}

sub get_empty_html {
    my $html = "<h1>Mail Logs</h1>";
    $html .= get_field();
}

sub get_field {
    my $html = "<form method='POST' action='mail_logs.fcgi'>";
    $html .= "Введите email: <input type='text' name='address'>";
    $html .= "<input type='submit' value='Submit'>";
    $html .= "</form>";
    
    return $html;
}

sub get_log_entries {
    my $address = shift;

    my $dbh = DBconnect($mysql_conf);
    my $entries = get_topN($dbh, $address);

    return $entries;
}

sub get_topN {
    my ($dbh, $address, $value) = @_;

    $value = 100 unless $value;
    
    my $sql = qq{
        SELECT created, str
        FROM (
        (SELECT created, str
        FROM message
        WHERE int_id IN (
            SELECT int_id 
            FROM log 
            WHERE address = ?)
        ORDER BY created DESC
        LIMIT $value)
        UNION
        (SELECT created, str
        FROM log
        WHERE address = ?
        ORDER BY created DESC
        LIMIT $value)
        ) AS subquery
        ORDER BY created DESC
        LIMIT $value;
    };

    my $entries = $dbh->selectall_arrayref($sql, { Slice => {} }, $address, $address);
    $dbh->disconnect();

    return $entries;
}