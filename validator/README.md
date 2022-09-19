## Prerequisites

1. Ensure that you’re using a recent [Node.js][1] version.
2. Clone this git repo.
3. navigate to this directory and install the node_modules.
    
    ```
    npm install
    ```

4. Run `check-metadata.js` against policies with metadata. For example:

    ```
    node $ROOT/validator/check-metadata.js $ROOT/samples/custom_snippet_samples.rego
    ```

[1]: https://nodejs.org/en/download/
