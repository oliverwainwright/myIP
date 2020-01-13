#!/bin/bash

myIP=`curl http://ifconfig.co`

if [ -f prevIP.txt ]
then
	prevIP=`cat prevIP.txt`
else
	prevIP="none"
fi

if [ $myIP != $prevIP ]
then

echo "$myIP" >> prevIP.txt

cat <<- EOF > index.html
<!DOCTYPE html>
<html>
<body>
<h1>My IP Address</h1>
<p>My IP Address is $myIP</p>
<p>Page generated on `date +%c`</p>
</body>
</html>
EOF

cat <<- EOF > error.html
<!DOCTYPE html>
<html>
<body>
<h1>Does Not Compute</h1>
<p>Page not found.</p>
<p>Generated on `date +%c`</p>
</body>
</html>
EOF

echo "s3 cp index.html error.html $s3website"
fi	
