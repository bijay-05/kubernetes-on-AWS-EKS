# Debugging Notes

1. Once I was setting up **IRSA IAM Role For Service Accounts** with eksctl. Then it kept throwing below output. Earlier, it used to output, that IAM Role and Service Account creation. But this time, it insisted that Service Accounts already exist, while running `kubectl get sa -n kube-system` command did not show them.

After a bit of debugging and giving ChatGPT narrower context (like, IAM Role mentioned in the output of **eksctl** command did not exist in the AWS), it was found that Cloudformation stack created by previous run of **eksctl** command was not deleted from the AWS. And it was assumed that IAM Role and Service Account already exist.

```bash
2 existing iamserviceaccount(s) (kube-system/aws-load-balancer-controller,kube-system/ebs-csi-controller-sa) will be excluded
```
