:local LowCase do={
  :if ([:len $1]=0) do={:return "";}
  :local C ("\41","\42","\43","\44","\45","\46","\47","\48","\49","\4A","\4B","\4C","\4D","\4E","\4F","\50","\51","\52","\53","\54","\55","\56","\57","\58","\59","\5A","\61","\62","\63","\64","\65","\66","\67","\68","\69","\6A","\6B","\6C","\6D","\6E","\6F","\70","\71","\72","\73","\74","\75","\76","\77","\78","\79","\7A");
  :local L ("\61","\62","\63","\64","\65","\66","\67","\68","\69","\6A","\6B","\6C","\6D","\6E","\6F","\70","\71","\72","\73","\74","\75","\76","\77","\78","\79","\7A","\61","\62","\63","\64","\65","\66","\67","\68","\69","\6A","\6B","\6C","\6D","\6E","\6F","\70","\71","\72","\73","\74","\75","\76","\77","\78","\79","\7A");
  :local o "";
  :for i from=0 to=([:len $1]-1) do={:if ([:len [:find $C [:pick $1 $i]]]!=0) do={:set $o ($o.[:pick $L [:find $C [:pick $1 $i]]]);} else={:set $o ($o.[:pick $1 $i]);}}
  :return $o;
}

:local CharReplace do={
  :if ([:len $1]=0) do={:return "";}
  :if ([:len $2]=0) do={:return $1;}
    :local c "";
    :for i from=0 to=([:len $1]-1) do={
      :if ([:len [:find $2 [:pick $1 $i]]]!=0) do={
      :set $c ($c.[:pick $3 [:find $2 [:pick $1 $i]]]);
      } else={
      :set $c ($c.[:pick $1 $i]);
      }
    }
  :return ($c);
}

:local DHCPtag
:set DHCPtag "#DHCP"

:if ( [ :len $leaseActIP ] <= 0 ) do={ :error "empty lease address" }

:if ( $leaseBound = 1 ) do=\
{
  :local ttl
  :local domain
  :local hostname
  :local fqdn
  :local leaseId
  :local comment

  /ip dhcp-server
  :set ttl [ get [ find name=$leaseServerName ] lease-time ]
  network
  :set domain [ get [ find $leaseActIP in address ] domain ]

  .. lease
  :set leaseId [ find address=$leaseActIP ]

# Check for multiple active leases for the same IP address. It's weird and it shouldn't be, but just in case.

  :if ( [ :len $leaseId ] != 1) do=\
  {
   :log info "DHCP2DNS: not registering domain name for address $leaseActIP because of multiple active leases for $leaseActIP"
   :error "multiple active leases for $leaseActIP"
  }

  :set hostname [ get $leaseId host-name ]
  :set comment [ get $leaseId comment ]
  /

  # use comment as hostname if provided
  :if ( [ :len $comment ] > 0  && [:pick $comment 0 1] != "#" ) do={ :set hostname $comment }

  :set hostname [ $CharReplace [ $LowCase $hostname ] " " "-"]

  :if ( [ :len $hostname ] <= 0 ) do=\
  {
    :log info "DHCP2DNS: not registering domain name for address $leaseActIP because of empty lease host-name or comment"
    :error "empty lease host-name or comment"
  }
  :if ( [ :len $domain ] <= 0 ) do=\
  {
    :log info "DHCP2DNS: not registering domain name for address $leaseActIP because of empty network domain name"
    :error "empty network domain name"
  }

  :set fqdn "$hostname.$domain"

  /ip dns static
  :if ( [ :len [ find name=$fqdn and disabled=no ] ] = 0 ) do=\
  {
    :log info "DHCP2DNS: registering static domain name $fqdn for address $leaseActIP with ttl $ttl"
    add address=$leaseActIP name=$fqdn ttl=$ttl comment=$DHCPtag disabled=no
  } else=\
  {
    :log info "DHCP2DNS: not registering domain name $fqdn for address $leaseActIP because of existing active static DNS entry with this name"
  }
  /
} \
else=\
{
  /ip dns static
  :local dnsDhcpId
  :set dnsDhcpId [ find address=$leaseActIP and comment=$DHCPtag ]

  :if ( [ :len $dnsDhcpId ] > 0 ) do=\
  {
    :log info "DHCP2DNS: removing static domain name(s) for address $leaseActIP"
    remove $dnsDhcpId
  }
  /
}
