參考資料

https://blog.gtwang.org/linux/ubuntu-linux-1804-configure-network-static-ip-address-tutorial/     Ubuntu Linux 18.04 設定靜態網路 IP 位址教學

https://docs.microsoft.com/zh-tw/sql/azdata/install/deploy-install-azdata-linux-package?view=sql-server-ver15  使用 apt 安裝 Azure Data CLI (azdata)

https://docs.microsoft.com/zh-tw/sql/big-data-cluster/deployment-guidance?view=sql-server-ver15  在 Kubernetes 上部署 SQL Server 巨量資料叢集

https://learn.microsoft.com/zh-tw/sql/big-data-cluster/release-notes-big-data-cluster?view=sql-server-ver15 BDC的版本資訊

https://github.com/calebhailey/homelab/issues/3  Kubernetes單node會出問題解決方案
kubectl taint nodes --all node-role.kubernetes.io/master-
新版應該改為
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-

https://www.itread01.com/qll.html 修改時區

https://kubernetes.io/zh-cn/releases/ k8s版本資訊

# Create a Kubernetes cluster using Kubeadm on Ubuntu 16.04 LTS or 18.04 LTS

In this example, we will deploy Kubernetes over multiple Linux machines (physical or virtualized) using kubeadm utility. These instructions have been tested primarily with Ubuntu 16.04 LTS & 18.04 LTS versions.

## Pre-requisites

1. Multiple Ubuntu Linux machines or virtual machines. Recommended configuration is 8 CPUs, 32 GB memory each and at least 100 GB storage for each machine<sup>*</sup>. Minimum number of machines required is three machines
1. Designate one machine as the Kubernetes master
1. Rest of the machines will be used as the Kubernetes agents

<sup>*</sup> The memory requirement listed here is for testing and development scenarios. Production environments require 64 GB memory minimum. Actual limit depends on workload. 

**NOTE: Ensure there is sufficient local storage on your agents. Each volume will use up to 10GB by default. The script creates 25 volumes. Not all of the volumes will be used since it depends on the number of pods being deployed on each agent node. It is recommended to have at least 200 GB of storage on the agent nodes**

### Useful resources

[Deploy SQL Server 2019 big data cluster on Kubernetes](https://docs.microsoft.com/en-us/sql/big-data-cluster/deployment-guidance?view=sqlallproducts-allversions)

[Creating a cluster using kubeadm](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)

[Troubleshooting kubeadm](https://kubernetes.io/docs/setup/independent/troubleshooting-kubeadm/)

### Instructions

1. Start a sudo shell context and Execute [setup-k8s-prereqs.sh](setup-k8s-prereqs.sh/) script on each machine
1. Execute [setup-k8s-master.sh](setup-k8s-master.sh/) script on the machine designated as Kubernetes master (_not_ under sudo su as otherwise you'll setup K8S .kube/config permissions for root)
1. After successful initialization of the Kubernetes master, follow the kubeadm join commands output by the setup script on each agent machine
1. Execute [setup-volumes-agent.sh](setup-volumes-agent.sh/) script on each agent machine to create volumes for local storage
1. Execute ***kubectl apply -f local-storage-provisioner.yaml*** against the Kubernetes cluster to create the local storage provisioner. This will create a Storage Class named "local-storage".
1. Now, you can deploy the SQL Server 2019 big data cluster following instructions [here](https://docs.microsoft.com/en-us/sql/big-data-cluster/deployment-guidance?view=sqlallproducts-allversions). 
Simply type in "local-storage" twice (once for data, once for logs) when facing the following prompt by azdata :

`Kubernetes Storage Class - Config Path: spec.storage.data.className - Description: This indicates the name of the Kubernetes Storage Class to use. You must pre-provision the storage class and the persistent volumes or you can use a built in storage class if the platform you are deploying provides this capability. - Please provide a value:`

### local-storage clean up

If you removed BDC cluster that was previously deployed on Kubernetes cluster that was built using the sample scripts in this guide, you may want to clean the local-storage before using the cluster to deploy new BDC

to clean the storage you need to follow these steps

1) on each worker node make sure ‘/mnt/local-storage’ has only folder structure with no files, you can run ‘tree /mnt/local-storage’ for quick check
2) if you see any files you need to remove them
3) remount the volumes

You can use the following script to clean the volumes. 

**WARNNING**: running this script will **REMOVE** all files that may exists under /mnt/local-storage folders

run the following command to create the script 

```sh
cat > clean-volumes-agents.sh <<EOF
#!/bin/bash -e

# num of persistent volumes
PV_COUNT=25

for i in \$(seq 1 \$PV_COUNT); do

  vol="vol\$i"

  sudo rm -rf /mnt/local-storage/\$vol/*

  mount --bind /mnt/local-storage/\$vol /mnt/local-storage/\$vol

done
EOF

chmod +x clean-volumes-agents.sh
```

### 新增podpreset功能
```
修改
/etc/kubernetes/manifests/kube-apiserver.yaml
 在 - command: 修改/加入以下2條
    - --enable-admission-plugins=NodeRestriction,PodPreset  
    - --runtime-config=settings.k8s.io/v1alpha1=true
```

https://learn.microsoft.com/zh-tw/sql/big-data-cluster/configure-bdc-postdeployment?view=sql-server-ver15 新版可直接設定時區

```
azdata bdc settings set --settings bdc.timezone=Asia/Taipei 一直失敗，嘗試改成Asia/Shanghai，還是不行，已放棄
azdata bdc settings apply
azdata bdc upgrade -t 2019-CU6-ubuntu-16.04 --controller-timeout=40 --component-timeout=40 --stability-threshold=3 供參考用，怕逾時應該可以增加timeout時間
```

還原資料庫後帳號可能無法對應，因此需要用以下方式對應

ALTER USER
使用此方式可以修改登入USER的名稱或變更其預設結構描述
在這個狀況下我們可以用LOGIN，去更正不相符的 SID
```
USE XXDB
GO
ALTER USER accout_test
WITH LOGIN = accout_test;
```

