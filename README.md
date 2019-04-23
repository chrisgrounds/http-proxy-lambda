# HTTP-Proxy-Lambda

This is a CORS-enabled HTTP Proxy using Haskell and AWS Lambda to achieve a type-safe :fire:, low-cost :heavy_dollar_sign:, and highly-maintainable :computer: experience. 

This has been deployed to AWS Lamda, which you can use in the following way to proxy, for example, _https://bbc.co.uk_:

```
https://ios10m3q6k.execute-api.us-east-1.amazonaws.com/dev/endpoint/bbc.co.uk
```

You can pass any domain you would like to be proxied after _endpoint_

```
https://ios10m3q6k.execute-api.us-east-1.amazonaws.com/dev/endpoint/{DOMAIN}
```

Your request will be proxied through AWS _us-east-1_ servers.

## Development

### Dependencies

- docker
- stack
- serverless

### Build Locally

```
stack build --fast
```

### Deploy

Deployment is handled by the serverless framework.

```
sls deploy
```

