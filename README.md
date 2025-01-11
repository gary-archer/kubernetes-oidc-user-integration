# Manage Kubernetes Users with OpenID Connect

Kubernetes supports user authentication with [OpenID Connect ID Tokens](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens).\
This enables various use cases, where you restrict team Kubernetes permissions by user type:

- Locking down access to the `kubectl` tool.
- Locking down access to the [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

## Tokens and User Permissions

Kubernetes user level access typically represents employees that you organize into groups.\
Each group can be assigned restricted Kubernetes permissions using role based access control.

Your authorization server can issue ID tokens that Kubernetes treats as user assertions to authenticate users.\
Kubernetes allows you to map an ID token claim like `employee_groups` to a Kubernetes role:

```json
{
  "sub": "john.doe",
  "iss": "https://login.example.com",
  "aud": "kubernetes-client",
  "employee_groups": ["engineers"],
  "iat": 1736616585042,
  "exp": 1737516615.042
}
```

## Kubernetes Token Validation

The Kubernetes API server requires calls these authorization server endpoints to validate ID tokens:

- An OpenID Connect discovery endpoint that uses TLS.
- A JWKS URI with the token signing public keys.

## Productive Integrations

When getting integrated it can be useful to:

- Implement the integration work on a development cluster.
- Quickly issue tokens as one or more test users.

To do so you can use the techniques from [Testing Zero Trust APIs](https://curity.io/resources/learn/testing-zero-trust-apis/) and work with a mock authorization server.

## Testing the Flow

This GitHub repo provides a mock authorization server that you can use to get integrated.

### Prerequisites

First ensure that these tools are installed:

- A Docker engine
- Kubernetes in Docker (KIND) running Kubernetes 1.30+
- Node.js 20+
- OpenSSL 3+
- The envsubst tool

### Create a Local Cluster

Create a KIND cluster:

```bash
kind create cluster --name=demo
```

The default configuration at `~/.kube/config` runs as user `kubernetes-admin` with access to all resources:

```bash
kubectl get pod -A
```

### Deploy the Mock Authorization Server

Build and deploy the mock authorization server as a Docker container.\
If required, run the authorization server locally to understand its code and operations.

```bash
./mock-authorization-server/build.sh
./mock-authorization-server/deploy.sh
```

### Get a User Assertion

Then get a user level ID token to use with the kubectl tool:

```bash
cd mock-authorization-server
npm run create-user-assertion
```

### Run Kubernetes Commands with Restricted Privileges

TODO:

- Create a `~/.kube/config` file from an ID token
- Create a role and role binding for `developers` and `devops` groups
- Use kubectl as both users

Strggling with:

- Cluster startup with the new authentication-config parameter
- https://github.com/gardener/gardener/issues/9858
- Get it working first without the certificateAuthority

### Free Resources

Free resources when finished testing:

```bash
kind delete cluster --name=demo
```
