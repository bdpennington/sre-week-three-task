#! /bin/bash

# 1. Define Variables: Set the namespace, deployment name, and maximum number of restarts allowed before scaling down the deployment.
namespace="sre"
deployment="swype-app"
max_restarts=3

# 2. Start a Loop: Begin an infinite loop that will continue until explicitly broken.
while true; do
  # 3. Check Pod Restarts: Use the kubectl get pods command to retrieve the number of restarts of the pod associated with the specified deployment in the specified namespace.
  restarts=$(kubectl get pods -n $namespace | grep $deployment | awk '{print $4}')

  # 4. Display Restart Count: Print the current number of restarts to the console.
  echo "Current restarts: $restarts"

  # 5. Check Restart Limit: Compare the current number of restarts with the maximum allowed number of restarts.
  if [ $restarts -gt $max_restarts ]; then
    # 6. Scale Down if Necessary: If the number of restarts is greater than the maximum allowed, print a message to the console, scale down the deployment to zero replicas using the kubectl scale command, and break the loop.
    echo "Exceeded maximum restarts. Scaling down deployment."
    kubectl -n $namespace scale deploy/$deployment --replicas=0
    break
  fi
  # 7. Pause: If the number of restarts is not greater than the maximum allowed, pause the script for 60 seconds before the next check.
  sleep 60
done

exit 0
