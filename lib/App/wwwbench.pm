package App::wwwbench;
use strict;
use warnings;
our $VERSION = '0.01';

use Coro;
use Coro::Select;
use Furl::HTTP;
use Time::HiRes;
use List::Util qw/min max sum/;

sub run {
    my($class, %args) = @_;
    
    my $try_max     = $args{try_max};
    my $connect_max = $args{connect_max};
    my $url         = $args{url};

    my @times;
    foreach my $i (0 .. $try_max-1) {
        my @connection;
        $times[$i] = [];

        my $ua = Furl::HTTP->new; 
        push(@connection, async{
            my $start = Time::HiRes::time;
            my(undef, $code) = $ua->get($url);
            my $end = Time::HiRes::time;
            push(@{$times[$i]}, [$end, $start, $code]);
        }) foreach(1 .. $connect_max);

        $_->join foreach(@connection);
    }

    return \@times;
}

sub all_result_format {
    my($class, $times) = @_;

    my $text = '';
    foreach my $i (0 .. $#{$times}){
        $text .= sprintf("[%d]\n", $i);
        $text .= $class->result_format($times->[$i]);
    }

    return $text;
}

sub result_format {
    my($class, $times) = @_;

    my $data          = $class->data_format($times);
    my @total         = @{$data->{total}};
    my @total_times   = @{$data->{total_times}};
    my @success       = @{$data->{success}};
    my @success_times = @{$data->{success_times}};

    my $text = '';
    $text .= sprintf("- connect total: %d[connection]\n", scalar(@total));
    $text .= sprintf("- success total: %d[connection]\n", scalar(@success));
    $text .= sprintf("- success rate: %.3f[%%]\n", scalar(@success) * 100 / scalar(@total));
    $text .= sprintf("--- total max    : %.3f[s]\n", max(@total_times));
    $text .= sprintf("--- total average: %.3f[s]\n", sum(@total_times) / scalar(@total));
    $text .= sprintf("--- total min    : %.3f[s]\n", min(@total_times));
    $text .= sprintf("--- success max    : %.3f[s]\n", max(@success_times));
    $text .= sprintf("--- success average: %.3f[s]\n", sum(@success_times) / scalar(@success));
    $text .= sprintf("--- success min    : %.3f[s]\n", min(@success_times));

    return $text;
}

sub data_format {
    my($class, $times) = @_;
    
    my @total         = @$times;
    my @total_times   = map { $_->[0] - $_->[1] } @total;
    my @success       = grep { $_->[2] == 200 }   @total;
    my @success_times = map { $_->[0] - $_->[1] } @success;

    return +{
        total         => \@total,
        total_times   => \@total_times,
        success       => \@success,
        success_times => \@success_times,
    };
}

1;
__END__

=head1 NAME

App::wwwbench -

=head1 SYNOPSIS

  use App::wwwbench;

=head1 DESCRIPTION

App::wwwbench is

=head1 AUTHOR

Kenta Sato E<lt>karupa@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
