// Your Amazon Web Service Access Key http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
aws_access_key = ""
// Your Amazon Web Service private secret Key
aws_secret_key = ""

// The AWS Region where to build
aws_region = "eu-west-1"
// 2 different Availability Zone for the previous AWS Region
aws_az1 = "eu-west-1a"
aws_az2 = "eu-west-1b"

// Your SSH public key to connect to AWS EC2 instances e.g. : the content of ~/.ssh/id.rsa.pub
admin_ssh_public_key = ""

// the IP addresses (CIDR range) to restrict SSH access to the bastions
sg_ssh_cidr = "0.0.0.0/0"

// Gitlab Postgresql Database password
gitlab_db_password = ""
// Gitlab default root account password
gitlab_root_password = ""
// Gitlab default Registration token for Gitlab CI
gitlab_ci_registration_token = ""

// your AWS route 53 Zone Base Domain e.g.: "my-domain.com"
aws_dns_zone = ""
// the Gitlab subdomain
gitlab_dns_subdomain = "gitlab"
// the Bastion subdomain
bastion_dns_subdomain = "bastion1"

// Number of Gitlab static instances (not in the autoscaling group)
gitlab_static_instances = 0

// Gitlab autoscaling
// Maximum number of Gitlab instances
gitlab_max = 3
// Minimum number of Gitlab instances
gitlab_min = 1
// Desired number of Gitlab instances
gitlab_desired = 2
