package Gcmd::Command::Check;

use Gcmd -command;
use v5.16;

#return usage output
sub usage_text{
    my $usage = <<EOF;
Usage:
gcmd check [--cmd-opt] [cmd-arg]

available cmd-opt:
-a                                              => 'all'
-n      [comma separated node]                  => 'define node'
-x      [comma separated exclude node]          => 'exclude node'
            
available cmd-arg:
state | waiters | tscomm

example:
gcmd check -a state
gcmd check waiters
gcmd check tscomm

EOF
}

sub validate_args{
    my ($self, $opt, $args) = @_;
    
    if(defined $opt->{'h'}){
        die $self->usage_text();
    }

    if(@$args[0]){
        given(@$args[0]){
            when (@$args[0] =~  /\bstate\b/i){
                break;
            }
            when (@$args[0] =~  /\bwaiters\b/i){
                break;
            }
            when (@$args[0] =~  /\btscomm\b/i){
                break;
            }
            default{
                die "@$args[0] argument not supported\n";
            }
        }
    }else{
        die $self->usage_text();
    }
}

sub opt_spec {
    # The option_spec() hook in the Command Class provides the option
    # specification for a particular command.
    [ 'h|help'  ,  'print help' ], 
    [ 'a'       , 'all' ],
    [ 'n'       , 'set node' ],
    [ 'x'       , 'exclude node' ],
}

sub execute{
	my ($self, $opt, $args) = @_;
   
   	my $obj;
   
   given(@$args[0]){
        when (@$args[0] =~ /\bstate\b/i){
                use Gcmd::State;

                $obj = Gcmd::State->new();
                $obj->check_all() if $opt->{a}; 
        }
        when (@$args[0] =~ /\bwaiters\b/i){
                use Gcmd::Waiters;

                $obj = Gcmd::Waiters->new();
                $obj->get_waiters();    
        }
        when (@$args[0] =~ /\btscomm\b/i){
                use Gcmd::Tscomm;

                $obj = Gcmd::Tscomm->new();
                $obj->get_status();     
        }
   }
   
   return;
}

=pod

=head 1 Check

Gcmd::Command::Check - GPFS check Command Options

=cut