#!/usr/bin/perl -w

# Plugin to monitor ntp queries
# (c)2009 Chris Hastie: chris (at) oak (hyphen) wood (dot) co (dot) uk
#
# Parameters understood:
#
#   config   (required)
#   autoconf (optional - used by munin-node-configure)
#
# Config variables:
#
#       ntpdc           - path to ntpdc program
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Change log
# v1.0.0    2009-03-11        Chris Hastie
# initial release
#
#
#
# Magic markers - optional - used by installation scripts and
# munin-node-configure:
#
#%# family=contrib
#%# capabilities=autoconf
#

use strict;
use Socket;

my $NTPDC = $ENV{ntpdc} || "/usr/bin/ntpdc";
my $COMMAND    =      "$NTPDC -c sysstats";


# autoconf
if ($ARGV[0] and $ARGV[0] eq "autoconf") {
    `$NTPDC -c help >/dev/null 2>/dev/null`;
    if ($? eq "0") {
        if (`$NTPDC -c sysstats | wc -l` > 0) {
            print "yes\n";
            exit 0;
        } else {
            print "no (unable to list system stats)\n";
            exit 1;
        }
    } else {
        print "no (ntpdc not found)\n";
        exit 1;
    }
}

my $queries = 0;
my $packrcv;
my $packproc;


# get data from tc
open(SERVICE, "$COMMAND |")
  or die("Could not execute '$COMMAND': $!");

while (<SERVICE>) {
    if (/^packets received:\s*(\d*)/) {
      $packrcv = $1;
    }
}
close(SERVICE);

# config
if ($ARGV[0] and $ARGV[0] eq 'config') {
  print "graph_title All NTP Packets\n";
  print "graph_args --base 1000\n";
  print "graph_vlabel pps\n";
  print "graph_category NTP\n";
  print "graph_info Packets sent to the NTP server\n";
  print "packets.label Packets per second\n";
  print "packets.type DERIVE\n";
  print "packets.min 0\n";

  exit 0;
}

# send output

print "packets.value $packrcv\n";

##################################


=pod

=head1 Description

ntp_packets - A munin plugin to monitor queries handled by NTP

=head1 Parameters understood:

  config   (required)
  autoconf (optional - used by munin-node-configure)

=head1 Configuration variables:

All configuration parameters are optional

  ntpdc            - path to ntpdc program


=head1 Known issues


=cut