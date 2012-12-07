package Gcmd::State;
use v5.16;
use Mouse;
use Gcmd::General;
use Net::Ping;

extends 'Gcmd::General';

sub check_ping{
        my ($self, $ip) = @_;

        my ($cmd, $status, $hostname);
        print "Check ping ...\n";
        #print "pinging $ip";
        chomp $ip;
        $cmd = Net::Ping->new();

        unless($cmd->ping($ip)){
                $hostname = $self->get_hostname($ip);
                print "$hostname not reachable\n";;
                return 0;
        }
        $cmd->close();
}

sub check_all{
        my $self = shift;

        my $status;
        my $nodes = $self->get_all_nodes();
        for(@$nodes){
                my $stat = $self->check_ping($_);
                $status = 1 unless $stat;
        }

        #check if any error than print summary
        if($status == 1){
                print "one / more nodes unreachable\n";
        }else{
                print "all nodes is reachable\n";
        }
}

1;