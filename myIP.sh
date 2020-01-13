#!/bin/bash
#
# Date: 2020-01-12
# Environment: Linux/AWS
# Author: oliverwainwright.io
# Description: Display home/office public IP Address on AWS S3 Website
# Prerequisites: AWS CLI tool, AWS Account, AWS S3 Bucket, AWS IAM Policy for
# account to access your S3 Bucket and nothing else

# Your S3 bucket name
# Replace "YOUR_BUCKET" with your actual S3 Bucket Name
YOUR_BUCKET="S3BucketName"

#set variables
dir="/var/tmp"
html="$dir/html"
s3Website="s3://$YOUR_BUCKET/"

#create directory for webpages
if [ ! -d $html ]
then
	mkdir $html
fi

#feeling lazy, need to add a check to see if this is successful
#use one of these to set the $myIP variable
myIP=`curl http://ifconfig.co`
#myIP=`curl http://ifconfig.me` 
#myIP=`curl http://icanhazip.com`

if [ -z $myIP ]
then
	echo "\$myIP is not set" | logger -t myIP
	exit
fi
	
#get previous ip address to compare with current ip address
if [ -f $dir/prevIP.txt ]
then
	prevIP=`cat $dir/prevIP.txt`
else
	prevIP="none"
fi

#compare current ip address with previous ip address
#only update new webpages if the public ip address changes
if [ $myIP != $prevIP ]
then
	echo "we've got a new ip address: $myIP" | logger -t myIP
	echo "$myIP" > $dir/prevIP.txt

#here document for index.html
cat <<- EOF > $html/index.html
<!DOCTYPE html>
<html>
<body>
<h1>My IP Address</h1>
<p>My IP Address is $myIP</p>
<p>Page generated on `date +%c`</p>
</body>
</html>
EOF

#here document for error.html
cat <<- EOF > $html/error.html
<!DOCTYPE html>
<html>
<body>
<h1>Does Not Compute</h1>
<p>Page not found.</p>
<p>Generated on `date +%c`</p>
</body>
</html>
EOF

echo "upload new webpages to s3 static website" | logger -t myIP
aws s3 cp $html $s3Website --recursive
else
	echo "no change in ip address: $myIP" | logger -t myIP
	echo "no webpages uploaded" | logger -t myIP
fi	
