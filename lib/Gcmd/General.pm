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
        
        chomp $ip;
        open (my $fh, "<", $self->mmclusterfile) or die "$!\n";
        while(<$fh>){
                if(/\b$ip\b/){
                        my $string = $self->ltrim($_);
                        my @tmp = split '\s+' => $string;
                        $hostname = $tmp[1];
                        last;
                }
        }
        chomp $hostname;
        return $hostname;
}

# trim function to remove whitespace from the start and end of the string
sub trim()
{
        my ($self, $string) = @_;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}

# Left trim function to remove leading whitespace
sub ltrim()
{
        my ($self, $string) = @_;
        $string =~ s/^\s+//;
        return $string;
}

# Right trim function to remove trailing whitespace
sub rtrim()
{
        my ($self, $string) = @_;
        $string =~ s/\s+$//;
        return $string;
}

1;