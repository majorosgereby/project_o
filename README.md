# project_o

## The server

The server is an express server running on NodeJS. To run the server file `NodeJS` and `npm` is required.

### Installation

First, the requried packages (found in `package.json`) need to be installed:

```bash
npm i
```

### Running the server

The server by default runs on port `3000`, but this can be overwritten by supporting a `.env` file in the same directory. A `.env_example` can be found in the directory.

```bash
PORT=8128
```

To run the server, type the following command:

```bash
npm start
```

First it will try for `.env`, if it isn't found it runs without it.

## The Docker image of the server

Using Docker the image of the server can be built locally: (In the example `project_o` tag is given)

```bash
docker build -t project_o .
```

When running the container we have the option to either use the default port (3000) or support the same `.env` file as before. The examples will run the container in detached mode.

Without `.env`:

```bash
docker run -d -p LOCAL_PORT:3000 project_o
```

With `.env`:

```bash
docker run -d --env-file .env -p LOCAL_PORT:ENV_PORT project_o
```

## Releasing the image to ECR

The provided [github action](.github/workflows/deploy.yaml) releases the image to AWS ECR on every *push to main* action.

Setting up this workflow with own credentials requires an AWS account and preferably aws cli.

GitHub has to be added as an OCID provider for AWS, this can be done with

```bash
aws iam create-open-id-connect-provider \
--url "https://token.actions.githubusercontent.com" \
--thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" "1c58a3a8518e8759bf075b76b750d4f2df264fcd" \
--client-id-list "sts.amazonaws.com"
```

An IAM role needs to be created with `AmazonEC2ContainerRegistryFullAccess` and `AWSCodePipeline_FullAccess`; and it has to use the following trust policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:<REPO_NAME>*"
                },
                "ForAllValues:StringEquals": {
                    "token.actions.githubusercontent.com:iss": "https://token.actions.githubusercontent.com",
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
```

And these few lines have to be updated in the yaml file to run:

```yaml
          role-to-assume: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<IAM_ROLE_NAME>
          aws-region: <AWS_REGION_CODE>
```

```yaml
          ECR_REPOSITORY: <ECR_REPOSITORY_NAME>
```

## Kubernetes deployment

The application can be deployed from ECR to an AWS cluster.

With eksctl and kubectl the whole process can be run from this repository.

- [cluster_create.sh](./k8/cluster_create.sh) creates a cluster with 2 nodes on AWS.
- [kubectl_apply_commands.sh](./k8/kubectl_apply_commands.sh) creates the [namespace](./k8/namespace.yaml), the [deployment](./k8/deployment.yaml) and the [service](./k8/service.yaml) to run the application.
- `kubectl get service -n project-o-namespace` will provide the required external-ip address to the application. It is running on port 80, http.

Everything could be deleted from the repository too: [kubectl_delete_commands.sh](./k8/kubectl_delete_commands.sh) has all the commands to remove the deplyoment from the cluster and [cluster_delete.sh](./k8/cluster_delete.sh) contains the neccesery command to remove the cluster entirely.

## Terraform deployment

This configuration fully handles the tasks in the previous configuration: creates the cluster on AWS and deploys the application via Terraform. THe cluster creation is heavily based on [this Hashicorp tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks).

### Creating the deployment

Navigate to the `tf` folder. Then use these 2 commands to initialize and create the configuration.

```bash
terraform init
terraform apply -auto-approve
```

Kubectl (kubeconfig) can be updated via:

```bash
$ aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

### Destroying the deployment

Terraform can destroy the resources too:

```bash
terraform destroy -auto-approve
```