# Prerequisites
**Prerequisites must be set if mysql.aws.enabled is true in values.yaml**

## Install Kubernetes Service Catalog

```bash
$ helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
$ helm install svc-cat/catalog --name catalog --namespace catalog --wait
```

## Install AWS Service Broker

The first step is to set up the prerequisites. This can be done easily using a CloudFormation template that creates the required IAM User and DynamoDB table. The following code block uses the AWS CLI to launch the template and gather the needed outputs. Be sure to set the REGION variable to the AWS region where you would like to have the broker provision resources.

```bash
REGION=us-west-2
# Download the template
wget https://raw.githubusercontent.com/awslabs/aws-servicebroker/master/setup/prerequisites.yaml
# Create stack
STACK_ID=$(aws cloudformation create-stack \
             --capabilities CAPABILITY_IAM \
             --template-body file://prerequisites.yaml \
             --stack-name  aws-service-broker-prerequisites \
             --output text --query "StackId" \
             --region ${REGION})
# Wait for stack to complete
until \
    ST=$(aws cloudformation describe-stacks \
        --region ${REGION} \
        --stack-name ${STACK_ID} \
        --query "Stacks[0].StackStatus" \
        --output text); \
        echo $ST; echo $ST | grep "CREATE_COMPLETE"
    do sleep 5
done
# Get the username from the stack outputs
USERNAME=$(aws cloudformation describe-stacks \
             --region ${REGION} \
             --stack-name ${STACK_ID} \
             --query "Stacks[0].Outputs[0].OutputValue" \
             --output text)
# Create IAM access key. Note down the output, we'll need it when setting up the broker
aws iam create-access-key \
    --user-name ${USERNAME} \
    --output json \
    --query 'AccessKey.{KEY_ID:AccessKeyId,SECRET_ACCESS_KEY:SecretAccessKey}'
```
Now we’re ready to install the broker, first adding the repository to Helm:

```console
helm repo add aws-sb https://awsservicebroker.s3.amazonaws.com/charts
```
Replace <ACCESS_KEY_ID> and <SECRET_ACCESS_KEY> below with the output saved from the output of the aws create-access-key command:

```console
helm install aws-sb/aws-servicebroker \
    --wait \
    --name aws-servicebroker \
    --namespace aws-sb \
    --set aws.region=${REGION} \
    --set aws.accesskeyid=<ACCESS_KEY_ID> \
    --set aws.secretkey=<SECRET_ACCESS_KEY>
```

Now verify that the broker pod is running:

```console
helm ls --namespace aws-sb
kubectl get ClusterServiceBrokers
```

Now you can list the available services:

```console
kubectl get ClusterServiceClasses \ -o=custom-columns=NAME:.spec.externalName,DESCRIPTION:.spec.description
```

# [jmeter image](https://hub.docker.com/r/justb4/jmeter)

# Spring Chart

[Spring](http://spring.io/) is a modern Java framework for developing Cloud Native Applications.

## Chart Details

This chart is designed to be a general purpose chart for running Spring based applications, most simple Spring applications should run with little to no modification of this Chart. For the sake of example this chart is configured to deploy the Spring Petclinic example application, but simply changing the image and tag should be enough to run a different app.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/spring
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the drone charts and their default values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install --name my-release -f values.yaml stable/spring
```

> **Tip**: You can use the default [values.yaml](values.yaml)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | The number of replicas | `1` |
| `image.repository`  | location of image to run | `paulczar/petclinic` |
| `image.tag`         | **server** image tag | `2.1.0.BUILD-SNAPSHOT` |
| `image.pullPolicy`  | **server** image pull policy | `IfNotPresent` |
| `serviceAccount.create` | If true, create and use service account | `true` |
| `serviceAccount.name` | If set override the name of the service account |  |
| `rbac.create`  | If true, create and use RBAC resources | `true` |
| `resources` | Resource requests and limits | `{}` |
| `tolerations` | List of node taints to tolerate | `[]` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `podAnnotations` | Annotations to apploy to the pod | `{}` |
| `spring.profile` | The spring profile to activate | `nil` |
| `spring.trustKubernetesCertificates` | ensure spring trusts kubernetes certs | `true` |
| `spring.config.type` | type of spring config (currently only supports `file`) | `file` |
| `spring.config.content` | YAML to be placed in `/config/application.yml` | `nil` |
| `spring.config.secretName` | Name of a secret containing `secret.yml:` key to be placed in `/config/secret.yml` | `nil` |
| `containerPort` | the port your application listens on | `8080` |
| `extraEnv` | extra environment variables to pass to your application | `{}` |
| `livenessProbe` | Values to enable livenessProbe suitable for your application | `{}` |
| `readinessProbe` | Values to enable readinessProbe suitable for your application | `{}` |
| `service.enabled` | Enable creating a service | `true` |
| `service.type` | Kubernetes Service type | `ClusterIP` |
| `service.httpPort`| Service HTTP port | `80` |
| `service.nodePort` | Kubernetes http node port | `nil` |
| `service.externalTrafficPolicy` | Enable client source IP preservation | `Cluster` |
| `service.loadBalancerIP` | LoadBalancerIP for the App | `nil` |
| `service.annotations` | Service annotations | `{}` |
| `ingress.enabled` | Enable ingress controller resource | `false` |
| `ingress.annotations` | Ingress annotations | `[]` |
| `ingress.certManager` | Add annotations for cert-manager | `false` |
| `ingress.hosts` | Hostname(s) to your spring app | `[]` |
| `ingress.tls.secretName` | Name of secret holding TLS certs | `nil` |
| `ingress.tls.hosts` | Hostname(s) to your spring app behind TLS | `[]` |

## [aws service broker](https://hub.docker.com/r/justb4/jmeter)
