#!/bin/bash
cd web
heroku run bundle exec rake db:migrate --app coneco-cat-web
git push git@heroku.com:coneco-cat-web.git $CIRCLE_SHA1:refs/heads/master