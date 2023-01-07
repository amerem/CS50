from pytube import YouTube

def Download(link):
  youtubeObject = YouTube(link)
  youtubeObject = youtubeObject.streams.get_highest_resolution()
  try:
    youtubeObject.download()
  except:
    print("Oops, error while downloading video")
  print("Download has completed")

link = input("Put URL here. URL: ")
Download(link)