import json
from tweepy import OAuthHandler, Stream, StreamListener
from datetime import datetime
import os

consumer_key = os.getenv('consumer_key')
consumer_secret = os.getenv('consumer_secret')
access_token = os.getenv('access_token')
access_token_secret = os.getenv('access_token_secret')

todays_date = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")

out = open(f"/raw-data/collected_tweets_{todays_date}.txt", "w")

class MyListener(StreamListener):

  def on_data(self, data):
    itemString = json.dumps(data)
    out.write(itemString + "\n")
    return True
  
  def on_error(self, status):
    print(status)

if __name__ == "__main__":
  listener = MyListener()
  auth = OAuthHandler(consumer_key, consumer_secret)
  auth.set_access_token(access_token, access_token_secret)

  stream = Stream(auth, listener)
  stream.filter(track=["lockdown"])