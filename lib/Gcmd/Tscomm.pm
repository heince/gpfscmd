package Gcmd::Tscomm;
use v5.16;
use Mouse;
use List::MoreUtils qw(uniq);
use Gcmd::General;

extends 'Gcmd::General';

sub get_status{
        my $self = shift;

        my $pending_node = $self->get_pending();
        if($pending_node){
                print "Pending node list :\n";
                for(@$pending_node){
                        print "$_\n";
                }
        }
}

sub get_pending{
        my $self = shift;

        my $cmd = `mmfsadm dump tscomm | grep 'status pending'`;
        my @con = split '\n' => $cmd;
        my @connection;
        for(@con){
                #get connection name , e.g 'c0n1'
                if(/\<(c0n\d+)\>/){
                        push @connection, $1;           
                }
        }
        @connection = uniq @connection if @connection;

        my @result;
        for(@connection){
                $cmd = `mmfsadm dump tscomm | grep '\\b$_\\b' | grep ib0`;
                push @result, $cmd;
        }
        
        return \@result if @result;
}

1;
