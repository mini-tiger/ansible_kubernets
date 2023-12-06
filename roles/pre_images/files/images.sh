#!/bin/bash
#set -ex && set -o pipefail
registry_addr=$1:5000
pushd $2
for i in `kubeadm config images list --config=kubeadm-config.yaml` 
do 
   image_name=$(echo $i|cut -d "/" -f 3)
   echo $image_name
   ctr image pull $i
   ctr image tag $i ${registry_addr}/k8simages/${image_name}
   ctr i push --skip-verify --platform amd64  --plain-http ${registry_addr}/k8simages/${image_name}
   # Check if the push was successful
   if [ $? -ne 0 ]; then
       echo "Failed to push image: ${registry_addr}/k8simages/${image_name}"
       exit 1  # Exit the script with a non-zero status
   fi
done
popd
exit 0
