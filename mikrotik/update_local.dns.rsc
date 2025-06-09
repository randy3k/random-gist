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

:log info "Running UpdateLocalDNS script"

:local DHCPtag "#DHCP"

/ip dhcp-server lease
:foreach lease in=[find] do={
  :local ipAddress [get $lease active-address];
  :local hostName [get $lease host-name];
  :local comment [get $lease comment];
  :local leaseServerName [get $lease server];
  :local ttl

  :if ([:len $leaseServerName] > 0 && [:len $ipAddress] > 0) do= {
    /ip dhcp-server
    :set ttl [get [find name=$leaseServerName] lease-time]

    /ip dhcp-server network
    :local domain [ get [ find $ipAddress in address ] domain ]

    :if ( [ :len $comment ] > 0  && [:pick $comment 0 1] != "#" ) do={ :set hostName $comment }
    :set hostName [ $CharReplace [ $LowCase $hostName ] " " "-"]

    :if ([:len $hostName] > 0 && [:len $domain] > 0) do={
      :local fqdn "$hostName.$domain"

      /ip dns static
      :if ([find name=$fqdn] = "") do={
        add name=$fqdn address=$ipAddress ttl=$ttl comment=$DHCPtag disabled=no
        :log info ("DNS record added for " . $fqdn . " (" . $ipAddress . ")");
      }
    }
  }
}
