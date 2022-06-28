#########
  NOTES:
#########

To clone the repo and run it successfully, you'll need to make the following changes:
    1. Change value of variable, "ingress_cidr" to 0.0.0.0/0 (insecure) or your public ip (which is revealed by cheking 'whats my IP' on a browser)
    2. Provide a unique bucket name variable (bucket names are unique per region on AWS)
    3. Value to be provided as bucket name should be typed in place of <BUCKET> in line 49 of genomics-docker-flask-userdata.sh script 
        (THIS CAN BE IMPROVED) using environment variables



