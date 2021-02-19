# example

To generate example spec:

```bash
swaggery --file=./examples/spec --examples=./examples --output=spec.json
```

To preview the generated documentation:

```bash
openapi preview-docs ./spec.json
```

To install the `openapi` CLI:

```bash
npm install -g @redocly/openapi-cli
```