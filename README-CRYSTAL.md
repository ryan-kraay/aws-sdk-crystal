# Purpose


# Generating Crystal Code

To run the code generate, you can run:

```bash
DEST_SUFFIX=cr PREFIX_DEST_PATH=/demo bundle exec rake build
```

The process for code generation is as follows:
1. `PREFIX_DEST_PATH` is _relative_ to the project root.
1. The `PREFIX_DEST_PATH` will be created, if it does not exist.
1. If `PREFIX_DEST_PATH` _does_ exist, then **all** files that end in `DEST_SUFFIX` will be _temporarily_ renamed to `rb`.
1. A variant of `rake build` will be called.  This will generate/update the `.rb` files.
1. All `.rb` files are named to `DEST_SUFFIX`

# TODO
* Explore creating a tree of symlinks instead of copying files.  This could be more maintainable.
