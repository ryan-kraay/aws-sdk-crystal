##
## Our Toolkit/Development Image
##
## Simply run: docker run -v $(pwd):/code -it --rm aws-sdk-crystal:toolkit bash
##

FROM crystallang/crystal:1.2.2-build AS toolkit

ENV PURE_RUBY=yes

RUN apt update && apt install -y --no-install-recommends \
      # The tools necessary to run the code generator
      bundler rake ruby-dev \
      # Other tools to make life a bit easier
      vim-tiny && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /code

WORKDIR /code

# Install the bundled gems - independent of any code changes
COPY Gemfile* /code/
RUN bundle install --with=build && \
    # We will copy the generate Gemfile.lock "just in case"
    # TODO(rkr): Clean-up this workflow
    cp Gemfile* /opt/

USER 1001:1001

##
## Some Future Noise...
##
#FROM toolkit AS builder
#
#RUN bundle exec rake build
