#########
  NOTES:
#########

1. To clone the repo and run it successfully, PLEASE make the following changes:

    a. Before making a 'Terraform apply/plan', change value of variable, "ingress_cidr" to 0.0.0.0/0 
    (not secure) or your public ip (which is revealed by cheCking 'whats my IP' on a browser).

    b. Provide a unique bucket name variable, "s3_bucket" (bucket names are unique per region on AWS).
    c. Value to be provided as bucket name should also be typed in place of <BUCKET> in line 49 of 
    'genomics-docker-flask-userdata.sh' script. (THIS CAN BE IMPROVED) using environment variables

    d. Change the value of profile in the genomics-main.tf file to suit your environment


2. A modular approach wasn't adopted due to the simplified flat nature of the infrastructure


3. Also a bastion is not deployed so it's best to use your public IP in 1a. above as webser has been 
deployed directly in the public subnet without a WAF/NF or ALB 


4. Auto build and deploy is not used due to simplified nature of service as noted in 2. above.


5. The infrastructure is provisioned using us-east-1. To change this, line 48 of 
'genomics-docker-flask-userdata.sh' script also needs to be changed in addition to the region value in 
the provider block of 'genomics-main.tf'



