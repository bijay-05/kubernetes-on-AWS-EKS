# AWS Load Balancer Controller

We will use **AWS Load Balancer Controller** to expose web applications outside the cluster. The controller creates, manages and destroys **AWS ELB** instances upon creation/deletion of Cluster resources such as Ingress and Services (Service should be of type `LoadBalancer`). The ALB Controller pods require permissions to manage AWS Resources on your behalf. For this, we will use **IRSA (IAM Role for Service Accounts)**.

1. Create Role with necessary permissions/policies with Terraform while provisioning whole infrastructure.

2. Deploy the controller with Helm, passing created IAM Role's ARN as annotation to the helm command.

## Deployment

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=modern-jazz-mushrooms --set serviceAccount.create=true --set serviceAccount.name=aws-load-balancer-controller --set-string serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::462035739353:role/AWSLoadBalancerController_Role" --set region=ap-northeast-2 --set vpcId=<VPC_ID> --set image.repository=<AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-load-balancer-controller --set image.tag=v3.5.0 --set enable-shield=false --set enable-waf=false --set enable-waf-v2=false
```
