Follow these only if you don't have a Twitter Developer account

1. Download the Archive from <a href="https://s3-eu-west-1.amazonaws.com/socialmediaanalytics-5-tweetsbucket-8joer2fhzeoe/Archive.zip"> here </a>

2. Unzip the file Archive.zip

3. Go to CLI (command line) and navidate to the unzipped folder Archive 

4. Run following command from inside the folder Archive:

aws s3 cp . s3://YOUR-BUKCET --recursive

where YOUR-BUCKET is the bucket created by Cloudformation template.

4. Once the command finishes running you should see see 3 folders (raw, sentiment & entities) in the your bucket.

5. You can follow the workshop guide starting at setion "Create the Athena tables"
