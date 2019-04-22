# HTTP-Proxy-Lambda

This is a CORS-enabled HTTP Proxy using Haskell and AWS Lambda to achieve a type-safe, low-cost, and highly-maintainable experience. 

This has been deployed to AWS Lamda, which you can access here:

https://ios10m3q6k.execute-api.us-east-1.amazonaws.com/dev/endpoint/bbc.co.uk

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

