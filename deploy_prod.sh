#!/bin/bash
cd web
git push -f git@heroku.com:coneco-cat-web.git $CIRCLE_SHA1:refs/heads/master
heroku run bundle exec rake db:migrate --app coneco-cat-web
