import json
import tweepy
from datetime import datetime
import os
import pandas as pd
import sys

def create_user_locs(tweets):
  
  user_locs = []
  for tweet in tweets:
    username = str(tweet.user.screen_name.lower().encode('ascii',errors='ignore'))
    description = str(tweet.user.description.lower().encode('ascii',errors='ignore'))
    location = str(tweet.user.location.lower().encode('ascii',errors='ignore'))
    following = str(str(tweet.user.friends_count).lower().encode('ascii',errors='ignore'))
    followers = str(str(tweet.user.followers_count).lower().encode('ascii',errors='ignore'))
    totaltweets = str(str(tweet.user.statuses_count).lower().encode('ascii',errors='ignore'))
    retweetcount = str(str(tweet.retweet_count).lower().encode('ascii',errors='ignore'))
    text = str(tweet.text.lower().encode('ascii',errors='ignore'))
    
    th_tweet = [username, description, location, following,
                      followers, totaltweets, retweetcount, text]
    
    user_locs.append(th_tweet)

  return user_locs

def create_csv(data, file_name):
  df = pd.DataFrame(data=data,columns=['username', 'description', 'location', 'following',
                                'followers', 'totaltweets', 'retweetcount', 'text'])
  df.to_csv(file_name)


if __name__ == "__main__":
  consumer_key = os.getenv('consumer_key')
  consumer_secret = os.getenv('consumer_secret')
  access_token = os.getenv('access_token')
  access_token_secret = os.getenv('access_token_secret')

  hashtag = sys.argv[1] + " -filter:retweets"
  # date_since format = yyyy-mm-dd
  date_since = sys.argv[2]
  number_items = int(sys.argv[3])
  file_name = sys.argv[4]

  auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
  auth.set_access_token(access_token, access_token_secret)
  api = tweepy.API(auth, wait_on_rate_limit=True)

  tweets = tweepy.Cursor(api.search,
              q=hashtag,
              lang="pt",
              since=date_since).items(number_items)

  data = create_user_locs(tweets)

  create_csv(data, file_name)