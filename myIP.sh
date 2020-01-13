#!/bin/bash

dir="/var/tmp"
bin="$dir/bin"
html="$dir/html"
iam="$dir/iam"

s3Website="s3://ogun.exit9web.com/"
myIP=`curl http://ifconfig.co`

if [ -f $dir/prevIP.txt ]
then
	prevIP=`cat $dir/prevIP.txt`
else
	prevIP="none"
fi

if [ $myIP != $prevIP ]
then

echo "$myIP" > $dir/prevIP.txt

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

echo "s3 cp $html error.html $s3Website"
aws s3 cp $html $s3Website --recursive
fi	
