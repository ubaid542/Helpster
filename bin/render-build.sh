#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Node and Yarn (for cssbundling-rails)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
apt-get install -y nodejs && \
npm install --global yarn

bundle install
yarn install --check-files
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
