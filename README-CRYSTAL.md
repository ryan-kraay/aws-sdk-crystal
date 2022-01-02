# Purpose

# Generating Crystal Code

To run the code generate, you can run:

```bash
DEST_SUFFIX=cr PREFIX_DEST_PATH=/crystal-lang bundle exec rake
```

The process for code generation is as follows:
1. `PREFIX_DEST_PATH` is _relative_ to the project root.
1. The `PREFIX_DEST_PATH` will be created, if it does not exist.
1. If `PREFIX_DEST_PATH` _does_ exist, then **all** files that end in `DEST_SUFFIX` will be _temporarily_ renamed to `rb`.
1. A variant of `rake build` will be called.  This will generate/update the `.rb` files.
1. All `.rb` files are named to `DEST_SUFFIX`

# Running RSpec Tests

To execute all the tests, you can run:

```bash
PREFIX_DEST_PATH=/crystal-lang bundle exec rake test:spec
```

To execute a specific gem's tests, you can run (for example aws-sdk-core):

```bash
PREFIX_DEST_PATH=/crystal-lang bundle exec rake test:spec:aws-sdk-core
```

**NOTE**:  Support for running _all_ unit tests is limited, as we have not integrated the (cucumber)[https://github.com/ryan-kraay/aws-sdk-crystal/issues/9) tests.
