# myIP
### get your home public Internet IP Address displayed in an AWS S3 website

```
I needed a way to keep track of my home Internet public IP Address
in case I wanted to access my home network. This is useful for those of us that
do not have a static IP Address and need access to resources on your home network.

After much deliberation, I decided on AWS S3 Static Website to host the content. 
Here's what you'll need to do to get this to work.

1. Create a dedicated IAM user to upload files to your S3 bucket
  a. This user should have programmatic access only
  b. Save your credentials.csv file, it contains your secret key and access key

2. Install and configure the aws-cli tool
  a. Use your credtials.csv to configure your aws cli
  
3. Create IAM Policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListObject"
                ],
            "Resource": [
                "arn:aws:s3:::YOUR-BUCKET"
                ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
                ],
            "Resource": [
                "arn:aws:s3:::YOUR-BUCKET/*"
                ]
        }
    ]
}

4. Create IAM Group and add newly created user to IAM Group

5. Attach IAM Policy to the IAM Group

6. Create your AWS S3 bucket
  a. Use your domainname, example: awesome-s3-site.com
  b. If you do not have a domain, then you can pick any globally unique bucket name
    i. you will access this bucket: http://YOUR-BUCKET.s3-website-REGION.amazonaws.com
  c. Navigate to S3 in the AWS Console
  d. Click into your bucket
  e. Click "Properties"
  f. Click "Static website hosting" and "use this bucket to host a website"
  g. Go back to "Properties"
  h. Edit "Public Access Settings"
  i. Uncheck the box for "Block all public access"

7. Create S3 Bucket Policy for your S3 bucket to permit anonymous access to webserver files.
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
                ],
            "Resource": [
                "arn:aws:s3:::YOUR-BUCKET",
                "arn:aws:s3:::YOUR-BUCKET/*"
                ]
        }
    ]
}

8. From a machine on your home network do the following
  a. Download myIP.sh from github and save to a directory in your path, example /usr/local/sbin/myIP.sh
  b. Make sure it is executable, chmod 755 /usr/local/sbin/myIP.sh
  c. Add your S3 bucket name to the script
  e. For unattended operations, make your script a cron job to run at time and interval of your choosing
```

