require 'right_aws'

#################################################
###
##     Andrew Brader - ITMAT @ UPENN
#      S3 Helper  downloads and uploads files 
#
#
####  

class S3Helper

    @s3 = RightAws::S3Interface.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

    def self.upload(bucket, filename, contents)
        @s3.put(bucket, filename, contents)
    end

end