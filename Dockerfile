FROM ruby:2.6.3

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y imagemagick build-essential libpq-dev &&\
  apt-get install -y git curl htop postgresql-client vim

RUN apt-get install openssl

# 安装nodejs以及yarn
WORKDIR /root
RUN wget https://cdn.npm.taobao.org/dist/node/latest-v12.x/node-v12.11.1-linux-x64.tar.xz
RUN tar -xf node-v12.11.1-linux-x64.tar.xz
ENV NODE_HOME=/root/node-v12.11.1-linux-x64
ENV PATH=$PATH:$NODE_HOME/bin
ENV NODE_PATH=$NODE_HOME/lib/node_modules
RUN npm config set registry https://registry.npm.taobao.org && npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
RUN npm install -g yarn
#RUN yarn config set registry https://registry.npm.taobao.org && yarn config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/

# 安装rails相关内容
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN gem install bundler rake rails

ENV APP_HOME /rubytoolbox
ENV GEMFILE_RUBY 1

WORKDIR $APP_HOME
ADD Gemfile Gemfile.lock $APP_HOME/
RUN bundle config set without 'development test'
RUN rm -rf /usr/local/bundle/ruby/2.6.0/cache
RUN bundle install --jobs=20

ADD package.json yarn.lock $APP_HOME/
RUN yarn install

COPY . $APP_HOME

# RUN bundle exec rake assets:precompile RAILS_ENV=production

CMD ["foreman", "start"]
# docker build -t ohio_rails .
