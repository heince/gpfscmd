package Gcmd::State;
use v5.16;
use Mouse;
use Gcmd::General;
use Net::Ping;

extends 'Gcmd::General';

#check ping & mmgetstate if available
sub check_ping{
        my ($self, $ip) = @_;

        my ($cmd, $status);
        chomp $ip;
        $cmd = Net::Ping->new();
        
        $status = $cmd->ping($ip);
        
        $cmd->close();
        return $status;
}

sub check_all{
        my $self = shift;

        my $nodes = $self->get_all_nodes();

        my ($status, $hostname);
        my (@unreachable, @notactive);
        for my $ip(@$nodes){
                $hostname = $self->get_hostname($ip);

                #
                #unpingable node
                #
        
                $status = $self->check_ping($ip);
                unless($status){
                        push @unreachable, $hostname;
                }

                #
                #GPFS state not active
                #

                my $gpfs = $self->check_mmgetstate($ip);
                if($gpfs =~ /active/){
                        print "Ok\n";
                }else{
                        print $gpfs;
                        push @notactive, $hostname;
                }
        }

        print "\nSummary\n";
        print "=" x 10 . "\n\n";
        print "Unreachable nodes :\n";

        if(@unreachable){
                for(@unreachable){
                        print "$_\n";
                }
                print "\n";
        }else{
                print "All nodes reachable\n\n";
        }

        print "Unactive GPFS state :\n";
        if(@notactive){
                for(@notactive){
                        print "$_\n";
                }
                print "\n";
        }else{
                print "All GPFS state active\n\n";
        }
}

sub check_mmgetstate{
        my ($self, $ip) = @_;

        chomp $ip;
        my $hostname = $self->get_hostname($ip);
        print "\nRunning mmgetstate on $hostname\n";
        my $cmd = `mmgetstate -N $hostname`;
        return $cmd;
}

1;

1;