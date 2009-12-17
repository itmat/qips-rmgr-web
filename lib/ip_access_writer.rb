require 'erubis'

class IpAccessWriter
  
    @iptables = IPTABLES_OUTPUT_PATH  ||= '/etc/sysconfig/iptables'
  
  def initialize(h_file=nil)
  
    @iptables = h_file ||= IPTABLES_OUTPUT_PATH
    
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
  
end
