# MariaDB Galera Cluster Deployment

This repository contains Helm charts and CircleCI workflows for deploying a MariaDB Galera cluster on Kubernetes. The setup includes Helm charts for the database configuration and CircleCI pipelines to automate the deployment process. The solution is implemented this way to leverage the benefits of Helm and Kubernetes for simplified deployment, management, and high availability of the MariaDB Galera cluster.

## File Structure

├── .circleci
│   └── config.yml
├── charts
│   └── mariadb-galera
│       ├── Chart.yaml
│       ├── templates
│       │   ├── _helpers.tpl
│       │   ├── pvc.yaml
│       │   ├── service-headless.yaml
│       │   ├── service.yaml
│       │   └── statefulset.yaml
│       └── values.yaml
├── scripts
│   ├── publish.sh
│   └── deploy.sh
└── README.md

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+


## Helm Chart

The Helm chart is located in the `charts/mariadb-galera` directory. The chart includes the following files:

- `Chart.yaml`: Metadata about the chart.
- `values.yaml`: Default configuration values for the chart.
- `templates/_helpers.tpl`: Template helper functions.
- `templates/pvc.yaml`: Persistent Volume Claim template.
- `templates/service-headless.yaml`: Headless service template.
- `templates/service.yaml`: Service template.
- `templates/statefulset.yaml`: StatefulSet template.

char repo: ![db-charts-repo](https://github.com/cleverom/db-charts/tree/gh-pages)

## Why Helm Charts was used

### Simplified Deployment and Management
- Reusability: Helm charts package Kubernetes resources, making it easy to reuse and share configurations.
- Automation: Helm automates the deployment process, reducing manual steps and potential errors.
Version Control: Helm charts can be versioned, allowing for easy rollback and upgrade of applications.

### Consistency and Standardization
- Uniform Configuration: Ensures that all instances of MariaDB are configured consistently.
Best Practices: Helm charts often encapsulate best practices, improving the reliability and security of deployments.
Scalability
- Replica Management: Helm charts can manage stateful sets, ensuring that the desired number of replicas (database instances) is maintained.
- Horizontal Scaling: Easily scale the number of MariaDB instances by updating the values file and redeploying the chart.
Maintainability
- Parameterization: Configurable parameters in values.yaml make it easy to update settings without modifying the core templates.
- Templates: Helm uses Go templates, which allow for flexible and dynamic configurations.

### High Availability and Failover
- Service Discovery: Kubernetes and Helm handle service discovery, ensuring that clients can connect to any healthy instance.
Self-Healing: Kubernetes automatically restarts failed containers, and Helm can help manage these pods, ensuring high availability.
Portability
- Cross-Cluster Deployment: Helm charts can be easily deployed to different Kubernetes clusters, providing portability across environments.
- Cloud Agnostic: Helm charts work with any Kubernetes-compliant cluster, whether on-premises or in the cloud (e.g., GKE, EKS, AKS).

# How to Deploy

- Set Up CircleCI: Ensure you have CircleCI configured for your repository.
- Add Environment Variables to secrets(depending on the CI/CD platform):
    - cluster_zone: Google compute zone
    - cluster_name: The name of the cluster(either on GCP, AWS etc)
    - project_id: The Id for the project created
    - service_key: GCP service account JSON key.
- Push Changes: Push your changes to the repository(master branch) to trigger the CircleCI pipeline.

## Notes and Explanation

- StatefulSet: The StatefulSet ensures stable network identities and persistent storage for each pod. This is crucial for the Galera cluster as each node (pod) must be able to reconnect to the cluster using a stable identity.

- Environment Variables:
  - MARIA_DB_GALERA_CLUSTER_BOOTSTRAP is set to yes to indicate the cluster initialization.
  - MARIA_DB_GALERA_CLUSTER_ADDRESS provides the addresses of the other nodes in the cluster, ensuring they can connect and form the cluster.
  - MARIA_DB_GALERA_NODE_ADDRESS dynamically assigns the pod's IP address, ensuring each node can be uniquely identified in the cluster.

- Persistent Storage: The volumeMounts and volumeClaimTemplates ensure that each MariaDB instance has persistent storage, which is critical for maintaining data consistency across reboots and failures.

- Headless Service: The headless service enables the StatefulSet pods to communicate with each other using DNS, essential for Galera clustering.

- ClusterIP Service: This service exposes the MariaDB cluster internally within the Kubernetes cluster, enabling other services to connect to the MariaDB cluster using a single endpoint.

- Resource Requests and Limits: Specifying resource requests and limits for CPU and memory ensures that each MariaDB instance has sufficient resources to operate efficiently and avoid resource contention.