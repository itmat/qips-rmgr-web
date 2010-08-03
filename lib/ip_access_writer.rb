require 'erubis'
require 'ohai'

class IpAccessWriter
  
  if IpAccessWriter.os_type() == 'rpm'
    @iptables = IPTABLES_OUTPUT_PATH  ||= '/etc/sysconfig/iptables'
  else
    @iptables = '/etc/iptables-saved'
  end
  
  def initialize(h_file=nil)
  
    @iptables = h_file ||= IPTABLES_OUTPUT_PATH
    
  end 
  
  # Method will determine whether your OS is Mac-based, Debian-based, or an RPM-based distribution of Linux
  def self.os_type()
    sys = Ohai::System.new
    sys.all_plugins
    os = sys[:platform]
    if (os =~ /debian/i || os =~ /ubuntu/i)
      return "debian"
    elsif (os =~ /fedora/i || os =~ /redhat/i || os =~ /centos/i)
      return "rpm"
    elsif (os =~ /mac_os_x/i)
      return "mac"
    end
  end
          
  def self.write_access_file(ip_array=nil)
    unless ip_array.nil?

     f_erb = File.open(IPTABLES_ERB)
     eruby = Erubis::Eruby.new(f_erb.read )
      f = File.open(@iptables, "w+") 
     
      f.write(eruby.result({:ip_array => ip_array}))
            
      f.close
      
    end
    
    #system IPTABLES_RESTART_CMD
    
  end
  
  def self.parse_ip(str)
    if str =~ /ip-(\d+)-(\d+)-(\d+)-(\d+)\..+/
      return "#{$1}.#{$2}.#{$3}.#{$4}"   
    else
      return ''
    end 
  end
  
  def self.host_lookup(str)
    private_ip = `/usr/bin/host #{str} | awk '{print $4}'`
    return private_ip.strip
  end
end
