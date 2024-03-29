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
RUN RAILS_ENV=production bundle exec rake assets:precompile
# Default command to run
#CMD ["rails", "s"]
EXPOSE ${PORT}
#CMD ["sh", "-c","rails server -b 0.0.0.0 -p ${PORT}"]
CMD RAILS_ENV=production bundle exec rails server -b 0.0.0.0 -p $PORT