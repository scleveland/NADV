FROM ruby:1.9.3

# Install dependencies
RUN apt-get update && apt-get install -qq -y build-essential nodejs npm

# Create app directory
RUN mkdir -p /app

WORKDIR /app


COPY Gemfile /app/
COPY Gemfile.lock /app/


RUN bundle install
ADD . /app/
# Default command to run
CMD ["rails", "s"]

EXPOSE 3000