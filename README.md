# HTTP-Proxy-Lambda

This is a CORS-enabled HTTP Proxy using Haskell and AWS Lambda to achieve a type-safe, low-cost, and highly-maintainable experience. 

## Development

### Dependencies

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

