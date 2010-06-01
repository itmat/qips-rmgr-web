require 'right_aws'

#################################################
###
##     Andrew Brader - ITMAT @ UPENN
#      S3 Helper  Uploads files and gives READ permission to everyone
#
#
####  

class S3Helper

    @s3int = RightAws::S3Interface.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    @s3 = RightAws::S3.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

    def self.upload(bkt, filename, contents)
        @s3int.put(bkt, filename, contents)
        s3_bkt = @s3.bucket(bkt, true)
        key = s3_bkt.key(filename, true)
        RightAws::S3::Grantee.new(key, 'http://acs.amazonaws.com/groups/global/AllUsers', ['READ'], :apply)
    end

end