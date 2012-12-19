package Gcmd::Waiters;
use v5.16;
use Mouse;
use Gcmd::General;

extends 'Gcmd::General';

sub get_waiters{
        my $self = shift;

        my $output = $self->waiters_cmd();
        if($output){
                print $output;
                print "\n\nTop waiting list :\n" . $self->get_top_wl($output) . "\n\n";
        }
        
}

#get top waiting list
sub get_top_wl{
        my ($self, $output) = @_;

        my (@rows, @temp);
        my $result;
        my @lines = split '\n' => $output;
        for(@lines){
                if($result){
                        @rows = split '\s+' => $_;
                        @temp = split '\s+' => $result;
                        if($rows[2] >= $temp[2]){
                                $result = $_;
                        }
                }else{
                        $result = $lines[0];
                }
        }
        return $result;
}

sub waiters_cmd{
        my $self = shift;

        my $cmd = `mmfsadm dump waiters`;
        unless($cmd){
                die "ERROR: \n\n$cmd\n";
        }
        return $cmd;
}

1;