#!/bin/bash
trap read DEBUG
echo "We'll look into how to deploy an OSD operator to Hypershift Hosted Controlplane with Policy,
Steps i have already done before this session:
1. Install ACM into this manangement cluster "
echo " oc get ns | grep open-cluster-management"
 oc get ns | grep open-cluster-management
echo " 2. Added the HCP i have created to ACM"
echo " oc get ManagedCluster -o name"
 oc get ManagedCluster -o name
echo " 2.5 Since i want to install the operator onto both of these HCP, i have added a label HCP=true to these two HCP"
echo "oc describe ManagedCluster clusters-l-4-10-hshift-13687 | grep HCP"
 oc describe ManagedCluster clusters-l-4-10-hshift-13687 | grep Labels
echo "oc describe ManagedCluster clusters-l-4-10-hshift-25852 | grep HCP"
 oc describe ManagedCluster clusters-l-4-10-hshift-25852 | grep Labels

echo "3. Install a policy generetor that could generate the Policy, Placement Rule and Placement Binding from the Yaml fille we pass in : https://github.com/stolostron/policy-generator-plugin"

echo "Ok now we're ready to install Operator with policy"
echo "1. Generate policy"
echo "1.1 Have manifest file that contains the configurations of the operator:"
 less  osd-metrics-exporter.yaml
echo " In the same directory, create a policy-generator-config.yaml. This contains the instructions of the policies to generate"
 less policy-generator-config.yaml
echo " Now we can generate the policy by running"
echo " PolicyGenerator policy-generator-config.yaml > policy-osd-metrics-exporter.yaml"
 PolicyGenerator policy-generator-config.yaml > policy-osd-metrics-exporter.yaml

echo "The generated policy will look like this:"

 less policy-osd-metrics-exporter.yaml

echo "Right now, on the HCP there won't be an openshift-osd-metrics and the resources for the osd-metrics exporter. the Policy will create them"

echo " KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-25852 oc get all -n openshift-osd-metrics"
 KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-25852 oc get all -n openshift-osd-metrics

echo " KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-13687 oc get all -n openshift-osd-metrics"
 KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-13687 oc get all -n openshift-osd-metrics


echo " Now we can apply the policy and see what it looks like"

echo "oc apply -f policy-osd-metrics-exporter.yaml"
 oc apply -f policy-osd-metrics-exporter.yaml

echo " oc get policy -A"
 oc get policy -A

echo "We can see the Policy has been created in the test-osd-policy and then Propagated to the two HCPs"

echo "We can check the subscription and see the status"

echo " oc get subscriptions -A"
 oc get subscriptions -A

echo " Now we check the HCP to see if all the resources have been created"

echo "KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-25852 oc get all -n openshift-osd-metrics"
 KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-25852 oc get all -n openshift-osd-metrics

echo "KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-13687 oc get all -n openshift-osd-metrics"
 KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-13687 oc get all -n openshift-osd-metrics

echo "So the registry pod is throwing an error. Instead of editing the pod, we'll try editing the policy to see if that will be sync to the HCPs"

echo " oc edit policy osd-metrics-exporter-subscription -n test-osd-policy"
 oc edit policy osd-metrics-exporter-subscription -n test-osd-policy

echo " oc get policy -A"
 oc get policy -A

echo " let's check the HCPs to see if the pod is fixed"

echo " KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-25852 oc get all -n openshift-osd-metrics"
 KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-25852 oc get all -n openshift-osd-metrics
echo " KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-13687 oc get all -n openshift-osd-metrics"
 KUBECONFIG=/tmp/kubeconfig-l-4-10-hshift-13687 oc get all -n openshift-osd-metrics

