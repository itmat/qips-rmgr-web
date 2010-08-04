require 'erubis'
require 'ohai'
require 'resolv'

class IpAccessWriter
  
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
  
  if IpAccessWriter.os_type() == 'rpm'
    @iptables = IPTABLES_OUTPUT_PATH  ||= '/etc/sysconfig/iptables'
  else
    @iptables = '/tmp/iptables-saved'
  end
  
  def initialize(h_file=nil)
  
    @iptables = h_file ||= IPTABLES_OUTPUT_PATH
    
  end 
  
  def self.parse_ip(str)
    if str =~ /ip-(\d+)-(\d+)-(\d+)-(\d+)\..+/
      return "#{$1}.#{$2}.#{$3}.#{$4}"   
    else
      return ''
    end 
  end
  
  def self.host_lookup(str)
    private_ip = Resolv.getaddress(str)
    return private_ip.strip
  end
          
  def self.write_access_file(ip_array=nil)
    os_type = self.os_type()
    
    f_erb = nil

    if os_type == 'debian'
      f_erb = File.open(DEB_IPTABLES_ERB)
    else
      f_erb = File.open(RPM_IPTABLES_ERB)
    end
    
    unless ip_array.nil?
    
    eruby = Erubis::Eruby.new(f_erb.read )
    f = File.open(@iptables, "w+") 
    f.write(eruby.result({:ip_array => ip_array}))
    f.close
      
    end
    
    #system IPTABLES_RESTART_CMD
    
  end
end
