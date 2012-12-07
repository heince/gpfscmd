package Gcmd::General;

use v5.16;
use Mouse;

has 'mmclusterfile' => (is => 'ro', default => '/opt/scripts/gpfs/tmp/mmlsclusterfile');

sub get_all_nodes{
        my $self = shift;

        my @nodes;
        my $nodesfile = '/var/mmfs/gen/mmfsClusterNodes';
        if( -f $nodesfile){
                open(my $fh, "<", $nodesfile) or die "$!\n";
                @nodes = <$fh>;
                close $fh;
        }else{
                die "ERROR: $nodesfile not found - $!\n";
        }
        return \@nodes;
}

sub get_hostname{
        my ($self, $ip) = @_;

        my $hostname;

        open (my $fh, "<", $self->mmclusterfile) or die "$!\n";
        while(<$fh>){
                if(/\b$ip\b/){
                        my @tmp = split '\s+' => $_;
                        $hostname = $tmp[2];
                        last;
                }
        }
        return $hostname;
}

1;