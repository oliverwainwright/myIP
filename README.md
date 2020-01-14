# myIP
### get your home public Internet IP Address displayed in an aws s3 website

```
I needed a way to keep track of my home Internet public IP Address
in case I wanted to access my home network. This is useful for those of us that
do not have a static IP Address and need access to resources on your home network.

After much deliberation, I decided on AWS S3 Static Website to host the content. 
Here's what you'll need to do to get this to work.

1. Create your AWS S3 bucket:
  a. Use your domainname, example: awesome-s3-site.com
  b. If you do not have a domain, then you can pick any globally unique bucket name
    - you will access this bucket: http://BUCKET-NAME.s3-website-REGION.amazonaws.com
  c. Navigate to S3 in the AWS Console
  d. Click into your bucket
  e. Click "Properties"
  f. Click "Static website hosting" and "use this bucket to host a website"
  g. Go back to "Properties"
  h. Edit "Public Access Settings"
  i. Uncheck the box for "Block all public access"
