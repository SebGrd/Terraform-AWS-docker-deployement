# Terraform AWS Github repository deployement
*Izïa CRINIER | Sébastien GAUDARD*
## Description
This Terraform project lets you deploy an **AWS EC2** (t2.micro) and automatically **clone your repository**. Combined with **docker**, it will automatically run your project on instance creation.
## Usage
***Important: You will need a repository that is using a docker-compose file with the app running on port 80***  

First, create an AWS IAM user and create his access keys to run this Terraform projet.  
Of course, the repository of your choice.  
And finnaly our will need to create a key pair to let Terraform access the AWS instance :  
```
$ ssh-keygen -t ed25519 -f ./FILE_NAME
```
### Variables (.tfvars)
You'll need to configure the following code and add it to the `terraform.tfvars.json` file.

```json
{
  // This is located in your IAM user informations
  "access_key": "IAM_USER_ACCESS_KEY", 
  // This is only availaible at the creation of your access key
  "secret_key": "IAM_USER_SECRET_KEY", 
  // This is the path to the public key you generated
  "key_pub_path": "./FILE_NAME.pub",
  // This is the path to the private key you generated
  "key_private_path": "./FILE_NAME",
  // This is the folder name of the cloned app. Default is "app"
  "git_project_name": "app",
  // This is the .git URL link of the repo that will be cloned
  "git_url": "https://github.com/19946-Dresden-St/hello-world.git"

}
```
## Running
To run the project use :
```
terraform plan
```
```
terraform apply
```
If you need to take down the generated instances, simply run :
```
terraform destroy
```