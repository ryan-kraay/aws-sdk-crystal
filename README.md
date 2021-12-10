## Introduction

This is an _unofficial_ **attempt** to port the [aws-sdk-ruby](https://github.com/aws/aws-sdk-ruby) to the [Crystal](https://crystal-lang.org/) Programming Language.

At the moment this project is entirely non-functional, but the goal of this project is to create a _maintainable_ Crystal fork of the `aws-sdk-ruby`.

This means:
 * Making the _least_ amount of changes, which will improve the likelihood that futures changes in our upstream will "just work".
 * Reusing and slightly adjusting the existing Ruby code generator to emit valid Crystal Code.  This means using ruby and ruby tools, when necessary.
 * Try to maintain compatibility with the official aws-sdk-ruby, but acknowledging that there are differences between Crystal and Ruby.
 * Port the existing unit tests to verify that aws-sdk-crystal is functionally identical.

## The Roadmap

**NOTE**:  This may not be 100% up-to-date.

### Phase 1:  Feasibility Study

 * [X] Determine how much code variation there is between Ruby and Crystal.
 * [X] Determine how much code variation there is to run the existing Spec Tests.
 * [X] Determine how much effort would be necessary to adjust the aws-sdk-ruby code generator.

### Phase 2:  Functionally Complete

The emphasis of this project will be ease of maintainability and being functionally complete.

 * [ ] Create a Dockerfile to run the code generator.
 * [ ] Update the code generator to emit `.cr` files instead of `.rb`.
 * [ ] Manually migrate the core libraries' spec.
 * [ ] Manually migrate the "core" libraries.

### Phase 3:  Optimizations

The results of Phase 2 will **not** be optimized for memory (ie: the use of `class` vs `struct`) nor will it be optimized for performance (ie: the use of `Tuple` types vs `List`).

How far we can push this, depends entirely on how extensive the changes will be and how much compatibility we will lose with our upstream.
