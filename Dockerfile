FROM cloudgear/ruby:2.2

RUN apt-get update -qq && apt-get install -qq -y build-essential nodejs software-properties-common nginx git libxrender1

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx

RUN mkdir /app
WORKDIR /app

ENV RAILS_ENV production

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD nginx-sites.conf /etc/nginx/sites-enabled/default

ADD config/unicorn.rb /app/config/unicorn.rb
ADD Procfile /app/Procfile

ADD . /app
RUN mkdir /pdfs

CMD foreman start -f Procfile
